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
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController pickedDateController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController plotController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController disciplineController = TextEditingController();

  // -- Methods --
  /// > The function creates a loading dialog, checks if the email and password are
  /// correct, and if they are, it sends the user to the home page
  ///
  /// Returns:
  ///   The user's information
  addEvent() async {
    var name = nameController.text;
    var description = descriptionController.text;
    var date = DateTime.parse(pickedDateController.text);
    var location = locationController.text;
    var plot = plotController.text;
    var time = int.parse(timeController.text);
    var discipline = disciplineController.text;

    // Check if all fields are not empty
    if (name.isEmpty || description.isEmpty || date == null || location.isEmpty || plot.isEmpty || time == null || discipline.isEmpty) {
      // Close loading dialog
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Veuillez remplir tous les champs')));
      return;
    }

    // Add event to database
    await widget.db.collection('feed').insertOne({
      'type': 'competition',
      'title': name,
      'description': description,
      'date': date.add(Duration(hours: DateTime.now().timeZoneOffset.inHours)),
      'location': location,
      'plot': plot,
      'time': time,
      'discipline': discipline,
      'author_id': widget.user['_id']
    });

    // Close the loading dialog

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
              // Type of plot (Événement, Soirée) in a dropdown menu
              

              Container(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Nom de l\'événement',
                  ),
                ),
              ),

              Container(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Description de l\'événement',
                  ),
                ),
              ),

              // Create a date picker with a calandar
              Container(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                width: 300,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        side: const BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    elevation: MaterialStateProperty.all<double>(0),
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      const EdgeInsets.only(top: 10, bottom: 10),
                    ),
                  ),
                  onPressed: () async {
                    // Show a date picker with DateController
                    var pickedDate = (await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(DateTime.now().year),
                      lastDate: DateTime(DateTime.now().year + 5),
                    ))
                        .toString();

                    setState(() {
                      if (pickedDate != "null") {
                        pickedDateController.text = pickedDate;
                      }
                    });
                  },
                  child: Text(pickedDateController.text.isEmpty
                      ? 'Choisir une date'
                      : 'Date choisie: ${pickedDateController.text.substring(0, 10).replaceAll('-', '/')}'),
                ),
              ),

              Container(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: TextField(
                  controller: timeController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Temps de l\'événement (en Minutes)',
                  ),
                ),
              ),

              Container(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: TextField(
                  controller: locationController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Lieu de l\'événement',
                  ),
                ),
              ),

              // Type of plot (Carrière, Manège) in a dropdown menu
              Container(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                width: 300,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        side: const BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    elevation: MaterialStateProperty.all<double>(0),
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      const EdgeInsets.only(top: 10, bottom: 10),
                    ),
                  ),
                  onPressed: () async {
                    // Show a dropdown menu with plotController
                    var plot = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return SimpleDialog(
                          title: const Text('Séléctionner un type de terrain'),
                          children: <Widget>[
                            SimpleDialogOption(
                              onPressed: () {
                                Navigator.pop(context, 'Carrière');
                              },
                              child: const Text('Carrière'),
                            ),
                            SimpleDialogOption(
                              onPressed: () {
                                Navigator.pop(context, 'Manège');
                              },
                              child: const Text('Manège'),
                            ),
                          ],
                        );
                      },
                    );

                    setState(() {
                      if (plot != null) {
                        plotController.text = plot;
                      }
                    });
                  },
                  child: Text(plotController.text.isEmpty
                      ? 'Choisir un type de terrain'
                      : 'Type de terrain: ${plotController.text}'),
                ),
              ),

              // Type of discipline (Dressage / Saut d’obstacle / Endurance) in a dropdown menu
              Container(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                width: 300,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        side: const BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    elevation: MaterialStateProperty.all<double>(0),
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      const EdgeInsets.only(top: 10, bottom: 10),
                    ),
                  ),
                  onPressed: () async {
                    // Show a dropdown menu with disciplineController
                    var discipline = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return SimpleDialog(
                          title: const Text('Séléctionner une discipline'),
                          children: <Widget>[
                            SimpleDialogOption(
                              onPressed: () {
                                Navigator.pop(context, 'Dressage');
                              },
                              child: const Text('Dressage'),
                            ),
                            SimpleDialogOption(
                              onPressed: () {
                                Navigator.pop(context, 'Saut d’obstacle');
                              },
                              child: const Text('Saut d’obstacle'),
                            ),
                            SimpleDialogOption(
                              onPressed: () {
                                Navigator.pop(context, 'Endurance');
                              },
                              child: const Text('Endurance'),
                            ),
                          ],
                        );
                      },
                    );

                    setState(() {
                      if (discipline != null) {
                        disciplineController.text = discipline;
                      }
                    });
                  },
                  child: Text(disciplineController.text.isEmpty
                      ? 'Choisir une discipline'
                      : 'Discipline: ${disciplineController.text}'),
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
