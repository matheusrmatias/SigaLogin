import 'package:flutter/material.dart';
import 'package:sigalogin/src/themes/main_theme.dart';

class MyApp extends StatelessWidget {
  final Widget page;
  const MyApp({super.key, required this.page});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ResolveLight',
      debugShowCheckedModeBanner: false,
      theme: MainTheme.lightTheme,
      darkTheme: MainTheme.darkTheme,
      home: page,
    );
  }
}
