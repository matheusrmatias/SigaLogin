import 'package:flutter/cupertino.dart';
import 'package:sigalogin/src/models/assessment.dart';

import 'package:sigalogin/src/models/student.dart';

class StudentRepository extends ChangeNotifier{
  Student _student;
  late List<DisciplineAssessment> _assessment;
  late List<Map<String, String>> _historic;

  StudentRepository(this._student){
   _assessment = student. assessment;
   _historic = student.historic;
  }

  Student get student => _student;

  set student(Student value) {
    _student = value;
    notifyListeners();
  }

  List<Map<String, String>> get historic => _historic;

  set historic(List<Map<String, String>> value) {
    _historic = value;
    notifyListeners();
  }

  List<DisciplineAssessment> get assessment => _assessment;

  set assessment(List<DisciplineAssessment> value) {
    _assessment = value;
    notifyListeners();
  }

  void cleanSearch({bool listen = true}){
    _assessment = student.assessment;
    _historic = student.historic;
    if(listen)notifyListeners();
  }
}