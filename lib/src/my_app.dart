import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  final Widget page;
  const MyApp({super.key, required this.page});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ResolveLight',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Resolve-Light'),
      home: page,
    );
  }
}