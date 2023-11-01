import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sigalogin/src/repositories/settings_repository.dart';
import 'package:sigalogin/src/widgets/settings_switch.dart';

class OtherSettingsPage extends StatefulWidget {
  const OtherSettingsPage({super.key});

  @override
  State<OtherSettingsPage> createState() => _OtherSettingsPageState();
}

class _OtherSettingsPageState extends State<OtherSettingsPage> {
  _function(bool e){
    prefs.updateOnOpen = e;
  }

  late SettingRepository prefs;

  @override
  Widget build(BuildContext context) {
    prefs = Provider.of<SettingRepository>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Outras Configurações', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 32),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              SettingSwitch(text: 'Sincronizar dados ao abrir o app', onChange: _function, value: prefs.updateOnOpen,icon: Icons.sync)
            ],
          ),
        ),
      ),
    );
  }
}
