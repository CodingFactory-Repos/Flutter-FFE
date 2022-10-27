import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.db, required this.user, required this.title});

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
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // -- Variables --
  var feed = [];
  var lastUser = [{}];

  @override
  void initState() {
    super.initState();
    getFeed();
    getLastUser();
  }

  // -- Methods --
  void getFeed() async {
    var feed = await widget.db.collection('feed').find().toList();

    // Don't show the feed if the date has already passed
    for (var i = 0; i < feed.length; i++) {
      if (feed[i]['date'].isBefore(DateTime.now())) {
        feed.removeAt(i);
      }
    }

    // Sort the feed by date (newest first)
    for (var i = 0; i < feed.length; i++) {
      for (var j = 0; j < feed.length; j++) {
        if (feed[i]['date'].isAfter(feed[j]['date'])) {
          var temp = feed[i];
          feed[i] = feed[j];
          feed[j] = temp;
        }
      }
    }

    // limit to 5 items
    if (feed.length > 5) {
      feed = feed.sublist(0, 5);
    }

    setState(() {
      this.feed = feed.reversed.toList();
    });
  }

  void getLastUser() async {
    var users = await widget.db.collection('user').find().toList();

    // Remove the current user
    users.removeWhere((element) => element['username'] == widget.user['username']);

    var lastUser = users.sublist(users.length - 1, users.length);

    setState(() {
      this.lastUser = lastUser;
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
        actions: [
          IconButton(
            icon: const Icon(Icons.bedroom_baby),
            onPressed: () {
              // _navigateAndDisplaySelection(context);
              Navigator.pushNamed(context, '/myHorse');
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              // _navigateAndDisplaySelection(context);
              Navigator.pushNamed(context, '/modify_profile');
            },
          ),
        ],
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
                'Évenements a venir',
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
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 20.0),
                    height: 250.0,
                    child: ListView(
                      // This next line does the trick.
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        // In container, create a border rounded card with a image, title and a subtitle
                        for (var item in feed)
                          if (item['type'] == "competition")
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
                                      child: Image.asset(
                                          'assets/images/competition-banner.jpg'),
                                    ),
                                    ListTile(
                                      title: Text("${item['title']}"),
                                      subtitle: Container(
                                        // Add the item description and the item location
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                                  Text(
                                                      "${item['location']} - "),
                                                  const Icon(
                                                    Icons.calendar_today,
                                                    size: 15,
                                                  ),
                                                  Text(item['date']
                                                      .toString()
                                                      .substring(0, 10)
                                                      .replaceAll("-", "/")),
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
                        ),

                        Card(
                          child: ListTile(
                            leading: const Icon(Icons.person,
                                size: 50),
                            title: Text("${lastUser[0]['username'] ?? "No user found"}",
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                )),
                            subtitle: Text(
                                "Nous a rejoins le ${lastUser[0]['accountCreatedAt'] != null ? lastUser[0]['accountCreatedAt'].toString().substring(0, 10).replaceAll("-", "/") : "No date found"}"),
                          ),
                        ),

                        Container(
                          // Create text en align left
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(
                              top: 5, bottom: 5, left: 10),
                          child: const Text(
                            'Pour toi',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        // In container, create a border rounded card with a image, title and a subtitle
                        for (var item in feed)
                          // If the date is depassed, don't show the item
                          if (item['date'].isAfter(
                              DateTime.now().add(const Duration(hours: -12))))
                            SizedBox(
                                width: 300.0,
                                // If the item is have username, it's a user and create card with user icon on left and user username as title on right
                                child: Card(
                                  // If the item is have title, it's a competition and create card with competition icon on left and competition title as title on right
                                  child: ListTile(
                                    leading:
                                        const Icon(Icons.flag, size: 50),
                                    title: Text("${item['title']}",
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        )),
                                    subtitle: Text(
                                        "A lieu le ${item['date'].toString().substring(0, 10).replaceAll("-", "/")}"),
                                  ),
                                )),
                      ],
              )
              )
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/addEvent');
        },
        label: const Text('Ajouter un événement'),
        icon: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat
    );
  }
}
