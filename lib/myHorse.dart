import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'mongodb.dart';

class MyHorsePage extends StatefulWidget {
  const MyHorsePage(
      {super.key, required this.db, required this.user, required this.title});

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
  State<MyHorsePage> createState() => _MyHorsePageState();
}

class _MyHorsePageState extends State<MyHorsePage> {
  // -- Variables --
  var dpHorse = [];

  @override
  void initState() {
    super.initState();
    getDpHorse();
  }

  // -- Methods --
  void getDpHorse() async {
    var dpHorse = [];

    if(widget.user['dpHorse'] != null) {
      for (var i = 0; i < widget.user['dpHorse'].length; i++) {
        var horse = await widget.db.collection('horse').findOne({
          '_id': widget.user['dpHorse'][i],
        });

        dpHorse.add(horse);
      }
    }

    setState(() {
      this.dpHorse = dpHorse;
    });
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
        // Here we take the value from the HomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
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
          children: <Widget>[
            Container(
              // Create text en align left
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(top: 20, bottom: 5, left: 10),
              child: const Text(
                'Modifier mes chevaux',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
                child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: ListView(
                // This next line does the trick.
                scrollDirection: Axis.vertical,
                children: <Widget>[
                  if (dpHorse.isEmpty)
                    // On middle of the screen a text
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 3, left: 20, right: 20),
                      child: const Text(
                        'Vous n\'avez pas de chevaux, ajoutez-en un !',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  // In container, create a border rounded card with a image, title and a subtitle
                  for (var item in dpHorse)
                    SizedBox(
                      width: 300.0,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Wrap(
                          children: <Widget>[
                            // Add image with border
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(15.0),
                                topRight: Radius.circular(15.0),
                              ),
                              child: Image.network(
                                  'https://www.classequine.com/wp-content/uploads/2021/${item['picture']}'),
                            ),
                            ListTile(
                              title: Text("${item['name']}"),
                              subtitle: Container(
                                // Add the item description and the item location
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text("${item['description']}"),
                                    Container(
                                      padding: const EdgeInsets.only(
                                          top: 5, bottom: 5),
                                      child: Row(
                                        children: <Widget>[
                                          const Icon(
                                            Icons.location_on,
                                            size: 15,
                                          ),
                                          Text("${item['name']} - "),
                                          const Icon(
                                            Icons.calendar_today,
                                            size: 15,
                                          ),
                                          Text("Text"),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}
