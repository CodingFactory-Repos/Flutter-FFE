import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../mongodb.dart';

class mdtpPage extends StatefulWidget {
  const mdtpPage({super.key, required this.db, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  final db;

  @override
  State<mdtpPage> createState() => _mdtpPageState();
}

class _mdtpPageState extends State<mdtpPage> {
  // -- Variables --
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // -- Methods --
  Future<bool> checkChangePassword() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    var username = usernameController.text;
    var email = emailController.text;

    // Check if all fields are not empty
    if (username.isEmpty || email.isEmpty) {
      // Close loading dialog
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Veuillez remplir tous les champs')));
      return false;
    }

    // Check if the username and email is correct
    var emailQuery = await widget.db
        .collection('user')
        .find(MongoDatabase.searchWhere('email', email))
        .toList();

    if (emailQuery.isEmpty || emailQuery[0]['username'] != username) {
      // Close the loading dialog
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Les données entrées sont incorrectes')));
      return false;
    }

    // Close the loading dialog
    Navigator.pop(context);
    return true;
  }

  changePasswordDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Changer le mot de passe'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: 'Nouveau mot de passe',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
                // Change the password
                var email = emailController.text;
                var password = passwordController.text;

                await widget.db
                    .collection('user')
                    .updateOne(MongoDatabase.searchWhere('email', email), {
                  '\$set': {'password': password}
                });

                // Close the dialog
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Le mot de passe a été changé')));

                // Go back to the login page
                Navigator.pop(context);
              },
              child: const Text('Changer'),
            ),
          ],
        );
      },
    );
  }

  // -- Widgets --
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: SizedBox(
          width: 300,
          child: Column(
            children: <Widget>[
              Image.asset('assets/images/juan.png', width: 200, height: 200),
              Container(
                padding: const EdgeInsets.only(top: 20, bottom: 20),
                child: const Text(
                  'Mot de passe oublier',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              Container(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Nom d\'utilisateur',
                  ),
                ),
              ),

              // TextField for email with emailController
              Container(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Adresse email',
                  ),
                ),
              ),



              // Button to login
              ElevatedButton(
                onPressed: () async {
                  if (await checkChangePassword()) {
                    // Show a dialog to change the password
                    changePasswordDialog();
                  }
                },
                child: const Text('Envoyer'),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
