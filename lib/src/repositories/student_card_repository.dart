import 'package:flutter/cupertino.dart';
import 'package:sigalogin/src/models/student_card.dart';

class StudentCardRepository extends ChangeNotifier{
  StudentCard _studentCard;

  StudentCardRepository(this._studentCard);

  StudentCard get studentCard => _studentCard;

  set studentCard(StudentCard value) {
    _studentCard = value;
    notifyListeners();
  }
}