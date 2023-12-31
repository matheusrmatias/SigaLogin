import 'package:sqflite/sqflite.dart';

abstract class SqliteController{
  static final _databaseName = "student.db";
  static Database? database;
  Future startDatabase() async{
    if(database !=null){
      return database;
    }
    database = await _openOrCreateDatabase();
    return database;
  }

  Future _openOrCreateDatabase() async{
    var databasePath = await getDatabasesPath();
    String path = databasePath + _databaseName;
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version)async{
    await db.execute(
        '''CREATE TABLE IF NOT EXISTS student (
        cpf TEXT, password TEXT, name TEXT, email TEXT, ra TEXT, pp TEXT, pr TEXT, cycle TEXT, image BLOB, fatec TEXT, progress TEXT, period TEXT, graduation TEXT
      )'''
    );
    await db.execute(
        '''CREATE TABLE IF NOT EXISTS historic (
        acronym TEXT, name TEXT, period TEXT, average TEXT, frequency TEXT, absence TEXT, observation TEXT
      )'''
    );
    await db.execute(
        '''CREATE TABLE IF NOT EXISTS assessment(
        acronym TEXT, teacher TEXT, name TEXT, average TEXT, frequency TEXT, absence TEXT, assessment TEXT, max_absences TEXT,total_classes TEXT, syllabus TEXT, objective TEXT
      )''');
    await db.execute(
        '''CREATE TABLE IF NOT EXISTS schedule(
        weekDay TEXT, schedule TEXT
      )''');
    await db.execute(
        '''CREATE TABLE IF NOT EXISTS card(
        name TEXT, ra TEXT, cpf TEXT, course TEXT, period TEXT, fatec TEXT, image BLOB, validatorUrl TEXT, shipmentDate TEXT
      )''');
  }

  Future deleteDatabase() async{
    Database db = await startDatabase();
    await db.delete('student');
    await db.delete('historic');
    await db.delete('assessment');
    await db.delete('schedule');
    await db.delete('card');
  }
}