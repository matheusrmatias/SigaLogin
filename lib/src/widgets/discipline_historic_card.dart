import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../themes/main_theme.dart';
import 'circle_info.dart';

class DisciplineHistoricCard extends StatelessWidget {
  Map<String,String> discipline;
  MainTheme theme = MainTheme();
  DisciplineHistoricCard({required this.discipline});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: MainTheme.tertiary,
          borderRadius: const BorderRadius.all(Radius.circular(8))
      ),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [Flexible(child: Text(discipline['acronym']!, style: TextStyle(color: MainTheme.black, fontSize: 10))),Flexible(child: Text(discipline['period']!.substring(0, discipline['period']!.length - 1) + '-' + discipline['period']!.substring(discipline['period']!.length - 1), style: TextStyle(fontSize: 10, color: MainTheme.black)))]),
          Container(margin: const EdgeInsets.symmetric(vertical: 4),child: Row(children: [Expanded(child: Text(discipline['name']!, style:TextStyle(fontSize: 14, fontWeight: FontWeight.bold,color: MainTheme.black)))])),
          Row(mainAxisAlignment: MainAxisAlignment.end,crossAxisAlignment: CrossAxisAlignment.end,children: [
            Expanded(child: Text(discipline['observation']!, style: TextStyle(color: MainTheme.black, fontSize: 12))),
            CircleInfo(MainTheme.lightOrange, title: 'Frequência', text: discipline['frequency']!.replaceAll(' ', ''), textColor: MainTheme.black),
            CircleInfo(MainTheme.orange, textColor: MainTheme.black,title: 'Média', text: discipline['average'].toString())
          ]),

        ],
      ),
    );
  }
}