import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
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
import 'package:url_launcher/url_launcher.dart';

import '../controllers/student_controller.dart';
import '../repositories/student_repository.dart';
import '../services/student_account.dart';
import 'home/home_page.dart';

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
      backgroundColor: MainTheme.orange,
      body:Column(
        children: [
          Expanded(child: SizedBox(
              child: Center(
                child: SingleChildScrollView(
                  reverse: true,             
                  child: Column(
                    children: [
                      Padding(padding: const EdgeInsets.symmetric(horizontal: 80),child: Image.asset('assets/images/icon-transparent.png',width: double.maxFinite,alignment: Alignment.bottomCenter)),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 32),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                            color: MainTheme.lightGrey,
                            boxShadow: [
                              BoxShadow(color:MainTheme.black, offset: const Offset(8,8)),
                            ],
                            borderRadius: const BorderRadius.all(Radius.circular(16))
                        ),
                        child: Column(
                          children: [
                            AutofillGroup(child: Column(
                              children: [
                                LoginInput(onEditingComplete: ()=>TextInput.finishAutofillContext(),controller: identification,icon: const Icon(Icons.person),hint: 'CPF',maxLength: 14, inputType: TextInputType.number,inputFormat: [MaskTextInputFormatter(mask: '###.###.###-##',filter: {'#':RegExp(r'([0-9])')})],enbled: !inLogin,autofillHints: const [AutofillHints.username,AutofillHints.newUsername],),
                                LoginInput(onEditingComplete: ()=>TextInput.finishAutofillContext(),controller: password,icon: const Icon(Icons.lock),hint: 'Senha',obscure: true, enbled: !inLogin,autofillHints: const [AutofillHints.password,AutofillHints.newPassword],),
                              ],
                            )),
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: inLogin?Column(
                                children: [
                                  // Stack(alignment: Alignment.center,children: [
                                  //
                                  // ],),
                                  Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      ClipRRect(
                                        borderRadius: const BorderRadius.all(Radius.circular(16)),
                                        child: LinearProgressIndicator(
                                          backgroundColor: MainTheme.black,
                                          color: MainTheme.lightBlue,
                                          value: percentage/100,
                                          minHeight: MediaQuery.of(context).textScaleFactor*30
                                        ),
                                      ),
                                      Text('$progress $percentage %', style:TextStyle(color: MainTheme.white),textAlign: TextAlign.center)
                                    ],
                                  ),
                                ],
                              ):ElevatedButton(onPressed: (){
                                if(identification.text.isEmpty){
                                  Fluttertoast.showToast(msg: 'Informe o CPF');
                                }else if(password.text.isEmpty){
                                  Fluttertoast.showToast(msg: 'Informe a Senha');
                                }else if(identification.text.length<13){
                                  Fluttertoast.showToast(msg: 'Informe um CPF válido');
                                }else{
                                  _login();
                                }
                              },style: ElevatedButton.styleFrom(backgroundColor: MainTheme.lightBlue, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),padding: const EdgeInsets.symmetric(vertical: 8),minimumSize: const Size(double.maxFinite, 48)), child: Text('Confirmar',style: TextStyle(color: MainTheme.white, fontSize: 24, fontWeight: FontWeight.bold))),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      inLogin?const SizedBox():GestureDetector(
                        onTap: ()async=>await launchUrl(Uri.parse('https://siga.cps.sp.gov.br/aluno/login.aspx')),
                        child: Text('Esqueci a senha',style: TextStyle(color: MainTheme.white)),
                      )
                    ],
                  )
                )
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
    Student student = Student(cpf: identification.text.replaceAll('.', '').replaceAll('-',''), password: password.text);

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
      TextInput.finishAutofillContext();
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