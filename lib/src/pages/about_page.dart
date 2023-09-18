import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sigalogin/src/pages/libs_page.dart';
import 'package:sigalogin/src/widgets/link_button.dart';
import 'package:sigalogin/src/widgets/navigation_button.dart';
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
              LinkButton(func: ()async{
                try{
                  await launchUrlString("https://github.com/matheusrmatias/SigaLogin", mode: LaunchMode.externalApplication);
                }catch (e){
                  Fluttertoast.showToast(msg: 'Não é possível abrir o link');
                }
              }, text: 'Projeto no GitHub'),
              NavigationButton(text: 'Libs Utilizadas', child: const LibsPage())
            ],
          ),
        ),
      ),
    );
  }
}
