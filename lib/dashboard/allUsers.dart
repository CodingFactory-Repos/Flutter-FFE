import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AllUsersPage extends StatefulWidget {
  const AllUsersPage({super.key, required this.db, required this.user, required this.title});

  final String title;
  final db;
  final user;

  @override
  State<AllUsersPage> createState() => _AllUsersPageState();
}

class _AllUsersPageState extends State<AllUsersPage> {
  // -- Variables --
  var feed = [];
  var lastUser = [{}];
  var allUsers = [];
  var ownerHorse = [];

  @override
  void initState() {
    super.initState();
    getLastUser();
    getAllUsers();
    getOwnerHorse();
  }

  // -- Methods --
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
      // myHorse['owned']?.addAll(ownerHorse);
    });
    // print(myHorse['owned']);
    print(ownerHorse);
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

  void getAllUsers() async {
    var users = await widget.db.collection('user').find().toList();
    // Remove the current user
    users.removeWhere((element) => element['username'] == widget.user['username']);

    setState(() {
      allUsers = users;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
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
        child: Column(
          children: <Widget>[
            Container(
              // Create text en align left
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(top: 20, bottom: 5, left: 10),
              child: const Text(
                'Touts les utilisateurs',
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

                  for(var item in allUsers)
                    Card(
                      child: ListTile(
                        leading: const Icon(Icons.person,
                            size: 50),
                        title: Text("${item['username'] ?? "No user found"}",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            )),
                        subtitle:
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            // widget.db.collection('horse').remove({
                            //   '_id': ownerHorse,
                            // });

                            // print(ownerHorse);
                            //delete user
                            widget.db.collection('user').remove({
                              '_id': item['_id'],
                            });
                            getAllUsers();
                          },
                        ),
                      ),
                    ),
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
