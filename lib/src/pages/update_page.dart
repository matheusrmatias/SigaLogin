import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ota_update/ota_update.dart';
import 'package:provider/provider.dart';
import 'package:sigalogin/src/models/update.dart';
import 'package:sigalogin/src/repositories/settings_repository.dart';
import 'package:sigalogin/src/repositories/update_repository.dart';
import 'package:sigalogin/src/themes/main_theme.dart';

class UpdatePage extends StatefulWidget {
  const UpdatePage({super.key});

  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  late Update update;
  OtaEvent? currentEvent;
  
  @override
  Widget build(BuildContext context) {
    update = Provider.of<UpdateRepository>(context).update!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Atualização', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 32),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: MainTheme.lightGrey,
                  borderRadius: const BorderRadius.all(Radius.circular(16))
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(child: Text('Versâo: ${update.version}', style: TextStyle(fontSize: 16, color: MainTheme.black,fontWeight: FontWeight.bold)))
                      ],
                    ),
                    const SizedBox(height: 8),
                    currentEvent?.value==null||currentEvent!.value!.isEmpty?ElevatedButton(
                      onPressed: _updateApp,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: MainTheme.orange,
                          minimumSize: const Size(double.maxFinite, 0),
                          padding: const EdgeInsets.all(16),
                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16)))
                      ),
                      child: Text('Atualizar',style: TextStyle(color: MainTheme.white,fontSize: 24)),
                    ):Stack(
                      alignment: Alignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.all(Radius.circular(16)),
                          child: LinearProgressIndicator(value: (double.tryParse(currentEvent!.value??'0')??0)/100,color: MainTheme.orange,backgroundColor: MainTheme.black,minHeight: MediaQuery.of(context).textScaleFactor*30),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(child: Text('Baixando ${currentEvent!.value} %', style: TextStyle(fontSize: 16, color: MainTheme.white),textAlign: TextAlign.center,))
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  _updateApp()async{
    Iterable<OtaStatus> errorStatus = OtaStatus.values.where((e) => e.toString().contains('ERROR'));

    Map<OtaStatus,String> errorMsg = {
      OtaStatus.DOWNLOAD_ERROR : ' ao fazer o download!',
      OtaStatus.INTERNAL_ERROR : ' interno!',
      OtaStatus.ALREADY_RUNNING_ERROR : ', download já em execução!',
      OtaStatus.CHECKSUM_ERROR : ' ao verificar a integridade do arquivo baixado!',
      OtaStatus.PERMISSION_NOT_GRANTED_ERROR : ', sem permissões necessárias'
    };
    try {
      OtaUpdate()
          .execute(
        update.link,
        destinationFilename: 'last_version.apk',
        sha256checksum: update.sha256
      ).listen(
            (OtaEvent event) {
          setState(() => currentEvent = event);
          if(errorStatus.contains(currentEvent!.status)){
            setState(() => currentEvent = OtaEvent(currentEvent!.status, ''));
            Fluttertoast.showToast(msg: 'Ocorreu um erro${errorMsg[currentEvent!.status]}');
          }
        },
      );
    } catch (e) {
      print('Failed to make OTA update. Details: $e');
    }
  }
}