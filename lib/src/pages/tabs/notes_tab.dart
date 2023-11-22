import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sigalogin/src/repositories/settings_repository.dart';
import 'package:sigalogin/src/themes/main_theme.dart';
import 'package:sigalogin/src/repositories/student_repository.dart';
import 'package:sigalogin/src/widgets/discipline_note_card.dart';
import 'package:sigalogin/src/widgets/sliver_appbar_search.dart';

class NotesTab extends StatefulWidget {
  final Function onPressed;
  const NotesTab({Key? key, required this.onPressed}) : super(key: key);

  @override
  State<NotesTab> createState() => _NotesTabState();
}

class _NotesTabState extends State<NotesTab> {
  late StudentRepository student;
  late SettingRepository setting;
  late ScrollController _scrollController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    student.cleanSearch(listen: false);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    student = Provider.of<StudentRepository>(context);
    setting = Provider.of<SettingRepository>(context);
    return RefreshIndicator(
        backgroundColor: MainTheme.white,
        color: MainTheme.orange,
        onRefresh: () async {
          await widget.onPressed();
        },
        child: RawScrollbar(
          thumbColor: Theme.of(context).brightness == Brightness.dark
              ? MainTheme.lightGrey
              : MainTheme.grey,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8))),
          crossAxisMargin: 12,
          controller: _scrollController,
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverList.list(children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Flexible(child: Text(setting.lastInfoUpdate))])
              ]),
              SliverAppBarSearch(
                  onChanged: _searchAssessment, text: 'Pesquisar Disciplina'),
              SliverList.builder(
                  itemCount: student.assessment.length,
                  itemBuilder: (context, index) => DisciplineNoteCard(
                      discipline: student.assessment[index])),
            ],
          ),
        ));
  }

  Future<void> _searchAssessment(String query) async {
    final suggetions = student.allAssessment.where((element) {
      final discipline = element.name.toLowerCase();
      final teacher = element.teacher.toLowerCase();
      final input = query.toLowerCase();
      return discipline.contains(input) || teacher.contains(input);
    }).toList();
    suggetions.sort((a, b) {
      if (a.name.contains('Estágio') ||
          a.name.contains('Trabalho de Graduação')) {
        return 1;
      } else if (b.name.contains('Estágio') ||
          b.name.contains('Trabalho de Graduação')) {
        return -1;
      } else {
        return a.name.compareTo(b.name);
      }
    });
    student.assessment = suggetions;
  }
}
