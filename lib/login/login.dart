import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../mongodb.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.db, required this.title});

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
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // -- Variables --
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // -- Methods --
  /// > The function creates a loading dialog, checks if the email and password are
  /// correct, and if they are, it sends the user to the home page
  ///
  /// Returns:
  ///   The user's information
  connectToAccount() async {
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
    var email = emailController.text;
    var password = passwordController.text;

    // Check if all fields are not empty
    if (email.isEmpty || password.isEmpty) {
      // Close loading dialog
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Veuillez remplir tous les champs')));
      return;
    }

    var emailQuery = await widget.db
        .collection('user')
        .find(MongoDatabase.searchWhere('email', email))
        .toList();

    if (emailQuery.length == 0) {
      // Email already taken
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('L\'utilisateur n\'existe pas')));
      return;
    }

    // Check if the password is correct
    if (emailQuery[0]['password'] != password) {
      // Password is incorrect
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Le mot de passe est incorrect')));
      return;
    }

    // Close the loading dialog
    Navigator.of(context).pop();

    // Send emailQuery[0] to the home.dart
    Navigator.pushNamed(context, '/main', arguments: emailQuery[0]);
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
        // Here we take the value from the LoginPage object that was created by
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
                  'Se connecter',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
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

              // TextField for password with passwordController
              Container(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: 'mot de passe',
                      suffix: InkWell(
                      child: const Icon(Icons.visibility, color: Colors.grey, size: 20),
                  onTap: (){},
                 ),
                ),
              ),
            ),

              // Button to login
              ElevatedButton(
                onPressed: () {
                  connectToAccount();
                },
                child: const Text('Se connecter'),
              ),

              // Text to register
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/register');
                },
                child: const Text('Pas de compte ? S\'inscrire'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/mdtp_oublie');
                },
                child: const Text('Mot de passe oublier ?'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
