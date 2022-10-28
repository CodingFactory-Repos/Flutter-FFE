import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'modify_horse.dart';
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
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController robeController = TextEditingController();
  TextEditingController raceController = TextEditingController();
  TextEditingController sexeController = TextEditingController();
  // TextEditingController specialityController = TextEditingController();
  TextEditingController pictureController = TextEditingController();

  var dressage = false;
  var saut = false;
  var endurance = false;


  // -- Variables --
  var dpHorse = [];
  var ownerHorse = [];
  var myHorse = {
    "dp": [],
    "owned": [],
  };
  var allHorse = [];
  var unownedHorse = [];

  var horse ='';

  @override
  void initState() {
    super.initState();
    getDpHorse();
    getOwnerHorse();
    getAllHorse();
    getUnownedHorse();
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
      myHorse['dp']?.addAll(dpHorse);
    });
    // print(myHorse['dp']);
  }

  void getOwnerHorse() async {
    var ownerHorse = [];

    if(widget.user['ownerHorse'] != null) {
      for (var i = 0; i < widget.user['ownerHorse'].length; i++) {
        var horse = await widget.db.collection('horse').findOne({
          '_id': widget.user['ownerHorse'][i],
        });

        ownerHorse.add(horse);
      }
    }

    setState(() {
      this.ownerHorse = ownerHorse;
      myHorse['owned']?.addAll(ownerHorse);
    });
    // print(myHorse['owned']);
  }


  void getAllHorse() async {
    var allHorse = await widget.db.collection('horse').find().toList();

    // print(allHorse);
    setState(() {
      this.allHorse = allHorse;
    });
  }

  // get horses that user don't own
  Future<void> getUnownedHorse() async {
    var unownedHorse = [];
    await widget.db.collection('horse').find().forEach((horse) {
      if (widget.user['ownerHorse'].contains(horse['_id']) == false && widget.user['dpHorse'].contains(horse['_id']) == false) {
        unownedHorse.add(horse);
      }
    });

    // print(unownedHorse);
    setState(() {
      this.unownedHorse = unownedHorse;
    });
  }

  @override
  Widget build(BuildContext context) {
    Map? horse = ModalRoute.of(context)?.settings.arguments as Map?;
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.red;
    }
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
            Expanded(
                child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: ListView(
                // This next line does the trick.
                scrollDirection: Axis.vertical,
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
                  for (var item in myHorse['owned']!)
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
                              title: Text("${item['name']} (owner)"),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text("${item['race']}"),
                                  Container(
                                    padding: const EdgeInsets.only(
                                        top: 5, bottom: 5),
                                    child: Row(
                                      children: <Widget>[

                                        const Icon(
                                          Icons.cake,
                                          size: 15,
                                        ),
                                        Text(" ${item['age']} - "),
                                        if(item['sexe'] == 'female')
                                          const Icon(
                                            Icons.female,
                                            size: 15,
                                          ),
                                        if(item['sexe'] == 'male')
                                          const Icon(
                                            Icons.male,
                                            size: 15,
                                          ),
                                        Text(" ${item['sexe']}"),
                                         Container(
                                           padding:  const EdgeInsets.only(left: 150),
                                          //change color of button
                                          child:  ElevatedButton(
                                            onPressed: (){
                                              // _navigateAndDisplaySelection(context);
                                              Navigator.pushNamed(context, '/modify_horse', arguments: item);
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.orange,
                                            ),
                                            child: const Text('Modifier'),
                                          ),
                                        )

                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  for (var item in myHorse['dp']!)
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
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text("${item['race']}"),
                                  Container(
                                    padding: const EdgeInsets.only(
                                        top: 5, bottom: 5),
                                    child: Row(
                                      children: <Widget>[
                                        const Icon(
                                          Icons.cake,
                                          size: 15,
                                        ),
                                        Text(" ${item['age']} - "),
                                        if(item['sexe'] == 'female')
                                          const Icon(
                                            Icons.female,
                                            size: 15,
                                          ),
                                        if(item['sexe'] == 'male')
                                          const Icon(
                                            Icons.male,
                                            size: 15,
                                          ),
                                        Text(" ${item['sexe']}")
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  Container(
                    // Create text en align left
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(top: 20, bottom: 5, left: 10),
                    child: const Text(
                      'Chevaux disponibles',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  for (var item in unownedHorse)
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
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text("${item['race']}"),
                                  Container(
                                    padding: const EdgeInsets.only(
                                        top: 5, bottom: 5),
                                    child: Row(
                                      children: <Widget>[
                                        const Icon(
                                          Icons.cake,
                                          size: 15,
                                        ),
                                        Text(" ${item['age']} - "),
                                        if(item['sexe'] == 'female')
                                          const Icon(
                                            Icons.female,
                                            size: 15,
                                          ),
                                        if(item['sexe'] == 'male')
                                          const Icon(
                                            Icons.male,
                                            size: 15,
                                          ),
                                        Text(" ${item['sexe']}"),
                                        Container(
                                          padding:  const EdgeInsets.only(left: 80),
                                          //change color of button
                                          child:  ElevatedButton(
                                            onPressed: () async {
                                              // _navigateAndDisplaySelection(context);
                                              // Navigator.pushNamed(context, '/modify_horse', arguments: item);

                                              // myHorse['dp']!.add(item);

                                              var myNewHorse = [];

                                              for (var i = 0; i < myHorse['dp']!.length; i++) {
                                                myNewHorse.add(myHorse['dp']![i]['_id']);
                                              }

                                              myNewHorse.add(item['_id']);

                                              print(myNewHorse);

                                              await widget.db.collection('user').updateOne(
                                                  MongoDatabase.searchWhere('_id', widget.user['_id']), {
                                                '\$set': { 'dpHorse': myNewHorse }
                                              });

                                              setState(() {
                                                myHorse['dp']!.add(item);
                                                unownedHorse.remove(item);
                                              });

                                              print(item['_id']);


                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.orange,
                                            ),
                                            child: const Text('+ DP'),
                                          ),
                                        ),
                                        Container(
                                          padding:  const EdgeInsets.only(left: 20),
                                          //change color of button
                                          child:  ElevatedButton(
                                            onPressed: () async {
                                              // _navigateAndDisplaySelection(context);
                                              // Navigator.pushNamed(context, '/modify_horse', arguments: item);

                                              var myNewHorse = [];

                                              for (var i = 0; i < myHorse['owned']!.length; i++) {
                                                myNewHorse.add(myHorse['owned']![i]['_id']);
                                              }

                                              myNewHorse.add(item['_id']);

                                              print(myNewHorse);

                                              await widget.db.collection('user').updateOne(
                                                  MongoDatabase.searchWhere('_id', widget.user['_id']), {
                                                '\$set': { 'ownerHorse': myNewHorse }
                                              });

                                              setState(() {
                                                myHorse['owned']!.add(item);
                                                unownedHorse.remove(item);
                                              });

                                              print(item['_id']);


                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.orange,
                                            ),
                                            child: const Text('+ owner'),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
                ),
              )
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/addHorse');
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
  // Future<void> _navigateAndDisplaySelection(BuildContext context) async {
  //   // Navigator.push returns a Future that completes after calling
  //   // Navigator.pop on the Selection Screen.
  //   final result = await Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => const ModifyHorsePage(db: null, title: 'Modifier un cheval', user: null)),
  //   );
  //
  //   // When a BuildContext is used from a StatefulWidget, the mounted property
  //   // must be checked after an asynchronous gap.
  //   if (!mounted) return;
  //
  //   // After the Selection Screen returns a result, hide any previous snackbars
  //   // and show the new result.
  //
  //   setState(() {
  //     horse = result;
  //   });
  // }
}
