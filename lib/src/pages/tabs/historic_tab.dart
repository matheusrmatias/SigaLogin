import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sigalogin/src/repositories/settings_repository.dart';
import 'package:sigalogin/src/repositories/student_repository.dart';
import 'package:sigalogin/src/themes/main_theme.dart';
import 'package:sigalogin/src/widgets/discipline_historic_card.dart';
import 'package:sigalogin/src/widgets/sliver_appbar_search.dart';

class HistoricTab extends StatefulWidget {
  final Function onPressed;
  const HistoricTab({Key? key, required this.onPressed}) : super(key: key);

  @override
  State<HistoricTab> createState() => _HistoricTabState();
}

class _HistoricTabState extends State<HistoricTab> {
  late StudentRepository student;
  late SettingRepository setting;

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    student.cleanSearch(listen: false);
  }

  @override
  Widget build(BuildContext context) {
    student = Provider.of<StudentRepository>(context);
    setting = Provider.of<SettingRepository>(context);
    return RefreshIndicator(
      backgroundColor: MainTheme.white,
      color: MainTheme.orange,
      onRefresh: ()async{await widget.onPressed();},
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        slivers: [
          SliverList.list(children: [Row(mainAxisAlignment: MainAxisAlignment.center,children: [Flexible(child: Text(setting.lastInfoUpdate))])]),
          SliverAppBarSearch(onChanged: _searchHistoric),
          SliverList.builder(
              itemCount: student.historic.length,
              itemBuilder: (context, index)=>DisciplineHistoricCard(discipline: student.historic[index])
          ),
        ],
      )
    );
  }
  Future<void> _searchHistoric(String query)async{
    final suggetions = student.allHistoric.where((element){
      final name = element.name.toLowerCase();
      final acronym = element.acronym.toLowerCase();
      final period = element.period.toLowerCase();
      final observation = element.observation.toLowerCase();
      final input = query.toLowerCase();
      return name.contains(input) || acronym.contains(input) || period.contains(input) || observation.contains(input);
    }).toList();
    suggetions.sort((a, b) {
      int periodComparison = a.period.compareTo(b.period);
      if (periodComparison != 0) {
        return periodComparison;
      } else {
        return a.name.compareTo(b.name);
      }
    });
    student.historic = suggetions;
  }
}