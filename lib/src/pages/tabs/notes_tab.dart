import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sigalogin/src/themes/main_theme.dart';

import '../../models/student.dart';
import '../../repositories/student_repository.dart';
import '../../widgets/discipline_note_card.dart';

class NotesTab extends StatefulWidget {
  final onPressed;
  const NotesTab({Key? key, this.onPressed}) : super(key: key);

  @override
  State<NotesTab> createState() => _NotesTabState();
}

class _NotesTabState extends State<NotesTab> {
  late Student student;

  @override
  Widget build(BuildContext context) {
    student = Provider.of<StudentRepository>(context).student;
    return Container(
      child: RefreshIndicator(
        backgroundColor: MainTheme.white,
        color: MainTheme.orange,
        onRefresh: ()async{await widget.onPressed(student);},
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: student.assessment.length,
          itemBuilder: (context, index)=>DisciplineNoteCard(discipline: student.assessment[index]),
        ),
      ),
    );;
  }
}