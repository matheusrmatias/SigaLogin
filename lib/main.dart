
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sigalogin/src/my_app.dart';
import 'package:sigalogin/src/pages/login_page.dart';
import 'package:sigalogin/src/themes/main_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<MainTheme>(create: (context)=>MainTheme())
        ],
        child: const MyApp(page: LoginPage()),
      )
  );
}