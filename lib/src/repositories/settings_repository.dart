import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingRepository extends ChangeNotifier{
  SharedPreferences prefs;
  late bool? _imageDisplay;
  late String? _theme;

  SettingRepository({required this.prefs}){
    _imageDisplay = getBool('imageDisplay');
    _theme = getString('theme');
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