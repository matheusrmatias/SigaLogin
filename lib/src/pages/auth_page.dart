import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sigalogin/src/pages/home_page.dart';
import 'package:sigalogin/src/services/local_auth_service.dart';
import 'package:sigalogin/src/themes/main_theme.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  LocalAuthService service = LocalAuthService();
  bool inAuthenticate = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _validate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              inAuthenticate? CircularProgressIndicator(color: MainTheme.orange,):Image.asset(
                'assets/images/splash.png',
                width: 175,
                height: 175,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16,horizontal: 32),
        child: inAuthenticate? const SizedBox():ElevatedButton(onPressed: _validate,style: ElevatedButton.styleFrom(backgroundColor: MainTheme.orange), child: const Row(mainAxisAlignment: MainAxisAlignment.center,children: [ Flexible(child: Text('Validar identidade',style: TextStyle(fontSize: 24)))])),
      ),
    );

  }
  Future<void> _validate()async{
    setState(()=>inAuthenticate=true);
    final authenticated = await service.authenticate();
    setState(()=>inAuthenticate=false);

    if(authenticated){
      if(mounted)Navigator.pushReplacement(context, PageTransition(child: const HomePage(), type: PageTransitionType.fade));
    }
  }
}
