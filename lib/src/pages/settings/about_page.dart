import 'package:animated_emoji/animated_emoji.dart';
import 'package:animated_emoji/emojis.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sigalogin/src/themes/main_theme.dart';
import 'package:sigalogin/src/widgets/container_text_info.dart';
import 'package:sigalogin/src/widgets/link_button.dart';
import 'package:sigalogin/src/widgets/navigation_button.dart';
import 'package:unicons/unicons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  int _counter = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sobre', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(        
          child: Column(
            children: [
              const SizedBox(height: 8),
              Container(
                alignment: Alignment.center,
                width: double.maxFinite,
                decoration: BoxDecoration(
                  color: MainTheme.orange,
                  borderRadius: const BorderRadius.all(Radius.circular(16))
                ),
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [ClipRRect(borderRadius: const BorderRadius.all(Radius.circular(16)), child: Image.asset('assets/images/icon.png', width: 100, height: 100)),const AnimatedEmoji(AnimatedEmojis.graduationCap, size: 36,repeat: false,errorWidget: SizedBox())],
                ),
              ),
              const SizedBox(height: 8),
              LinkButton(func: ()async{
                try{
                  await launchUrlString("https://github.com/matheusrmatias/SigaLogin", mode: LaunchMode.externalApplication);
                }catch (e){
                  Fluttertoast.showToast(msg: 'Não é possível abrir o link');
                }
              }, text: 'Projeto no GitHub',icon: EvaIcons.github,),
              LinkButton(func: ()async{
                try{
                  await launchUrlString("mailto:contato@matheusrmatias.dev.br", mode: LaunchMode.externalApplication);
                }catch (e){
                  Fluttertoast.showToast(msg: 'Não é possível abrir o link');
                }
              }, text: 'Enviar E-mail', icon: Icons.email),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: TextInfo(title: 'Desenvolvido por:', text: 'Matheus 🐀 Matias', titleColor: MainTheme.orange,onTap: ()async=>await launchUrl(Uri.parse('https://matheusrmatias.dev.br'),mode: LaunchMode.externalNonBrowserApplication)))
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
