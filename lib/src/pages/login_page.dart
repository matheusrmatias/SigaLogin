import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:sigalogin/src/models/assessment.dart';
import 'package:sigalogin/src/models/historic.dart';
import 'package:sigalogin/src/models/schedule.dart';
import 'package:sigalogin/src/models/student.dart';
import 'package:sigalogin/src/models/update.dart';
import 'package:sigalogin/src/pages/TestePage.dart';
import 'package:sigalogin/src/repositories/settings_repository.dart';
import 'package:sigalogin/src/repositories/update_repository.dart';
import 'package:sigalogin/src/themes/main_theme.dart';
import 'package:sigalogin/src/widgets/login_input.dart';
import 'package:sigalogin/src/widgets/show_modal_bootm_sheet_default.dart';
import 'package:sigalogin/src/models/student.dart';

import '../controllers/student_controller.dart';
import '../repositories/student_repository.dart';
import '../services/student_account.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late StudentRepository studentRep;
  late SettingRepository setting;
  late Update update;
  TextEditingController identification = TextEditingController();
  TextEditingController password = TextEditingController();
  bool inLogin = false;
  String progress = '';
  int counter = 0;
  int percentage = 0;

  @override
  Widget build(BuildContext context) {
    studentRep = Provider.of<StudentRepository>(context);
    setting = Provider.of<SettingRepository>(context);
    update = Provider.of<UpdateRepository>(context).update!;
    return Scaffold(
      backgroundColor: MainTheme.white,
      body:Column(
        children: [
          Expanded(flex: 1,child: Container(
            color: MainTheme.white,
            alignment: Alignment.bottomCenter,
            child: Image.asset('assets/images/icon-transparent.png',width: double.maxFinite,alignment: Alignment.bottomCenter),
          )),
          Expanded(flex: 2,child: Container(
              padding: const EdgeInsets.only(right: 32,left: 32,top: 16),
              width: double.maxFinite,
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.tertiary,
                  borderRadius: const BorderRadius.only(topRight: Radius.circular(50))
              ),
              child: Center(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),

                  child: Column(
                    children: [
                      LoginInput(controller: identification,icon: const Icon(Icons.person),hint: 'CPF',maxLength: 11, inputType: TextInputType.number,inputFormat: [FilteringTextInputFormatter.allow(RegExp(r'([0-9])'))],enbled: !inLogin),
                      LoginInput(controller: password,icon: const Icon(Icons.lock),hint: 'Senha',obscure: true, enbled: !inLogin),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: inLogin?Column(
                          children: [
                            Stack(alignment: Alignment.center,children: [
                              SizedBox(height: MediaQuery.of(context).textScaleFactor*44,width: MediaQuery.of(context).textScaleFactor*44, child: CircularProgressIndicator(color: MainTheme.orange)),
                              Text('$percentage %')
                            ],),
                            const SizedBox(height: 8),
                            Text(progress, style:TextStyle(color: Theme.of(context).colorScheme.onPrimary))
                          ],
                        ):ElevatedButton(onPressed: (){
                          if(identification.text.isEmpty){
                            Fluttertoast.showToast(msg: 'Informe o CPF');
                          }else if(password.text.isEmpty){
                            Fluttertoast.showToast(msg: 'Informe a Senha');
                          }else if(identification.text.length<10 || identification.text.length>11){
                            Fluttertoast.showToast(msg: 'Informe um CPF válido');
                          }else{
                            _login();
                          }
                        },style: ElevatedButton.styleFrom(backgroundColor: MainTheme.orange, minimumSize: const Size(double.maxFinite, 48)), child: Text('Confirmar',style: TextStyle(color: MainTheme.white, fontSize: 24, fontWeight: FontWeight.bold))),
                      )
                    ],
                  ),
                ),
              )
            )
          )
        ],
      ),

    );
  }

  _login()async{
    counter++;
    setState(()=>inLogin=true);
    StudentAccount account = StudentAccount();
    StudentController control = StudentController();
    List<Historic> historic = [];
    List<DisciplineAssessment> assessment = [];
    List<Schedule> schedule = [];
    Student student = Student(cpf: identification.text, password: password.text);

    try{
      // Navigator.push(context, PageTransition(child: TestePage(controller: account.view), type: PageTransitionType.fade));
      percentage = 0;
      setState(()=>progress='Carregando Dados');
      student = await account.userLogin(student);
      percentage = 15;
      setState(()=>progress='Carregando Histórico');
      historic = await account.userHistoric();
      percentage = 30;
      setState(()=>progress='Carregando Notas');
      percentage = 45;
      assessment = await account.userAssessment();
      percentage = 60;
      setState(()=>progress='Carregando Horários');
      schedule = await account.userSchedule();
      percentage = 75;
      setState(()=>progress='Carregando Faltas');
      assessment = await account.userAbsences(assessment);
      percentage = 90;
      setState(()=>progress='Carregando Ementas');
      assessment = await account.userAssessmentDetails(assessment);
      percentage = 100;
      studentRep.student = student;

      studentRep.allHistoric=historic;
      studentRep.historic = historic;

      studentRep.allAssessment = assessment;
      studentRep.assessment = assessment;

      studentRep.schedule = schedule;

      await control.insertStudent(student);
      await control.insertSchedule(schedule);
      await control.insertAssessment(assessment);
      await control.insertHistoric(historic);


      setting.lastInfoUpdate = 'Última Atualização: ${DateFormat('dd/MM HH:mm').format(DateTime.now())}';

      if(context.mounted){
        Navigator.pushReplacement(context, PageTransition(child: HomePage(afterLogin: true, update: update), type: PageTransitionType.fade));
      }
    }catch(e){
      debugPrint('Error $e');
      if(e.toString() == 'Exception: User or Password Incorrect'){
        Fluttertoast.showToast(msg: 'Senha e/ou CPF Inválidos');
      }else{
        Fluttertoast.showToast(msg: 'Ocorreu um erro, tente novamente!');
        if(counter==3){
          counter=0;
          showModalBottomSheetDefault(context, 'Várias tentativas de login sem sucesso, por favor, verifique:\nSua conexão com a internet;\nSe o SIGA está funcionando;');
        }
      }

    }finally{
      setState(()=>progress='');
      setState(()=>inLogin=false);
    }
  }
}