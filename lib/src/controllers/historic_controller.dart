import 'package:sigalogin/src/controllers/sqlite_controller.dart';
import 'package:sigalogin/src/models/historic.dart';
import 'package:sqflite/sqflite.dart';

mixin HistoricController on SqliteController{

  Future<void> insertHistoric(List<Historic> historic)async{
    Database db = await startDatabase();
    if(historic.isEmpty)return;
    String sqlHistoric = 'INSERT INTO historic (acronym, name, period, average, frequency, absence, observation) VALUES ';
    historic.forEach((element) {
      sqlHistoric = "$sqlHistoric('${element.acronym}','${element.name}','${element.period}','${element.avarage}','${element.frequency}','${element.absence}', '${element.observation}'),";
    });
    sqlHistoric = '${sqlHistoric.substring(0,sqlHistoric.length-1)};';
    db.execute(sqlHistoric);
  }

  Future<List<Historic>> queryHistoric()async{
    Database db = await startDatabase();
    List<Historic> historic = [];
    await db.rawQuery('SELECT * FROM historic').then((value){
      for (var element in value) {
        historic.add(
            Historic(
                acronym: element['acronym'].toString(),
                name: element['name'].toString(),
                period: element['period'].toString(),
                avarage: double.parse(element['average'].toString()),
                frequency: double.parse(element['frequency'].toString()),
                absence: int.parse(element['absence'].toString()),
                observation: element['observation'].toString()
            )
        );
      }
    });

    historic.sort((a, b) {
      int periodComparison = a.period.compareTo(b.period);
      if (periodComparison != 0) {
        return periodComparison;
      } else {
        return a.name.compareTo(b.name);
      }
    });

    return historic;
  }
  
  Future<void> updateHistoric(List<Historic> historic)async{
    Database db = await startDatabase();
    await db.execute('DELETE FROM historic');
    await insertHistoric(historic);
  }

}