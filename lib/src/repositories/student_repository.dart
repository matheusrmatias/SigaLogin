import 'package:flutter/cupertino.dart';
import 'package:sigalogin/src/models/assessment.dart';
import 'package:sigalogin/src/models/historic.dart';
import 'package:sigalogin/src/models/schedule.dart';

import 'package:sigalogin/src/models/student.dart';

class StudentRepository extends ChangeNotifier{
  Student _student;
  late List<DisciplineAssessment> _allAssessment;
  late List<Historic> _allHistoric;
  late List<DisciplineAssessment> _assessment;
  late List<Historic> _historic;
  late List<Schedule> _schedule;

  StudentRepository(this._student,this._allHistoric,this._allAssessment, this._schedule){
    _assessment = _allAssessment;
    _historic = _allHistoric;
  }


  List<DisciplineAssessment> get allAssessment => _allAssessment;

  set allAssessment(List<DisciplineAssessment> value) {
    _allAssessment = value;
  }

  Student get student => _student;

  set student(Student value) {
    _student = value;
    notifyListeners();
  }

  List<Historic> get historic => _historic;

  set historic(List<Historic> value) {
    _historic = value;
    notifyListeners();
  }

  List<DisciplineAssessment> get assessment => _assessment;

  set assessment(List<DisciplineAssessment> value) {
    _assessment = value;
    notifyListeners();
  }

  void cleanSearch({bool listen = true}){
    _assessment = _allAssessment;
    _historic = _allHistoric;
    if(listen)notifyListeners();
  }

  List<Historic> get allHistoric => _allHistoric;

  set allHistoric(List<Historic> value) {
    _allHistoric = value;
  }

  List<Schedule> get schedule => _schedule;

  set schedule(List<Schedule> value) {
    _schedule = value;
  }

  void clearRepository(){
    student = Student(cpf: '', password: '');

    allAssessment = [];
    assessment = [];

    allHistoric = [];
    historic = [];

    schedule = [];
  }
}