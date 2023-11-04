import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sigalogin/src/repositories/settings_repository.dart';
import 'package:sigalogin/src/themes/main_theme.dart';
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

  GlobalKey _dropdownButtonKey = GlobalKey();


  List<String> _themesList = ['Padrão do Sistema','Claro', 'Escuro'];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: InkWell(
                  borderRadius: const BorderRadius.all(Radius.circular(16)),
                  splashColor: MainTheme.blackLowOpacity,
                  highlightColor: MainTheme.blackLowOpacity,
                  onTap: openDropdown,
                  child: Ink(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    decoration: BoxDecoration(
                        color: Theme.of(context).brightness==Brightness.dark?MainTheme.black:MainTheme.lightGrey,
                        borderRadius: const BorderRadius.all(Radius.circular(16))
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [Icon(Theme.of(context).brightness == Brightness.light? Icons.light_mode:Icons.dark_mode,color: MainTheme.orange),const SizedBox(width: 8),Expanded(child: Text('Tema',style: TextStyle(color: MainTheme.orange,fontWeight: FontWeight.bold,fontSize: 16)))],
                        ),
                        IgnorePointer(
                          child: DropdownButton(
                            key: _dropdownButtonKey,
                            autofocus: true,
                            borderRadius: const BorderRadius.all(Radius.circular(16)),
                            isDense: true,
                            underline: const SizedBox(),
                            style: TextStyle(fontSize: 14,fontWeight: FontWeight.normal,fontFamily: 'ResolveLight',color: Theme.of(context).brightness==Brightness.dark?MainTheme.white:MainTheme.black),
                            dropdownColor: Theme.of(context).brightness==Brightness.dark?MainTheme.black:MainTheme.lightGrey,
                            iconEnabledColor: Theme.of(context).brightness==Brightness.dark?MainTheme.white:MainTheme.black,
                            iconDisabledColor: Theme.of(context).brightness==Brightness.dark?MainTheme.white:MainTheme.black,
                            isExpanded: true,
                            value: prefs.theme,
                            items: _themesList.map((e) => DropdownMenuItem(child: Text(e), value: e,)).toList(),
                            onChanged: (e)=>prefs.theme=e.toString(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Divider(color: Theme.of(context).colorScheme.onPrimary),
              SettingSwitch(text: 'Foto de perfil na página inicial', onChange: _funcitonFt, value: prefs.imageDisplay,icon: Icons.person),
            ],
          ),
        ),
      ),
    );
  }
  void openDropdown() {
    _dropdownButtonKey.currentContext?.visitChildElements((element) {
      if (element.widget is Semantics) {
        element.visitChildElements((element) {
          if (element.widget is Actions) {
            element.visitChildElements((element) {
              Actions.invoke(element, const ActivateIntent());
            });
          }
        });
      }
    });
  }
}
