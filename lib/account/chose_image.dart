import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'register.dart';

import '../mongodb.dart';


//list of images


class ChoseImage extends StatefulWidget {
  const ChoseImage({super.key, required this.db, required this.title});

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
  State<ChoseImage> createState() => _ChoseImageState();
}


class _ChoseImageState extends State<ChoseImage> {

  List<String> images = [
    'assets/images/0.png',
    'assets/images/1.png',
    'assets/images/2.png',
    'assets/images/3.png',
    'assets/images/4.png',
    'assets/images/5.png',
  ];

  // -- Variables --
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // -- Methods --
  /// > The function creates a loading dialog, checks if the email and password are
  /// correct, and if they are, it sends the user to the home page
  ///
  /// Returns:
  ///   The user's information


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
        // Here we take the value from the LoginPage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body:  GridView.count(
      crossAxisCount: 3,
    children: List.generate(images.length, (index) {
      return Center(
       child: InkWell(
          onTap: () {
            Navigator.pop(context, images[index]);
          }, // Handle your callback.

         child: Image.asset(images[index]),
         ),
       );
      }
     ),
      ),
      );
  }
}
