import 'dart:convert';

import 'package:sigalogin/src/controllers/sqlite_controller.dart';
import 'package:sigalogin/src/models/assessment.dart';
import 'package:sqflite/sqflite.dart';

mixin AssessmentController on SqliteController{
  Future<void> insertAssessment(List<DisciplineAssessment> assessment)async{
    Database db = await startDatabase();

    String sqlAssessment = 'INSERT INTO assessment (acronym, teacher,name, average, frequency, absence, assessment, max_absences,total_classes, syllabus, objective) VALUES ';
    for (var element in assessment) {
      sqlAssessment = "$sqlAssessment('${element.acronym}','${element.teacher}','${element.name}','${element.average}','${element.frequency}','${element.absence}','${jsonEncode(element.assessment)}', '${element.maxAbsences}','${element.totalClasses}', '${element.syllabus}', '${element.objective}'),";
    }
    sqlAssessment = '${sqlAssessment.substring(0,sqlAssessment.length-1)};';

    await db.execute(sqlAssessment);
  }

  Future<List<DisciplineAssessment>> queryAssessment()async{
    Database db = await startDatabase();
    List<DisciplineAssessment> assessmentList = [];
    await db.rawQuery('SELECT * FROM assessment').then((value){
      value.forEach((element) {
        DisciplineAssessment disciplineAssessment = DisciplineAssessment();
        Map<String,String> assessment = {};
        disciplineAssessment.acronym = element['acronym'].toString();
        disciplineAssessment.teacher = element['teacher'].toString();
        disciplineAssessment.name = element['name'].toString();
        disciplineAssessment.average = element['average'].toString();
        disciplineAssessment.frequency = element['frequency'].toString();
        disciplineAssessment.absence = element['absence'].toString();
        disciplineAssessment.syllabus = element['syllabus'].toString();
        disciplineAssessment.objective = element['objective'].toString();
        disciplineAssessment.maxAbsences = element['max_absences'].toString();
        disciplineAssessment.totalClasses = element['total_classes'].toString();
        Map<String, dynamic> dynamicMap = jsonDecode(element['assessment'].toString());
        dynamicMap.forEach((key, value) {
          assessment[key] = value.toString();
        });
        disciplineAssessment.assessment = assessment;
        assessmentList.add(disciplineAssessment);
      });
    });

    assessmentList.sort((a, b){
      if(a.name.contains('Estágio') || a.name.contains('Trabalho de Graduação')){
        return 1;
      }else if(b.name.contains('Estágio') || b.name.contains('Trabalho de Graduação')){
        return -1;
      }else{
        return a.name.compareTo(b.name);
      }
    });

    return assessmentList;
  }

  Future<void> updateAssessment(List<DisciplineAssessment> assessment)async{
    Database db = await startDatabase();
    await db.execute('DELETE FROM assessment');
    await insertAssessment(assessment);
  }

}