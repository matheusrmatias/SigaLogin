import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sigalogin/src/repositories/settings_repository.dart';
import 'package:sigalogin/src/widgets/settings_switch.dart';

class ViewSettings extends StatefulWidget {
  const ViewSettings({super.key});

  @override
  State<ViewSettings> createState() => _ViewSettingsState();
}

class _ViewSettingsState extends State<ViewSettings> {
  late SettingRepository prefs;
  _funcitonFt(bool e)async{
    prefs.imageDisplay = e;
  }
  @override
  Widget build(BuildContext context) {
    prefs = Provider.of<SettingRepository>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuração de Exibição', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 32),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              SettingSwitch(text: 'Foto de Perfil', onChange: _funcitonFt, value: prefs.imageDisplay)
            ],
          ),
        ),
      ),
    );
  }
}
