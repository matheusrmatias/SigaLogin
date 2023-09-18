import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:sigalogin/src/themes/main_theme.dart';
import 'package:sigalogin/src/widgets/login_input.dart';

import '../controllers/student_controller.dart';
import '../models/student.dart';
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

  @override
  Widget build(BuildContext context) {
    studentRep = Provider.of<StudentRepository>(context);
    return Scaffold(
      backgroundColor: MainTheme.white,
      body:Column(
        children: [
          Expanded(flex: 1,child: Container(
          )),
          Expanded(flex: 2,child: Container(
            padding: const EdgeInsets.only(right: 32,left: 32,top: 16),
            width: double.maxFinite,
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.tertiary,
                borderRadius: const BorderRadius.only(topRight: Radius.circular(50))
            ),
            child: SingleChildScrollView(
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
                    ):ElevatedButton(onPressed: _login,style: ElevatedButton.styleFrom(backgroundColor: MainTheme.orange, minimumSize: const Size(double.maxFinite, 48)), child: Text('Confirmar',style: TextStyle(color: MainTheme.white, fontSize: 24))),
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
      }

    }finally{
      setState(()=>progress='');
      setState(()=>inLogin=false);
    }
  }
}
