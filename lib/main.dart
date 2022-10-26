import 'package:flutter/material.dart';
import 'home.dart';
import 'login.dart';
import 'register.dart';
import 'mongodb.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var db = await MongoDatabase.connect();

  runApp(MyApp(db: db));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.db});

  final dynamic db;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      routes: {
        '/home': (context) => HomePage(db: db, title: 'UwU', ),
        '/login': (context) => LoginPage(db: db, title: 'Se connecter'),
        '/register': (context) => RegisterPage(db: db, title: 'S\'inscrire'),
      },
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.orange,
      ),
      home: LoginPage(db: db, title: 'Salut'),
    );
  }
}

