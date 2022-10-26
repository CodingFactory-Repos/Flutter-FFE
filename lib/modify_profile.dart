import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'mongodb.dart';

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
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController linkFfeController = TextEditingController();



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

                  var phoneNumber = phoneNumberController.text;
                  var age = ageController.text;
                  var linkFfe = linkFfeController.text;

                  await widget.db
                      .collection('user')
                      .updateOne(MongoDatabase.searchWhere('_id', widget.user["_id"]), {
                    '\$set': {'phoneNumber': int.parse(phoneNumber), 'age': int.parse(age), 'linkFfe': linkFfe}
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
    );
  }
}
