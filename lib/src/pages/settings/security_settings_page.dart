import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:sigalogin/src/repositories/settings_repository.dart';
import 'package:sigalogin/src/services/local_auth_service.dart';
import 'package:sigalogin/src/widgets/settings_switch.dart';

class SecuritySettingPage extends StatefulWidget {
  const SecuritySettingPage({super.key});

  @override
  State<SecuritySettingPage> createState() => _SecuritySettingPageState();
}

class _SecuritySettingPageState extends State<SecuritySettingPage> {
  late SettingRepository prefs;
  _funcitonFt(bool e)async{
    LocalAuthService service = LocalAuthService();
    if(e){
      if(!(await service.isBiometricAvailable())){
        Fluttertoast.showToast(msg: 'Biometria não disponível');
        prefs.appLock = false;
        return;
      }
      if(!(await service.authenticate())){
        Fluttertoast.showToast(msg: 'Biometria não reconhecida');
        prefs.appLock = false;
        return;
      }
      prefs.appLock = e;
      return;
    }
    prefs.appLock = e;
  }
  @override
  Widget build(BuildContext context) {
    prefs = Provider.of<SettingRepository>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuração de Segurança', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 32),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              SettingSwitch(text: 'Bloqueio do Aplicativo', onChange: _funcitonFt, value: prefs.appLock)
            ],
          ),
        ),
      ),
    );
  }
}
