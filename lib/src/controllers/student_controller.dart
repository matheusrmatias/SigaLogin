import 'dart:convert';
import 'dart:typed_data';
import 'package:sigalogin/src/controllers/assessment_controller.dart';
import 'package:sigalogin/src/controllers/historic_controller.dart';
import 'package:sigalogin/src/controllers/sqlite_controller.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sigalogin/src/models/student.dart';
import 'schedule_controller.dart';

class StudentController extends SqliteController with ScheduleController, HistoricController, AssessmentController{
  StudentController();

  Future<void> insertStudent(Student student)async{
    Database db = await startDatabase();
    String sqlStudent = '''
       INSERT INTO student (cpf, password, name, email, ra, pp, pr, cycle, image, fatec, progress, period, graduation) VALUES (
       '${student.cpf}','${student.password}','${student.name}','${student.email}','${student.ra}','${student.pp}','${student.pr}','${student.cycle}','${student.image}',
       '${student.fatec}','${student.progress}', '${student.period}', '${student.graduation}'
       )
    ''';
    await db.execute(sqlStudent);
  }

  Future updateStudent(Student student) async{
    Database db = await startDatabase();
    try{
      await db.execute('DELETE FROM student');
      await insertStudent(student);
    }finally{

    }
  }

  Future<Student> queryStudent() async{
    Database db = await startDatabase();
    Student student = Student(cpf: '', password: '');
    await db.rawQuery('SELECT * FROM student').then((value){
      if(value.isEmpty){

      }else{
        student.cpf  = value[0]['cpf'].toString();
        student.password  = value[0]['password'].toString();
        student.name  = value[0]['name'].toString();
        student.email  = value[0]['email'].toString();
        student.ra  = value[0]['ra'].toString();
        student.pp  = value[0]['pp'].toString();
        student.pr  = value[0]['pr'].toString();
        student.cycle  = value[0]['cycle'].toString();
        student.image  = Uint8List.fromList(value[0]['image'].toString().replaceAll('[', '').replaceAll(']', '').split(',').map<int>((e) => int.parse(e)).toList());
        student.fatec  = value[0]['fatec'].toString();
        student.progress  = value[0]['progress'].toString();
        student.graduation  = value[0]['graduation'].toString();
        student.period  = value[0]['period'].toString();
      }
    });
    return student;
  }
}