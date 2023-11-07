import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:sigalogin/src/controllers/sqlite_controller.dart';
import 'package:sigalogin/src/models/schedule.dart';
import 'package:sqflite/sqflite.dart';

mixin ScheduleController on SqliteController{
  Future<void> insertSchedule(List<Schedule> schedule)async{
    Database db = await startDatabase();
    if(schedule.isEmpty)return;

    String sqlSchedule = 'INSERT INTO schedule (weekDay, schedule) VALUES';
    for (var element in schedule) {
      sqlSchedule = "$sqlSchedule('${element.weekDay}', '${json.encode(element.schedule)}'),";
    }
    sqlSchedule = '${sqlSchedule.substring(0,sqlSchedule.length-1)};';

    db.execute(sqlSchedule);
  }

  Future<void> updateSchedule(List<Schedule> schedule)async{
    Database db = await startDatabase();
    await db.execute('DELETE FROM schedule');
    await insertSchedule(schedule);
  }
  
  Future<void> updateOnlySchedule(Schedule schedule)async{
    Database db = await startDatabase();
    await db.execute("UPDATE schedule SET weekDay='${schedule.weekDay}', schedule='${json.encode(schedule.schedule)}' WHERE weekDay='${schedule.weekDay}'");
  }

  Future<List<Schedule>> querySchedule()async{
    Database db = await startDatabase();
    List<Schedule> scheduleList = [];
    try{
      await db.rawQuery('SELECT * FROM schedule').then((value){
        for (var element in value) {
          Schedule schedule = Schedule();
          schedule.weekDay = element['weekDay'].toString();
          schedule.schedule = Map<String,String>.from(json.decode(element['schedule'].toString()));
          scheduleList.add(schedule);
        }
      });
    }catch (e){
      debugPrint('Error: $e');
    }finally{

    }
    return scheduleList;
  }

}