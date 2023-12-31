import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sigalogin/src/models/historic.dart';

import '../themes/main_theme.dart';
import 'circle_info.dart';

class DisciplineHistoricCard extends StatelessWidget {
  Historic discipline;
  MainTheme theme = MainTheme();
  DisciplineHistoricCard({required this.discipline});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Theme.of(context).brightness==Brightness.dark?MainTheme.black:MainTheme.lightGrey,
          borderRadius: const BorderRadius.all(Radius.circular(16))
      ),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [Flexible(child: Text(discipline.acronym, style: const TextStyle(fontSize: 10))),Flexible(child: Text('${discipline.period.substring(0, discipline.period.length - 1)}-${discipline.period.substring(discipline.period.length - 1)}', style: const TextStyle(fontSize: 10)))]),
          Container(margin: const EdgeInsets.symmetric(vertical: 4),child: Row(children: [Expanded(child: Text(discipline.name, style:TextStyle(fontSize: 14, fontWeight: FontWeight.bold)))])),
          Row(mainAxisAlignment: MainAxisAlignment.end,crossAxisAlignment: CrossAxisAlignment.end,children: [
            Expanded(child: Text(discipline.observation, style: const TextStyle(fontSize: 12))),
            CircleInfo(MainTheme.lightOrange, title: 'Frequência', text: '${discipline.frequency.toInt()}%'),
            CircleInfo(MainTheme.orange,title: 'Média', text: discipline.avarage.toString()[discipline.avarage.toString().length-1]=='0'?discipline.avarage.toInt().toString():discipline.avarage.toString())
          ]),

        ],
      ),
    );
  }
}