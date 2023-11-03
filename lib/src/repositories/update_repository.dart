import 'package:flutter/cupertino.dart';
import 'package:sigalogin/src/models/update.dart';

class UpdateRepository extends ChangeNotifier{
  Update? _update;

  UpdateRepository({Update? update}):_update=update;

  Update get update => _update??Update.empty();

  set update(Update value) {
    _update = value;
    notifyListeners();
  }
}