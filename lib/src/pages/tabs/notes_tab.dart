import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sigalogin/src/themes/main_theme.dart';

import 'package:sigalogin/src/models/student.dart';
import 'package:sigalogin/src/repositories/student_repository.dart';
import 'package:sigalogin/src/widgets/discipline_note_card.dart';

class NotesTab extends StatefulWidget {
  final Function onPressed;
  const NotesTab({Key? key, required this.onPressed}) : super(key: key);

  @override
  State<NotesTab> createState() => _NotesTabState();
}

class _NotesTabState extends State<NotesTab> {
  late Student student;

  @override
  Widget build(BuildContext context) {
    student = Provider.of<StudentRepository>(context).student;
    return RefreshIndicator(
      backgroundColor: MainTheme.white,
      color: MainTheme.orange,
      onRefresh: ()async{await widget.onPressed();},
      child: ListView.builder(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        itemCount: student.assessment.length,
        itemBuilder: (context, index)=>DisciplineNoteCard(discipline: student.assessment[index]),
      ),
    );;
  }
}