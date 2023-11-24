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
  Brightness? currentTheme;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller
        .setNavigationDelegate(NavigationDelegate(onPageFinished: (e) async {
      if (e == 'https://siga.cps.sp.gov.br/aluno/login.aspx') {
        currentTheme = Theme.of(context).brightness;
        student = await control.queryStudent();
        await controller.runJavaScript(
            "document.getElementById('vSIS_USUARIOID').value='${student.cpf}'");
        await controller.runJavaScript(
            "document.getElementById('vSIS_USUARIOSENHA').value='${student.password}'");
        await controller.runJavaScript(
            "document.getElementsByName('BTCONFIRMA')[0].click()");
      }
      _alterTheme();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title:
              const Text('SIGA', style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () => _alterTheme(alterTheme: true),
                icon: const Icon(Icons.brightness_4))
          ],
        ),
        body: WebViewWidget(controller: controller),
        bottomNavigationBar: Container(
          color: Theme.of(context).colorScheme.primary,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                  onPressed: () async {
                    await controller.goBack();
                  },
                  icon: const Icon(Icons.arrow_back)),
              IconButton(
                  onPressed: () {
                    controller.loadRequest(Uri.parse(
                        'https://siga.cps.sp.gov.br/aluno/home.aspx'));
                  },
                  icon: const Icon(Icons.home)),
              IconButton(
                  onPressed: () async {
                    await controller.goForward();
                  },
                  icon: const Icon(Icons.arrow_forward)),
            ],
          ),
        ));
  }

  _alterTheme({bool alterTheme = false}) async {
    if (alterTheme)
      currentTheme =
          currentTheme == Brightness.dark ? Brightness.light : Brightness.dark;
    if (currentTheme == Brightness.dark) {
      await controller.runJavaScript('''
        var elements = document.getElementsByTagName("*");

        for (var i = 0; i < elements.length; i++) {
          elements[i].style.backgroundColor = "#252525";
        }
        ''');
      await controller.runJavaScript('''
        var elements = document.getElementsByTagName("*");

        for (var i = 0; i < elements.length; i++) {
          elements[i].style.color = "White";
        }
        ''');
    } else {
      await controller.runJavaScript('''
        var elements = document.getElementsByTagName("*");

        for (var i = 0; i < elements.length; i++) {
          elements[i].style.backgroundColor = "White";
        }
        ''');
      await controller.runJavaScript('''
          var elements = document.getElementsByTagName("*");

          for (var i = 0; i < elements.length; i++) {
            elements[i].style.color = "Black";
          }
        ''');
    }
  }
}
