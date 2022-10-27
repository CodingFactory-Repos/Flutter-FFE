import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'home.dart';
import 'account/login.dart';
import 'account/mdtp_oublie.dart';
import 'account/register.dart';
import 'mongodb.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var db = await MongoDatabase.connect();
  await dotenv.load(fileName: ".env");

  runApp(MyApp(db: db));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.db, this.user});

  final dynamic db;
  final user;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Map? user = ModalRoute.of(context)?.settings.arguments as Map?;
    bool DEV_MODE = dotenv.env['DEV_MODE'] == 'true';

    return MaterialApp(
      title: 'Flutter Demo',
      routes: {
        '/main': (context) => MyApp(db: db),
        '/home': (context) => HomePage(db: db, user: user, title: 'UwU', ),
        '/login': (context) => LoginPage(db: db, title: 'Se connecter'),
        '/register': (context) => RegisterPage(db: db, title: 'S\'inscrire'),
        '/mdtp_oublie': (context) => mdtpPage(db: db, title: 'Mot de passe oublier'),
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
      home: user == null && !(DEV_MODE) ? LoginPage(db: db, title: 'Se connecter') : HomePage(db: db, user: DEV_MODE ? {
        "_id": "60f1b1f1b1f1b1f1b1f1b1f1",
        "username": "username",
        "email": "developer@email.com",
        "password": "password",
      } : user, title: 'UwU'),
      debugShowCheckedModeBanner: false,
    );
  }
}

