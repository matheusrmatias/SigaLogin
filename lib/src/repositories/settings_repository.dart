import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingRepository extends ChangeNotifier{
  SharedPreferences prefs;
  late bool? _imageDisplay;
  late String? _theme;
  late String? _lastInfoUpdate;
  late bool? _appLock;
  late bool? _updateOnOpen;
  late bool? _updateSchedule;

  SettingRepository({required this.prefs}){
    _imageDisplay = prefs.getBool('imageDisplay');
    _theme = prefs.getString('theme');
    _lastInfoUpdate = prefs.getString('lastInfoUpdate');
    _appLock = prefs.getBool('appLock');
    _updateOnOpen = prefs.getBool('updateOnOpen');
    _updateSchedule = prefs.getBool('updateSchedule');
  }


  bool get updateSchedule => _updateSchedule??true;

  set updateSchedule(bool value) {
    _updateSchedule = value;
    setBool('updateSchedule', value);
    notifyListeners();
  }

  bool get updateOnOpen => _updateOnOpen??true;

  set updateOnOpen(bool value) {
    _updateOnOpen = value;
    setBool('updateOnOpen', value);
    notifyListeners();
  }

  bool get appLock => _appLock??false;

  set appLock(bool value) {
    _appLock = value;
    setBool('appLock', value);
    notifyListeners();
  }

  String get lastInfoUpdate => _lastInfoUpdate??'n/a';

  set lastInfoUpdate(String value) {
    _lastInfoUpdate = value;
    setString('lastInfoUpdate', value);
    notifyListeners();
  }

  bool get imageDisplay => _imageDisplay??true;

  set imageDisplay(bool value){
    _imageDisplay = value;
    setBool('imageDisplay', value);
    notifyListeners();
  }

  String get theme => _theme??'Padrão do Sistema';

  set theme(String value) {
    _theme = value;
    notifyListeners();
  }

  setBool(String key, bool value)async{
    await prefs.setBool(key, value);
  }

  setString(String key, String value)async{
    await prefs.setString(key, value);
  }

  clear()async{
    await prefs.clear();
    imageDisplay = true;
    appLock = false;
    lastInfoUpdate = '';
    theme = 'Padrão do Sistema';
  }
}