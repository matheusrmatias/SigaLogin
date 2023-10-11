import 'package:flutter/material.dart';
import 'package:sigalogin/src/themes/main_theme.dart';
import '../models/schedule.dart';

class ScheduleCard extends StatefulWidget {
  final Schedule schedule;
  const ScheduleCard({super.key, required this.schedule});

  @override
  State<ScheduleCard> createState() => _ScheduleCardState();
}

class _ScheduleCardState extends State<ScheduleCard> {
  Schedule schedule = Schedule();
  List<Widget> list = [];
  int counter = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    schedule = widget.schedule;
    list.add(Row(children: [Expanded(child: Text(schedule.weekDay,style: TextStyle(fontSize: 14, color: MainTheme.orange, fontWeight: FontWeight.bold)))]));
    for (var element in schedule.schedule) {
      if(element.length==2){
        list.add(Divider(color: MainTheme.orange));
        list.add(
            Container(
              margin: const EdgeInsets.only(top: 8),
              child: Row(crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [Text(element[0],style: TextStyle(color: MainTheme.black, fontSize: 12, fontFamily: "Arial"), textAlign: TextAlign.justify),const SizedBox(width: 8),Expanded(child: Text(element[1],style: TextStyle(color: MainTheme.black, fontSize: 14),textAlign: TextAlign.end))]),
            )
        );
      }
    }
    if(list.length==1){
      list.add(Divider(color: MainTheme.orange));
      list.add(Row(crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [Flexible(child: Text("Nenhum horário de aula encontrado.",style: TextStyle(color: MainTheme.black, fontSize: 12, fontFamily: "Arial")))]));
    }
  }

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
        children: list,
      ),
    );
  }
}