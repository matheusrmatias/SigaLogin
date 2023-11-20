import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sigalogin/src/models/schedule.dart';
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
  late List<Schedule> schedule;
  late SettingRepository setting;

  @override
  Widget build(BuildContext context) {
    schedule = Provider.of<StudentRepository>(context).schedule;
    setting = Provider.of<SettingRepository>(context);
    return Scaffold(
      body: RefreshIndicator(
        backgroundColor: MainTheme.white,
        color: MainTheme.orange,
        onRefresh: ()async{await widget.onPressed();},
        child: schedule.isNotEmpty?ListView.builder(
          itemCount: schedule.length+1,
          itemBuilder: (context, index){
            if(index==0)return Row(mainAxisAlignment: MainAxisAlignment.center,children: [Flexible(child: Text(setting.lastInfoUpdate))]);
            return ScheduleCard(schedule: schedule[index-1]);
          },
        ):ListView(
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.center,children: [Flexible(child: Text(setting.lastInfoUpdate))]),
            const SizedBox(height: 16),
            const Row(mainAxisAlignment: MainAxisAlignment.center,children: [Flexible(child: Text('Ocorreu um erro, atualize os dados para corrigir.'))]),
          ],
        ),
      ),
    );
  }
}