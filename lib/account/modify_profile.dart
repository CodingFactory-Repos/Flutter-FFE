import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../mongodb.dart';
import 'chose_image.dart';

class ModifyProfilePage extends StatefulWidget {
  const ModifyProfilePage({super.key, required this.db, required this.user, required this.title});

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
  State<ModifyProfilePage> createState() => _ModifyProfilePageState();
}

class _ModifyProfilePageState extends State<ModifyProfilePage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController linkFfeController = TextEditingController();

  var image = 'assets/images/profile.png';

 @override
  void initState() {
    super.initState();
    usernameController.text = widget.user['username'];
    emailController.text = widget.user['email'];
    passwordController.text = widget.user['password'];
    chekUser();
    setState(() {
      image = widget.user['image'];
    });
  }

  void chekUser(){
    if(widget.user['phoneNumber'] != null || widget.user['age'] != null || widget.user['linkFfe'] != null){
      phoneNumberController.text = widget.user['phoneNumber'].toString();
      ageController.text = widget.user['age'].toString();
      linkFfeController.text = widget.user['linkFfe'];
    }
  }

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
        // Here we take the value from the TemplatePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child:ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(15.0),
          children: <Widget>[
            Center(
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
                    InkWell(
                      onTap: () {
                        _navigateAndDisplaySelection(context);
                      }, // Handle your callback.
                      splashColor: Colors.brown.withOpacity(0.5),
                      child: Ink(
                        height: 200,
                        width: 200,
                        decoration:  BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(image),

                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding:  const EdgeInsets.only(top: 20, bottom: 20),
                      child:   const Text(
                        'Modifier mon compte',
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
                          labelText: 'Email',
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
                    Container(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: TextField(
                        // initialValue: widget.user['phone'],
                        controller: phoneNumberController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Numéro de téléphone',
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: TextField(
                        controller: ageController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Age',
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: TextField(
                        controller: linkFfeController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Profil FFE',
                        ),
                      ),
                    ),
                    // Button to login
                    ElevatedButton(
                      onPressed: () async {
                        // Create loading dialog
                        // showDialog(
                        //   context: context,
                        //   barrierDismissible: false,
                        //   builder: (BuildContext context) {
                        //     return const Center(
                        //       child: CircularProgressIndicator(),
                        //     );
                        //   },
                        // );


                          // for (var i = 0; i < widget.user['dpHorse'].length; i++) {
                          //   print(widget.user['dpHorse'][i]);
                          //
                          //   var horse = await widget.db.collection('horse').find(MongoDatabase.searchWhere('_id', widget.user['dpHorse'][i])).toList();
                          //   print(horse);
                          // }

                        var phoneNumber = phoneNumberController.text;
                        var age = ageController.text;
                        var linkFfe = linkFfeController.text;

                        await widget.db
                            .collection('user')
                            .updateOne(MongoDatabase.searchWhere('_id', widget.user["_id"]), {
                          '\$set': {
                            'username': usernameController.text,
                            'email': emailController.text,
                            'password': passwordController.text,
                            'phoneNumber': int.parse(phoneNumber),
                            'age': int.parse(age),
                            'linkFfe': linkFfe,
                            'image': image,
                          }
                        });

                        // Close the loading dialog
                        // Navigator.of(context).pop();
                        // Navigator.of(context).pop();

                        // Go to the login page
                        // Navigator.pop(context);
                      },
                      child: const Text('Mettre à jour'),
                    ),
                  ],
                ),
              ),
            ),
          ]
        ),
      ),
    );
  }
  Future<void> _navigateAndDisplaySelection(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ChoseImage(db: null, title: 'Choisir une image',)),
    );
    
    if (!mounted) return;
    setState(() {
      image = result;
    });
  }
}