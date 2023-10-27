import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sigalogin/src/themes/main_theme.dart';
import 'package:sigalogin/src/widgets/container_text_info.dart';
import 'package:sigalogin/src/widgets/link_button.dart';
import 'package:sigalogin/src/widgets/navigation_button.dart';
import 'package:unicons/unicons.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sobre', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 32),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: 8),
              Container(
                width: double.maxFinite,
                decoration: BoxDecoration(
                  color: MainTheme.orange,
                  borderRadius: const BorderRadius.all(Radius.circular(16))
                ),
                child: Image.asset('assets/images/icon.png', width: 100, height: 100,),
              ),
              const SizedBox(height: 8),
              LinkButton(func: ()async{
                try{
                  await launchUrlString("https://github.com/matheusrmatias/SigaLogin", mode: LaunchMode.externalApplication);
                }catch (e){
                  Fluttertoast.showToast(msg: 'Não é possível abrir o link');
                }
              }, text: 'Projeto no GitHub'),
              LinkButton(func: ()async{
                try{
                  await launchUrlString("mailto:contato@matheusrmatias.dev.br", mode: LaunchMode.externalApplication);
                }catch (e){
                  Fluttertoast.showToast(msg: 'Não é possível abrir o link');
                }
              }, text: 'Enviar E-mail'),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: TextInfo(title: 'Desenvolvido por:', text: 'matheusrmatias.dev.br', titleColor: MainTheme.orange,onTap: ()async=>await launchUrlString('https://matheusrmatias.dev.br', mode: LaunchMode.externalApplication)))
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(onPressed: ()async=>await launchUrlString('https://github.com/matheusrmatias/', mode: LaunchMode.externalApplication), icon: const Icon(UniconsLine.github)),
                  IconButton(onPressed: ()async=>await launchUrlString('https://www.instagram.com/matheusrmatias/', mode: LaunchMode.externalApplication), icon: const Icon(UniconsLine.instagram)),
                  IconButton(onPressed: ()async=>await launchUrlString('https://www.linkedin.com/in/matheusrmatias/', mode: LaunchMode.externalApplication), icon: const Icon(UniconsLine.linkedin))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
