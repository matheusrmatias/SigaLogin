import 'dart:ffi';
import 'dart:typed_data';

import 'assessment.dart';
import 'schedule.dart';

class Student{
  String cpf;
  String password;
  Student({required this.cpf,required this.password});

  String _name = '';
  String _email = '';
  String _ra = '';
  String _pp = '';
  String _pr = '';
  String _cycle = '';
  Uint8List _image = Uint8List(0);
  String _fatec = '';
  String _progress = '';
  String _graduation = '';
  String _period = '';

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  String get email => _email;

  Uint8List get image => _image;

  set image(Uint8List value) {
    _image = value;
  }

  String get cycle => _cycle;

  set cycle(String value) {
    _cycle = value;
  }

  String get pr => _pr;

  set pr(String value) {
    _pr = value;
  }

  String get pp => _pp;

  set pp(String value) {
    _pp = value;
  }

  String get ra => _ra;

  set ra(String value) {
    _ra = value;
  }

  set email(String value) {
    _email = value;
  }

  String get period => _period;

  set period(String value) {
    _period = value;
  }

  String get graduation => _graduation;

  set graduation(String value) {
    _graduation = value;
  }

  String get progress => _progress;

  set progress(String value) {
    _progress = value;
  }

  String get fatec => _fatec;

  set fatec(String value) {
    _fatec = value;
  }
}