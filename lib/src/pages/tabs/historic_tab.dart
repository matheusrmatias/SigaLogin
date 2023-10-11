import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:sigalogin/src/models/student.dart';
import 'package:sigalogin/src/repositories/student_repository.dart';
import 'package:sigalogin/src/themes/main_theme.dart';
import 'package:sigalogin/src/widgets/discipline_historic_card.dart';

class HistoricTab extends StatefulWidget {
  final Function(Student) onPressed;
  const HistoricTab({Key? key, required this.onPressed}) : super(key: key);

  @override
  State<HistoricTab> createState() => _HistoricTabState();
}

class _HistoricTabState extends State<HistoricTab> {
  late Student student;

  @override
  Widget build(BuildContext context) {
    student = Provider.of<StudentRepository>(context).student;
    return RefreshIndicator(
      backgroundColor: MainTheme.white,
      color: MainTheme.orange,
      onRefresh: ()async{await widget.onPressed(student);},
      child: ListView.builder(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        itemCount: student.historic.length,
        itemBuilder: (context, index) => DisciplineHistoricCard(discipline: student.historic[index]),
      ),
    );
  }
}