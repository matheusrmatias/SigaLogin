import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:sigalogin/src/models/student.dart';
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
  TextEditingController identification = TextEditingController();
  TextEditingController password = TextEditingController();
  bool inLogin = false;
  String progress = '';
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    studentRep = Provider.of<StudentRepository>(context);
    return Scaffold(
      backgroundColor: MainTheme.white,
      body:Column(
        children: [
          Expanded(flex: 1,child: Container(
            alignment: Alignment.bottomCenter,
            child: Image.asset('assets/images/college campus-bro.png',width: double.maxFinite, fit: BoxFit.cover,alignment: Alignment.bottomCenter),
          )),
          Expanded(flex: 2,child: Container(
            padding: const EdgeInsets.only(right: 32,left: 32,top: 16),
            width: double.maxFinite,
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.tertiary,
                borderRadius: const BorderRadius.only(topRight: Radius.circular(50))
            ),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 40),
                    alignment: AlignmentDirectional.topStart,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(child: Text('SIGA ', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold,color: Theme.of(context).colorScheme.onPrimary))),
                        Flexible(child: Text('LOGIN', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold,color: MainTheme.orange))),
                      ],
                    ),
                  ),
                  LoginInput(controller: identification,icon: const Icon(Icons.person),hint: 'CPF',maxLength: 11, inputType: TextInputType.number,inputFormat: [FilteringTextInputFormatter.allow(RegExp(r'([0-9])'))]),
                  LoginInput(controller: password,icon: const Icon(Icons.lock),hint: 'Senha',obscure: true),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: inLogin?Column(
                      children: [
                        CircularProgressIndicator(color: MainTheme.orange),
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
                    },style: ElevatedButton.styleFrom(backgroundColor: MainTheme.orange, minimumSize: const Size(double.maxFinite, 48)), child: Text('Confirmar',style: TextStyle(color: MainTheme.white, fontSize: 24))),
                  )
                ],
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
    Student student = Student(cpf: identification.text, password: password.text);
    StudentController control = StudentController();


    try{
      // Navigator.push(context, PageTransition(child: TestePage(web: account.view), type: PageTransitionType.fade));
      setState(()=>progress='Carregando Dados');
      await account.userLogin(student);
      setState(()=>progress='Carregando Histórico');
      await account.userHistoric(student);
      setState(()=>progress='Carregando Notas');
      await account.userAssessment(student);
      setState(()=>progress='Carregando Horários');
      await account.userSchedule(student);
      setState(()=>progress='Carregando Faltas');
      await account.userAbsences(student);
      setState(()=>progress='Carregando Ementas');
      await account.userAssessmentDetails(student);

      studentRep.student = student;

      await control.insertDatabase(student);
      if(context.mounted){
        Navigator.pushReplacement(context, PageTransition(child: const HomePage(), type: PageTransitionType.fade));
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
