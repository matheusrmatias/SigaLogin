import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sigalogin/src/models/update.dart';
import 'dart:io' show Platform;

class UpdateService {
  Future<Update> verifyAvailableUpdate({int timeoutInSecondValue = 3}) async {
    //Verify Current Platform, OTA Update Working Only Android
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    if (!Platform.isAndroid) return Update.empty();

    Uri url = Uri.parse('https://sigalogin.web.app/version.json');

    var client = http.Client();
    Duration timeout = Duration(seconds: timeoutInSecondValue);

    var request = client.get(url);

    var response =
        await Future.any([request, Future.delayed(timeout)]).then((result) {
      if (result is http.Response) {
        return result;
      } else {
        client.close();
        return http.Response('No Body', 408);
      }
    });

    if (response.statusCode != 200) return Update.empty(available: false);

    Map<String, dynamic> update = jsonDecode(utf8.decode(response.bodyBytes));

    bool available = false;
    final currentVersion =
        packageInfo.version.split('.').map((e) => int.parse(e)).toList();
    final updateVersion = update['version']
        .toString()
        .split('.')
        .map((e) => int.parse(e))
        .toList();

    for (int i = 0; i < currentVersion.length; i++) {
      if (currentVersion[i] < updateVersion[i]) {
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

    client.close();

    return Update(
        available: available,
        version: update['version'],
        sha256: update['sha256'],
        link: update['link'],
        changelog: changelog);
  }
}
