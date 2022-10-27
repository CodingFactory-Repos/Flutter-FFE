import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../mongodb.dart';

class AddEventPage extends StatefulWidget {
  const AddEventPage({super.key, required this.db, required this.title, required this.user});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  final db;
  final user;

  @override
  State<AddEventPage> createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  // -- Variables --
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // -- Methods --
  /// > The function creates a loading dialog, checks if the email and password are
  /// correct, and if they are, it sends the user to the home page
  ///
  /// Returns:
  ///   The user's information
  addEvent() async {
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

    // Close the loading dialog
    Navigator.of(context).pop();

    // Send emailQuery[0] to the home.dart
    Navigator.pushNamed(context, '/home');
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
        // Here we take the value from the AddEventPage object that was created by
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
              Container(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Nom de l\'événement',
                  ),
                ),
              ),

              // Create a date picker
              Container(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Date de l\'événement',
                  ),
                ),
              ),

              // Button to send the user to the home page
              ElevatedButton(
                onPressed: () {
                  addEvent();
                },
                child: const Text('Ajouter l\'événement'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
