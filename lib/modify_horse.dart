import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../mongodb.dart';

class ModifyHorsePage extends StatefulWidget {
  const ModifyHorsePage(
      {super.key, required this.db, required this.user, required this.title});

  final String title;
  final db;
  final user;

  @override
  State<ModifyHorsePage> createState() => _ModifyHorsePageState();
}

class _ModifyHorsePageState extends State<ModifyHorsePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController robeController = TextEditingController();
  TextEditingController raceController = TextEditingController();
  TextEditingController sexeController = TextEditingController();

  // TextEditingController linkFfeController = TextEditingController();

  var dressage = false;
  var saut = false;
  var endurance = false;
  var complet = false;
  var inital = false;

  @override
  void initState() {
    super.initState();
    // findHorseSpecialities();
  }

  @override
  Widget build(BuildContext context) {
    Map? horse = ModalRoute.of(context)?.settings.arguments as Map?;

    setState(() {
      if (!inital) {
        nameController.text = horse!['name'];
        ageController.text = horse['age'].toString();
        robeController.text = horse['robe'];
        raceController.text = horse['race'];
        sexeController.text = horse['sexe'];

        for (var i = 0; i < horse!['speciality'].length; i++) {
          if (horse['speciality'][i] == 'dressage') {
            dressage = true;
          }
          if (horse['speciality'][i] == 'saut d\'obstacle') {
            saut = true;
          }
          if (horse['speciality'][i] == 'endurance') {
            endurance = true;
          }
          if (horse['speciality'][i] == 'complet') {
            complet = true;
          }
        }

        inital = true;
      }
    });

    // void findHorseSpecialities(){
    //   for (var i = 0; i < horse!['specialities'].length; i++) {
    //     if (horse['specialities'][i] == 'dressage') {
    //       dressage = true;
    //     }
    //     if (horse['specialities'][i] == 'saut') {
    //       saut = true;
    //     }
    //     if (horse['specialities'][i] == 'endurance') {
    //       endurance = true;
    //     }
    //     if (horse['specialities'][i] == 'complet') {
    //       complet = true;
    //     }
    //   }
    // }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(15.0),
            children: <Widget>[
              Center(
                child: SizedBox(
                  width: 300,
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.only(top: 20, bottom: 20),
                        child: Text(
                          'Modifier mon cheval ${horse!["name"]}',
                          style: const TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      Container(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: TextField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Nom',
                          ),
                          controller: nameController,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: TextField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Age',
                          ),
                          controller: ageController,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: TextField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Robe',
                          ),
                          controller: robeController,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: TextField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Race',
                          ),
                          controller: raceController,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: TextField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Sexe',
                          ),
                          controller: sexeController,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: CheckboxListTile(
                          checkColor: Colors.white,
                          title: const Text('Dressage'),
                          // fillColor: MaterialStateProperty.resolveWith(getColor),
                          value: dressage,
                          onChanged: (bool? value) {
                            setState(() {
                              dressage = value!;
                              print(dressage);
                            });
                          },
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: CheckboxListTile(
                          checkColor: Colors.white,
                          title: const Text('Saut d\'obstacle'),
                          // fillColor: MaterialStateProperty.resolveWith(getColor),
                          value: saut,
                          onChanged: (bool? value) {
                            setState(() {
                              saut = value!;
                              print(saut);
                            });
                          },
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: CheckboxListTile(
                          checkColor: Colors.white,
                          title: const Text('Endurance'),
                          // fillColor: MaterialStateProperty.resolveWith(getColor),
                          value: endurance,
                          onChanged: (bool? value) {
                            setState(() {
                              endurance = value!;
                              print(endurance);
                            });
                          },
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: CheckboxListTile(
                          checkColor: Colors.white,
                          title: const Text('Complet'),
                          // fillColor: MaterialStateProperty.resolveWith(getColor),
                          value: complet,
                          onChanged: (bool? value) {
                            setState(() {
                              complet = value!;
                              print(complet);
                            });
                          },
                        ),
                      ),
                      // Button to login
                      ElevatedButton(
                        onPressed: () async {
                          var speciality = [];

                          if (dressage == true) {
                            speciality.add("dressage");
                          }
                          if (saut == true) {
                            speciality.add("saut d'obstacle");
                          }
                          if (endurance == true) {
                            speciality.add("endurance");
                          }
                          if (complet == true) {
                            speciality.add("complet");
                          }

                          print(speciality);
                          var name = nameController.text;
                          var age = ageController.text;
                          var robe = robeController.text;
                          var race = raceController.text;
                          var sexe = sexeController.text;

                          await widget.db.collection('horse').updateOne(
                              MongoDatabase.searchWhere('_id', horse['_id']), {
                            '\$set': {
                              'name': name,
                              'age': int.parse(age),
                              'robe': robe,
                              'race': race,
                              'sexe': sexe,
                              'speciality': speciality
                            }
                          });

                          // await widget.db
                          //     .collection('user')
                          //     .updateOne(MongoDatabase.searchWhere('_id', widget.user["_id"]), {
                          //   '\$set': {
                          //     'username': usernameController.text,
                          //     'email': emailController.text,
                          //     'password': passwordController.text,
                          //     'phoneNumber': int.parse(phoneNumber),
                          //     'age': int.parse(age),
                          //     'linkFfe': linkFfe,
                          //     'image': image,
                          //   }
                          // });

                          // var newUser = await widget.db
                          //     .collection('user')
                          //     .find(MongoDatabase.searchWhere('_id', widget.user["_id"]))
                          //     .toList();
                          //
                          // print(newUser);
                          //
                          // // Push to home page with user data
                          // Navigator.pushNamed(context, '/main', arguments: newUser[0]);
                        },
                        child: const Text('Mettre à jour'),
                      ),
                    ],
                  ),
                ),
              ),
            ]),
      ),
    );
  }
}
