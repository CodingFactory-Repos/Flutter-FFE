import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../mongodb.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key, required this.db, required this.title});

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
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // -- Variables --
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // -- Methods --
  /// It creates an account
  ///
  /// Returns:
  ///   A Future<void>
  createAAccount() async {
    {
      // Create loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      // Check if the username and email is already taken
      var username = usernameController.text;
      var email = emailController.text;
      var password = passwordController.text;

      // Check if all fields are not empty
      if (username.isEmpty || email.isEmpty || password.isEmpty) {
        // Close loading dialog
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Veuillez remplir tous les champs')));
        return;
      }

      // Check the email with regex
      if (!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email)) {
        // Close the loading dialog
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('L\'adresse email n\'est pas valide')));
        return;
      }

      var usernameQuery = await widget.db
          .collection('user')
          .find(MongoDatabase.searchWhere('username', username))
          .toList();
      var emailQuery = await widget.db
          .collection('user')
          .find(MongoDatabase.searchWhere('email', email))
          .toList();

      if (usernameQuery.length > 0) {
        // Username already taken
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Ce nom d\'utilisateur est déjà pris')));
        return;
      }

      if (emailQuery.length > 0) {
        // Email already taken
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Cette adresse email est déjà prise')));
        return;
      }

      // Add the user to the database
      await widget.db.collection('user').insertOne(<String, dynamic>{
        'accountCreatedAt': DateTime.now(),
        'username': username,
        'email': email,
        'password': password,
      });

      // Close the loading dialog
      Navigator.of(context).pop();

      // Go to the login page
      Navigator.pop(context);
    }
  }

  // -- Widgets --
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the RegisterPage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: SizedBox(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          // Create a login form
          width: 300,
          child: Column(
            children: <Widget>[
              Image.asset('assets/logo.png', width: 200, height: 200),
              Container(
                padding: const EdgeInsets.only(top: 20, bottom: 20),
                child: const Text(
                  'Créer un compte',
                  style: TextStyle(
                    fontSize: 35,
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

              Container(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Mot de passe',
                  ),
                ),
              ),

              // Button to login
              ElevatedButton(
                onPressed: () {
                  createAAccount();
                },
                child: const Text('Créer un compte'),
              ),

              // Text to login
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Se connecter'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
