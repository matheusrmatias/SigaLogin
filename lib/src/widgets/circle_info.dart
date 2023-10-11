import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sigalogin/src/themes/main_theme.dart';

class CircleInfo extends StatelessWidget {
  Color color = MainTheme.orange;
  Color textColor;
  String title;
  String text;
  CircleInfo(this.color, {required this.title, required this.text,super.key, this.textColor = Colors.white});

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: const EdgeInsets.only(left: 4),
      child: Column(
          children: [
            CircleAvatar(backgroundColor: color, child: Text(text.replaceAll(' ', ''), style: TextStyle(color: MainTheme.white, fontSize: 12))),
            const SizedBox(height: 4),
            Text(title, style: TextStyle(fontSize: 12, color: textColor, fontWeight: FontWeight.bold))
          ]
      ),
    );
  }
}