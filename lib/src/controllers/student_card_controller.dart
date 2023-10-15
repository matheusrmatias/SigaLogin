import 'dart:typed_data';

import 'package:sigalogin/src/controllers/sqlite_controller.dart';
import 'package:sigalogin/src/models/student_card.dart';
import 'package:sqflite/sqflite.dart';

class StudentCardController extends SqliteController{
  StudentCardController();

  Future<void> insertDatabase(StudentCard card)async{
    Database db = await startDatabase();
    String sql = '''INSERT INTO card (name, ra, cpf, course, period, fatec, image, validatorUrl, shipmentDate)VALUES(
      '${card.name}','${card.ra}','${card.cpf}','${card.course}','${card.period}','${card.fatec}','${card.image}','${card.validatorUrl}','${card.shipmentDate}'
    )''';
    await db.execute(sql);
  }

  Future<void> updateDatabase(StudentCard card)async{
    Database db = await startDatabase();
    await db.execute('DELETE FROM card');
    await insertDatabase(card);
  }

  Future<StudentCard> queryDatabase()async{
    Database db = await startDatabase();

    List<Map<String, Object?>> results = await db.rawQuery('SELECT * FROM card');

    if(results.isEmpty)return StudentCard.empty();

    return StudentCard(
        name: results[0]['name'].toString(),
        ra:  results[0]['ra'].toString(),
        cpf: results[0]['cpf'].toString(),
        course: results[0]['course'].toString(),
        period: results[0]['period'].toString(),
        fatec: results[0]['fatec'].toString(),
        shipmentDate: results[0]['shipmentDate'].toString(),
        image: results[0]['image'] as Uint8List,
        validatorUrl: results[0]['validatorUrl'].toString()
    );
  }
  Future<void> deleteCard()async{
    Database db = await startDatabase();
    await db.execute('DELETE FROM card');
  }

}