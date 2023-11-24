import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:sigalogin/src/models/update.dart';
import 'package:sigalogin/src/pages/home/home_page.dart';
import 'package:sigalogin/src/repositories/settings_repository.dart';
import 'package:sigalogin/src/repositories/update_repository.dart';
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
  late bool _updateOnOpen;
  late Update update;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _validate();
  }

  @override
  Widget build(BuildContext context) {
    _updateOnOpen = Provider.of<SettingRepository>(context).updateOnOpen;
    update = Provider.of<UpdateRepository>(context).update!;
    return Scaffold(
      backgroundColor: MainTheme.orange,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              inAuthenticate? CircularProgressIndicator(color: MainTheme.white,):Image.asset(
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
        child: inAuthenticate? const SizedBox():ElevatedButton(onPressed: _validate,style: ElevatedButton.styleFrom(backgroundColor: MainTheme.lightBlue,padding: const EdgeInsets.all(16)), child: const Row(mainAxisAlignment: MainAxisAlignment.center,children: [ Flexible(child: Text('Validar identidade',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)))])),
      ),
    );

  }
  Future<void> _validate()async{
    setState(()=>inAuthenticate=true);
    final authenticated = await service.authenticate();
    setState(()=>inAuthenticate=false);

    if(authenticated){
      if(mounted)Navigator.pushReplacement(context, PageTransition(child: HomePage(afterLogin: !_updateOnOpen,update: update), type: PageTransitionType.fade));
    }
  }
}
