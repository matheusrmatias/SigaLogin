import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sigalogin/src/themes/main_theme.dart';
import 'package:sigalogin/src/widgets/login_input.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late MainTheme theme;
  TextEditingController identification = TextEditingController();
  TextEditingController password = TextEditingController();
  bool inLogin = false;
  String progress = '';

  @override
  Widget build(BuildContext context) {
    theme = Provider.of<MainTheme>(context);
    return Scaffold(
      backgroundColor: theme.onPrimary,
      body:Column(
        children: [
          Expanded(flex: 1,child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Flexible(child: Text('FATEC', style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold,color: theme.primary)))
              ],
            ),
          )),
          Expanded(flex: 2,child: Container(
            padding: const EdgeInsets.only(right: 32,left: 32,top: 16),
            width: double.maxFinite,
            decoration: BoxDecoration(
                color: theme.primary,
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
                        Flexible(child: Text('SIGA ', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold,color: theme.onPrimary))),
                        Flexible(child: Text('LOGIN', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold,color: theme.secondary))),
                      ],
                    ),
                  ),
                  LoginInput(controller: identification,icon: const Icon(Icons.person),hint: 'CPF',maxLength: 11, inputType: TextInputType.number,inputFormat: [FilteringTextInputFormatter.allow(RegExp(r'([0-9])'))]),
                  LoginInput(controller: password,icon: const Icon(Icons.lock),hint: 'Senha',obscure: true),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: inLogin?Column(
                      children: [
                        CircularProgressIndicator(color: theme.secondary),
                        Text(progress, style:TextStyle(color: theme.onPrimary))
                      ],
                    ):ElevatedButton(onPressed: _login,style: ElevatedButton.styleFrom(backgroundColor: theme.secondary, minimumSize: const Size(double.maxFinite, 48)), child: Text('Confirmar',style: TextStyle(color: theme.onSecondary, fontSize: 24))),
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
    await Future.delayed(Duration(seconds: 2));
    setState(()=>inLogin=false);
  }
}
