import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sigalogin/src/repositories/settings_repository.dart';
import 'package:sigalogin/src/themes/main_theme.dart';

import 'package:sigalogin/src/models/student.dart';
import 'package:sigalogin/src/repositories/student_repository.dart';
import 'package:sigalogin/src/widgets/schedule_card.dart';

class ScheduleTab extends StatefulWidget {
  final Function onPressed;
  const ScheduleTab({super.key, required this.onPressed});

  @override
  State<ScheduleTab> createState() => _ScheduleTabState();
}

class _ScheduleTabState extends State<ScheduleTab> {
  late Student student;
  late SettingRepository setting;

  @override
  Widget build(BuildContext context) {
    student = Provider.of<StudentRepository>(context).student;
    setting = Provider.of<SettingRepository>(context);
    return RefreshIndicator(
      backgroundColor: MainTheme.white,
      color: MainTheme.orange,
      onRefresh: ()async{await widget.onPressed();},
      child: ListView.builder(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        itemCount: student.schedule.length+1,
        itemBuilder: (context, index){
          if(index==0)return Row(mainAxisAlignment: MainAxisAlignment.center,children: [Flexible(child: Text('Última Atualização: ${setting.lastInfoUpdate}'))]);
          return ScheduleCard(schedule: student.schedule[index-1]);
        },
      ),
    );
  }
}