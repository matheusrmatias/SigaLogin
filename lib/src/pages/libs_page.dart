import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sigalogin/src/widgets/link_button.dart';
import 'package:url_launcher/url_launcher_string.dart';

class LibsPage extends StatefulWidget {
  const LibsPage({super.key});

  @override
  State<LibsPage> createState() => _LibsPageState();
}

class _LibsPageState extends State<LibsPage> {
  Map<String,String> libs = {
    'Provider' : 'https://pub.dev/packages/provider',
    'Eva Icons Flutter' : 'https://pub.dev/packages/eva_icons_flutter',
    'Webview Flutter' : 'https://pub.dev/packages/webview_flutter',
    'Page Transition' : 'https://pub.dev/packages/page_transition',
    'Sqflite' : 'https://pub.dev/packages/sqflite',
    'Contained Tab Bar View' : 'https://pub.dev/packages/contained_tab_bar_view',
    'FlutterToast' : 'https://pub.dev/packages/fluttertoast',
    'Unicons' : 'https://pub.dev/packages/unicons',
    'Shared Preferences' : 'https://pub.dev/packages/shared_preferences',
    'Url Launcher' : 'https://pub.dev/packages/url_launcher'
  };

  List<String> keys = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    keys = libs.keys.toList();
    keys.sort();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Libs Utilizadas', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 32),
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: keys.length,
            itemBuilder: (ctx,index){
              return LinkButton(func: ()async{
                try{
                  await launchUrlString(libs[keys[index]]!, mode: LaunchMode.externalApplication);
                }catch (e){
                  Fluttertoast.showToast(msg: 'Não é possível abrir o link');
                }
              }, text: keys[index]);
            }
        ),
      ),
    );
  }
}
