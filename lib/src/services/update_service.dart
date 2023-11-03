import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sigalogin/src/models/update.dart';
import 'dart:io' show Platform;

class UpdateService{

  Future<Update> verifyAvailableUpdate()async{
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    if(!Platform.isAndroid)return Update.empty();
    try{
      http.Response response = await http.get(Uri.parse('https://sigalogin.web.app/version.json'));
      if(response.statusCode != 200)return Update.empty(available: false);

      Map<String,dynamic> update = jsonDecode(utf8.decode(response.bodyBytes));

      bool available = false;
      final currentVersion = packageInfo.version.split('.').map((e) => int.parse(e)).toList();
      final updateVersion = update['version'].toString().split('.').map((e) => int.parse(e)).toList();

      debugPrint('Current: $currentVersion\nUpdate: $updateVersion');

      for(int i=0; i<currentVersion.length; i++){
        if(currentVersion[i]<updateVersion[i]){
          available = true;
          i = currentVersion.length;
        }
      }

      Map<String, List<String>> changelog = {};

      update['changelog'].forEach((chave, valor) {
        if (valor is List<dynamic>) {
          List<String> novaLista = valor.cast<String>();
          changelog[chave] = novaLista;
        }
      });

      return Update(
          available: available,
          version: update['version'],
          sha256: update['sha256'],
          link: update['link'],
          changelog: changelog
      );

    }catch(e){
      debugPrint('Error $e');
      return Update.empty();
    }
  }
}