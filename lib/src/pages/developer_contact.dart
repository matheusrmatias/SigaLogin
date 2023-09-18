import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sigalogin/src/themes/main_theme.dart';
import 'package:sigalogin/src/widgets/container_text_info.dart';
import 'package:sigalogin/src/widgets/link_button.dart';
import 'package:url_launcher/url_launcher_string.dart';

class DeveloperContact extends StatefulWidget {
  const DeveloperContact({super.key});

  @override
  State<DeveloperContact> createState() => _DeveloperContactState();
}

class _DeveloperContactState extends State<DeveloperContact> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contato', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  LinkButton(func: ()async{
                    try{
                      await launchUrlString("mailto:contato@matheusrmatias.dev.br", mode: LaunchMode.externalApplication);
                    }catch (e){
                      Fluttertoast.showToast(msg: 'Não é possível abrir o link');
                    }
                  }, text: 'Enviar E-mail'),
                ],
              ),
            )
        ),
      ),
    );
  }
}
