import 'package:sigalogin/src/controllers/sqlite_controller.dart';
import 'package:sigalogin/src/models/schedule.dart';
import 'package:sqflite/sqflite.dart';

mixin ScheduleController on SqliteController{
  Future<void> insertSchedule(List<Schedule> schedule)async{
    Database db = await startDatabase();
    if(schedule.isEmpty)return;

    String sqlSchedule = 'INSERT INTO schedule (weekDay, schedule) VALUES';
    for (var element in schedule) {
      sqlSchedule = "$sqlSchedule('${element.weekDay}', '${element.schedule.toString()}'),";
    }
    sqlSchedule = '${sqlSchedule.substring(0,sqlSchedule.length-1)};';

    db.execute(sqlSchedule);
  }

  Future<void> updateSchedule(List<Schedule> schedule)async{
    Database db = await startDatabase();
    await db.execute('DELETE FROM schedule');
    await insertSchedule(schedule);
  }

  Future<List<Schedule>> querySchedule()async{
    Database db = await startDatabase();
    List<Schedule> scheduleList = [];
    await db.rawQuery('SELECT * FROM schedule').then((value){
      for (var element in value) {
        Schedule schedule = Schedule();
        schedule.weekDay = element['weekDay'].toString();
        schedule.schedule = element['schedule'].toString().substring(1,element['schedule'].toString().length-1).split('], ').map((element) {
          element = element.replaceAll('[', '').replaceAll(']', '');
          return element.split(', ');
        }).toList();
        scheduleList.add(schedule);
      }
    });
    return scheduleList;
  }

}