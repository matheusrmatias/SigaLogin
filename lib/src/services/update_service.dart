import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sigalogin/src/models/update.dart';

class UpdateService{

  Future<Update> verifyAvailableUpdate()async{
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try{
      http.Response response = await http.get(Uri.parse('https://sigalogin.web.app/version.json'));
      if(response.statusCode != 200)return Update.empty(available: false);

      Map<String,dynamic> update = jsonDecode(response.body);
      if(packageInfo.version==update['version'])return Update.empty(available: false);

      return Update(
          available: true,
          version: update['version'],
          sha256: update['sha256'],
          link: update['link'],
          changelog: update['changelog']
      );

    }catch(e){
      return Update.empty();
    }
  }
}