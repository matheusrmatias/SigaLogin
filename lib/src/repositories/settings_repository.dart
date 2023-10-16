import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingRepository extends ChangeNotifier{
  SharedPreferences prefs;
  late bool? _imageDisplay;
  late String? _theme;
  late String? _lastInfoUpdate;

  SettingRepository({required this.prefs}){
    _imageDisplay = getBool('imageDisplay');
    _theme = getString('theme');
    _lastInfoUpdate = getString('lastInfoUpdate');
  }


  String get lastInfoUpdate => _lastInfoUpdate??'n/a';

  set lastInfoUpdate(String value) {
    _lastInfoUpdate = value;
    setString('lastInfoUpdate', value);
    notifyListeners();
  }

  bool get imageDisplay => _imageDisplay==null?true:_imageDisplay!;

  set imageDisplay(bool value){
    _imageDisplay = value;
    setBool('imageDisplay', value);
    notifyListeners();
  }

  String get theme => _theme??'';

  set theme(String value) {
    _theme = value;
  }

  getBool(String key){
    if(prefs.getBool(key) == null){
      return true;
    }else{
      return prefs.getBool(key)!;
    }
  }

  setBool(String key, bool value)async{
    await prefs.setBool(key, value);
  }

  String? getString(String key){
    if(prefs.getString(key) == null){
      return null;
    }else{
      return prefs.getString(key)!;
    }
  }
  setString(String key, String value)async{
    await prefs.setString(key, value);
  }

}