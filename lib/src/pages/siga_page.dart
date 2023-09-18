import 'package:flutter/material.dart';
import 'package:sigalogin/src/controllers/student_controller.dart';
import 'package:sigalogin/src/models/student.dart';
import 'package:sigalogin/src/themes/main_theme.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SigaPage extends StatefulWidget {
  const SigaPage({super.key});

  @override
  State<SigaPage> createState() => _SigaPageState();
}

class _SigaPageState extends State<SigaPage> {
  Student student = Student(cpf: '', password: '');
  StudentController control = StudentController();
  WebViewController controller = WebViewController()
    ..loadRequest(Uri.parse('https://siga.cps.sp.gov.br/aluno/login.aspx'))
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(MainTheme.white);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.setNavigationDelegate(NavigationDelegate(
        onPageFinished: (e)async{
          if(e=='https://siga.cps.sp.gov.br/aluno/login.aspx'){
            await control.queryStudent(student);
            await controller.runJavaScript("document.getElementById('vSIS_USUARIOID').value='${student.cpf}'");
            await controller.runJavaScript("document.getElementById('vSIS_USUARIOSENHA').value='${student.password}'");
            await controller.runJavaScript("document.getElementsByName('BTCONFIRMA')[0].click()");
          }
        }
    ));
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: const Text('SIGA', style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        body: WebViewWidget(controller: controller),
        bottomNavigationBar: Container(
          color: Theme.of(context).colorScheme.primary,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(onPressed: ()async{await controller.goBack();}, icon: const Icon(Icons.arrow_back)),
              IconButton(onPressed: (){controller.loadRequest(Uri.parse('https://siga.cps.sp.gov.br/aluno/home.aspx'));}, icon: const Icon(Icons.home)),
              IconButton(onPressed: ()async{await controller.goForward();}, icon: const Icon(Icons.arrow_forward)),
            ],
          ),
        )
    );
  }
}