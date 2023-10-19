import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sigalogin/src/models/student.dart';
import 'package:sigalogin/src/models/student_card.dart';
import 'package:sigalogin/src/pages/about_page.dart';
import 'package:sigalogin/src/pages/developer_contact.dart';
import 'package:sigalogin/src/pages/login_page.dart';
import 'package:sigalogin/src/pages/settings/security_settings_page.dart';
import 'package:sigalogin/src/pages/settings/student_card_page.dart';
import 'package:sigalogin/src/pages/settings/view_settings.dart';
import 'package:sigalogin/src/pages/siga_page.dart';
import 'package:sigalogin/src/repositories/settings_repository.dart';
import 'package:sigalogin/src/repositories/student_card_repository.dart';
import 'package:sigalogin/src/repositories/student_repository.dart';
import 'package:sigalogin/src/themes/main_theme.dart';
import 'package:sigalogin/src/widgets/copy_text.dart';
import 'package:sigalogin/src/widgets/navigation_button.dart';
import 'package:sigalogin/src/widgets/show_modal_bootm_sheet_default.dart';
import 'package:unicons/unicons.dart';
import 'package:sigalogin/src/widgets/container_text_info.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../controllers/student_controller.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  late Student student;
  late StudentRepository studentRep;
  late StudentCardRepository stundentCardRep;
  late SettingRepository settingRep;
  StudentController control = StudentController();
  bool inExit = false;
  
  @override
  Widget build(BuildContext context) {
    student = Provider.of<StudentRepository>(context).student;
    studentRep = Provider.of<StudentRepository>(context);
    stundentCardRep = Provider.of<StudentCardRepository>(context);
    settingRep = Provider.of<SettingRepository>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 32),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: 8),
              Ink(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: MainTheme.lightGrey,
                  borderRadius: const BorderRadius.all(Radius.circular(16))
                ),
                child: Column(
                  children: [
                    CircleAvatar(backgroundImage: MemoryImage(student.image),backgroundColor: MainTheme.orange,radius: 30),
                    Row(
                      children: [
                        Expanded(child: Text(student.name, maxLines: 3,style: TextStyle(color: MainTheme.black,fontSize: 14),textAlign: TextAlign.center)),
                      ],
                    ),
                    Divider(color: MainTheme.black,),
                    Row(
                      children: [
                        Expanded(child: Text(student.graduation, maxLines: 3,style: TextStyle(color: MainTheme.black,fontSize: 14),textAlign: TextAlign.center,)),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Expanded(child: TextInfo(text: '${student.pp} %', title: 'PP', titleColor: MainTheme.white, backgroundColor: MainTheme.orange,textColor: MainTheme.white,)),
                          const SizedBox(width: 8),
                          Expanded(child: TextInfo(text: student.pr, title: 'PR', titleColor: MainTheme.white,backgroundColor: MainTheme.orange,textColor: MainTheme.white,))
                        ],
                      ),
                    ),
                    CopyCard(text: student.ra, ico: Icon(UniconsLine.graduation_cap,color: MainTheme.white), color: MainTheme.white, backgroundColor: MainTheme.lightBlue,animationColor: MainTheme.white,),
                    NavigationButton(text: 'Carteirinha de Estudante',color: MainTheme.white,backgroundColor: MainTheme.lightBlue, child: const StudentCardPage()),
                  ],
                ),
              ),
              Divider(color: Theme.of(context).colorScheme.onPrimary),
              NavigationButton(text: 'Configuração de Exibição', child: const ViewSettings()),
              NavigationButton(text: 'Configuração de Segurança', child: const SecuritySettingPage()),
              Divider(color: Theme.of(context).colorScheme.onPrimary),
              NavigationButton(text: 'Acessar o SIGA', child: const SigaPage()),
              Divider(color: Theme.of(context).colorScheme.onPrimary),
              NavigationButton(text: 'Sobre', child: const AboutPage()),
              const SizedBox(height: 8),
              FutureBuilder<PackageInfo>(future: PackageInfo.fromPlatform(),builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.done:
                    return Align(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                          'Já tá no Siga? v${snapshot.data!.version}', style: TextStyle(fontSize: 12, color: MainTheme.white)),
                    );
                  default:
                    return const SizedBox();
                }
              }),
              const SizedBox(height: 8)
            ],
          ),
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 70,
        child: ElevatedButton(
          onPressed: ()async{
            showModalBottomSheetConfirmAction(context, 'Deseja mesmo sair?', ()async{
              setState(()=>inExit=true);
              try{
                await control.deleteDatabase();
                studentRep.student = Student(cpf: '', password: '');
                stundentCardRep.studentCard = StudentCard.empty();
                await settingRep.clear();
                if(mounted){
                  Navigator.pop(context);
                  Navigator.pushReplacement(context, PageTransition(child: const LoginPage(), type: PageTransitionType.fade));
                }
              }catch (e){
                debugPrint('Error: $e');
              }finally{
                setState(()=>inExit=false);
              }
            });
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
