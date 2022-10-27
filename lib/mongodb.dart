import 'dart:developer';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mongo_dart/mongo_dart.dart';

class MongoDatabase {
  /// It connects to the database.
  static connect() async {
    /// Loading the .env file.
    await dotenv.load(fileName: ".env");

    /// Creating a connection to the database.
    var db = await Db.create("mongodb://${dotenv.env['MONGO_USER']}:${dotenv.env['MONGO_PASSWORD']}@${dotenv.env['MONGO_URL']}/${dotenv.env['MONGO_DB']}");
    await db.open();
    inspect(db);

    var status = db.serverStatus();
    print(status);

    return db;
  }

  static searchWhere(column, value) {
    return where.eq(column, value);
  }
}
