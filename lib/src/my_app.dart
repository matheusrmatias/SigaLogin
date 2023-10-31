import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sigalogin/src/repositories/settings_repository.dart';
import 'package:sigalogin/src/themes/main_theme.dart';

class MyApp extends StatelessWidget {
  final Widget page;
  MyApp({super.key, required this.page});
  late SettingRepository settingRep;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    settingRep = Provider.of<SettingRepository>(context);
    return MaterialApp(
      title: 'ResolveLight',
      debugShowCheckedModeBanner: false,
      theme: MainTheme.lightTheme,
      darkTheme: MainTheme.darkTheme,
      themeMode: settingRep.theme==null||settingRep.theme=='Padrão do Sistema'?ThemeMode.system:settingRep.theme=='Claro'?ThemeMode.light:ThemeMode.dark,
      home: page,
    );
  }
}
