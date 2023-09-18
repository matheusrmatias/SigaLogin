import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:sigalogin/src/models/student.dart';
import 'package:sigalogin/src/pages/home_page.dart';
import 'package:sigalogin/src/pages/login_page.dart';
import 'package:sigalogin/src/pages/settings/view_settings.dart';
import 'package:sigalogin/src/pages/siga_page.dart';
import 'package:sigalogin/src/repositories/student_repository.dart';
import 'package:sigalogin/src/themes/main_theme.dart';
import 'package:sigalogin/src/widgets/copy_text.dart';
import 'package:sigalogin/src/widgets/navigation_button.dart';
import 'package:sigalogin/src/widgets/settings_switch.dart';
import 'package:unicons/unicons.dart';
import 'package:sigalogin/src/widgets/container_text_info.dart';

import '../../../main.dart';
import '../../controllers/student_controller.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  late Student student;
  StudentController control = StudentController();
  bool inExit = false;
  
  @override
  Widget build(BuildContext context) {
    student = Provider.of<StudentRepository>(context).student;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 32),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    TextInfo(text: 'PP\n${student.pp}'),
                    const SizedBox(width: 8),
                    TextInfo(text: 'PR\n${student.pr}')
                  ],
                ),
              ),
              CopyCard(text: student.ra, ico: Icon(UniconsLine.graduation_cap,color: MainTheme.black,)),
              CopyCard(text: student.email, ico: Icon(Icons.email_outlined, color: MainTheme.black)),
              NavigationButton(text: 'Configuração de Exibição', child: ViewSettings()),
              NavigationButton(text: 'Acessar o SIGA', child: SigaPage()),

            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 70,
        child: ElevatedButton(
          onPressed: ()async{
            setState(()=>inExit=true);
            try{
              await control.deleteDatabase();
              if(mounted){
                Navigator.pop(context);
                Navigator.pushReplacement(context, PageTransition(child: const LoginPage(), type: PageTransitionType.fade));
              }
            }catch (e){
              debugPrint('Error: $e');
            }finally{
              setState(()=>inExit=false);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: MainTheme.orange,
            minimumSize: const Size(double.maxFinite, double.maxFinite),
          ),
          child: inExit?const CircularProgressIndicator(color: Colors.white):const Text('Sair',style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
        ),
      ),
    );
  }

}
