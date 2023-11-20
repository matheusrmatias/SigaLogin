import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ota_update/ota_update.dart';
import 'package:provider/provider.dart';
import 'package:sigalogin/src/repositories/update_repository.dart';
import 'package:sigalogin/src/services/update_service.dart';
import 'package:sigalogin/src/themes/main_theme.dart';
import 'package:sigalogin/src/widgets/show_modal_bootm_sheet_default.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdatePage extends StatefulWidget {
  const UpdatePage({super.key});

  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  late UpdateRepository update;
  OtaEvent? currentEvent;
  bool inUpdate = false;
  
  @override
  Widget build(BuildContext context) {
    update = Provider.of<UpdateRepository>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Atualização', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 32),
        child: RefreshIndicator(
          color: MainTheme.orange,
          backgroundColor: MainTheme.white,
          onRefresh: ()async{
            UpdateService service = UpdateService();
            update.update = await service.verifyAvailableUpdate();
            if(update.update.available)Fluttertoast.showToast(msg: 'Nova Atualização Disponível!');
          },
          child: ListView(           
            children: [
              const SizedBox(height: 8),
              update.update.available?Stack(
                alignment: Alignment.topRight,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: Theme.of(context).brightness==Brightness.dark?MainTheme.black:MainTheme.lightGrey,
                        borderRadius: const BorderRadius.all(Radius.circular(16))
                    ),
                    child: Column(
                      children: _generateChildren(),
                    ),
                  ),
                  IconButton(onPressed: (){
                    showModalBottomSheetConfirmAction(
                        context,
                        'Caso não esteja sendo possível atualizar por aqui é só clicar em baixar para ser redirecionado para a página de download manual.',
                        ()async=>await launchUrl(Uri.parse(update.update.link)),
                      afirmativeText: 'Baixar',
                      negativeText: 'Cancelar'
                    );
                  }, icon: Icon(Icons.info_outline,color: MainTheme.red))
                ],
              ):const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(child: Text('O aplicativo está atualizado',style: TextStyle(fontSize: 16)))
                ],
              ),
            ],
          ),
        )
      ),
    );
  }
  _updateApp()async{
    setState(()=>inUpdate=true);
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
        update.update.link,
        destinationFilename: 'last_version.apk',
        sha256checksum: update.update.sha256
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
      debugPrint('Failed to make OTA update. Details: $e');
    }finally{
      setState(()=>inUpdate=false);
    }
  }

  List<Widget> _generateChildren(){
    List<Widget> children = [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(child: Text('Já tá no Siga? v${update.update.version}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)))
        ],
      ),
      const SizedBox(height: 8),
      Divider(color: Theme.of(context).brightness==Brightness.dark?MainTheme.white:MainTheme.black)
    ];

    update.update.changelog.forEach((key, value) {
      children.add(
        Column(
          children: [
            Row(
              children: [Flexible(child: Text(key,style: TextStyle(fontSize: 16, color: MainTheme.orange,fontWeight: FontWeight.bold)))],
            ),
            Column(
              children: value.map((e) => Row(children: [Flexible(child: Text('- $e',style: const TextStyle(fontSize: 14),textAlign: TextAlign.justify,))])).toList(),
            )
          ],
        )
      );
    });

    children.add(Divider(color: MainTheme.black));

    children.add(
      currentEvent?.value==null||currentEvent!.value!.isEmpty?ElevatedButton(
        onPressed: inUpdate? null:_updateApp,
        style: ElevatedButton.styleFrom(
            backgroundColor: MainTheme.lightBlue,
            minimumSize: const Size(double.maxFinite, 0),
            padding: const EdgeInsets.all(16),
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16)))
        ),
        child: Text('Atualizar',style: TextStyle(color: MainTheme.white,fontSize: 24,fontWeight: FontWeight.bold)),
      ):Stack(
        alignment: Alignment.center,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(16)),
            child: LinearProgressIndicator(value: (double.tryParse(currentEvent!.value??'0')??0)/100,color: MainTheme.lightBlue,backgroundColor: MainTheme.black,minHeight: MediaQuery.of(context).textScaleFactor*30),
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
    );
    return children;
  }
}