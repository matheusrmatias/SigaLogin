import 'package:flutter/cupertino.dart';
import 'package:sigalogin/src/models/update.dart';

class UpdateRepository extends ChangeNotifier{
  Update? update;

  UpdateRepository({this.update}){
    update = update??Update.empty();
  }
}