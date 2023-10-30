import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TestePage extends StatefulWidget {
  final WebViewController controller;
  const TestePage({super.key, required this.controller});

  @override
  State<TestePage> createState() => _TestePageState();
}

class _TestePageState extends State<TestePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: WebViewWidget(controller: widget.controller),
    );
  }
}
