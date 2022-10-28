import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AllHorsesPage extends StatefulWidget {
  const AllHorsesPage({super.key, required this.db, required this.user, required this.title});

  final String title;
  final db;
  final user;

  @override
  State<AllHorsesPage> createState() => _AllHorsesPageState();
}

class _AllHorsesPageState extends State<AllHorsesPage> {
  // -- Variables --
  var allHorse = [];
  var ownerHorse = [];

  @override
  void initState() {
    super.initState();
    getAllHorses();
    getOwnerHorse();
  }

  // -- Methods --
  void getAllHorses() async {
    var allHorse = await widget.db.collection('horse').find().toList();

    setState(() {
      this.allHorse = allHorse;
    });
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
      // myHorse['owned']?.addAll(ownerHorse);
    });
    // print(myHorse['owned']);
    print(ownerHorse);
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

                  for(var item in allHorse)
                    Card(
                      child: ListTile(
                        leading: const Icon(Icons.person,
                            size: 50),
                        title: Text("${item['name'] ?? "No user found"}",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            )),
                        // subtitle: Text(
                        //     "Possédé par ${item['accountCreatedAt'] != null ? item['accountCreatedAt'].toString().substring(0, 10).replaceAll("-", "/") : "No date found"}"
                        // ),
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
