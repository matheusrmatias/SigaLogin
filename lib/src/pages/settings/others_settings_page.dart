import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sigalogin/src/repositories/settings_repository.dart';
import 'package:sigalogin/src/themes/main_theme.dart';
import 'package:sigalogin/src/widgets/settings_switch.dart';

class OtherSettingsPage extends StatefulWidget {
  const OtherSettingsPage({super.key});

  @override
  State<OtherSettingsPage> createState() => _OtherSettingsPageState();
}

class _OtherSettingsPageState extends State<OtherSettingsPage> {
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
          child: Column(
            children: [
              const Row(
                children: [
                  Flexible(child: Text('Sincronização',style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)))
                ],
              ),
              Divider(color: Theme.of(context).brightness==Brightness.dark?MainTheme.white:MainTheme.black,),
              SettingSwitch(text: 'Sincronizar dados ao abrir o app', onChange: (e)=>prefs.updateOnOpen = e, value: prefs.updateOnOpen,icon: Icons.sync),
              SettingSwitch(text: 'Sincronizar horários a partir do Siga', onChange: (e)=>prefs.updateSchedule = e, value: prefs.updateSchedule,icon: Icons.schedule),
              const Row(
                children: [
                  Flexible(child: Text('Notificações',style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)))
                ],
              ),
              Divider(color: Theme.of(context).brightness==Brightness.dark?MainTheme.white:MainTheme.black,),
              SettingSwitch(text: 'Habilitar lembretes de aula', onChange: (e)=>prefs.enableReminder = e, value: prefs.enableReminder,icon: Icons.school)
            ],
          ),
        ),
      ),
    );
  }
}
