import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
              Image.asset('assets/logo.png', width: 200, height: 200),
              Container(
                padding: const EdgeInsets.only(top: 20, bottom: 20),
                child: const Text(
                  'Mot de passe oublier',
                  style: TextStyle(
                    fontSize: 40,
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
                    labelText: 'Nom',
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
                onPressed: () {},
                child: const Text('Envoyer'),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
