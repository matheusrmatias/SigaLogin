import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sigalogin/src/themes/main_theme.dart';

import '../models/assessment.dart';
import 'circle_info.dart';

class DisciplineNoteCard extends StatefulWidget {
  final DisciplineAssessment discipline;
  DisciplineNoteCard({Key? key, required this.discipline}) : super(key: key);

  @override
  State<DisciplineNoteCard> createState() => _DisciplineNoteCard();

}

class _DisciplineNoteCard extends State<DisciplineNoteCard>{
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 4),child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        onTap:(){
          setState(()=>isExpanded=!isExpanded);
        },
        child: Ink(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: Theme.of(context).brightness==Brightness.dark?MainTheme.black:MainTheme.lightGrey,
              borderRadius: const BorderRadius.all(Radius.circular(16))
          ),
          child: Column(
            children: [
              Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: Text(widget.discipline.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold))),
                  ]),
              isExpanded?Column(
                children: [
                  Divider(color: MainTheme.orange),
                  Row(children: [Flexible(child: Text('Ementa', style: TextStyle(fontSize: 14,color: MainTheme.orange,fontWeight: FontWeight.bold)))]),
                  Row(children: [Flexible(child: Text(widget.discipline.syllabus.isEmpty? "Nenhuma ementa encontrada.":widget.discipline.syllabus, style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onPrimary), textAlign: TextAlign.justify,))]),
                  const SizedBox(height: 8),
                  Row(children: [Flexible(child: Text('Objetivo', style: TextStyle(fontSize: 14,color: MainTheme.orange,fontWeight: FontWeight.bold)))]),
                  Row(children: [Flexible(child: Text(widget.discipline.objective.isEmpty? "Nenhum objetivo encontrado.":widget.discipline.objective, style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onPrimary), textAlign: TextAlign.justify,))]),
                  const SizedBox(height: 8),
                  Divider(color: MainTheme.orange),
                  Row(children: [Expanded(child: Text('Total de Aulas: ', style: TextStyle(fontSize: 14, color: MainTheme.orange,fontWeight: FontWeight.bold))),Expanded(child: Text(widget.discipline.totalClasses, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Arial'),textAlign: TextAlign.end,))]),
                  const SizedBox(height: 8),
                  Row(children: [Expanded(child: Text('Máximo de Faltas: ', style: TextStyle(fontSize: 14, color: MainTheme.orange,fontWeight: FontWeight.bold))),Expanded(child: Text(widget.discipline.maxAbsences, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Arial'),textAlign: TextAlign.end,))]),
                  const SizedBox(height: 8),
                  Row(children: [Expanded(child: Text('Faltas Restantes: ', style: TextStyle(fontSize: 14, color: MainTheme.orange,fontWeight: FontWeight.bold))),Expanded(child: Text((int.parse(widget.discipline.maxAbsences)-int.parse(widget.discipline.absence).toInt()).toString(), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Arial'),textAlign: TextAlign.end,))]),
                  Divider(color: MainTheme.orange)
                ],
              ):const SizedBox(),
              Container(margin: const EdgeInsets.symmetric(vertical: 16),child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Builder(builder: (BuildContext context) {
                      List<Widget> assessment = [];
                      for (var element in widget.discipline.assessment.keys) {
                        assessment.add(CircleInfo(MainTheme.lightBlue, text: widget.discipline.assessment[element]=='0,0'?'0':widget.discipline.assessment[element]!.replaceAll(" ", '').length==4?widget.discipline.assessment[element]!.toString().substring(0,widget.discipline.assessment[element]!.length-2):widget.discipline.assessment[element]!,title: element));
                      }
                      return Row(
                        children: assessment,
                      );
                    },),
                  )
                  ),
                  CircleInfo(MainTheme.lightOrange,text:widget.discipline.absence,title:'Faltas'),
                  CircleInfo(MainTheme.orange, text:widget.discipline.average=='0,0'?'0':widget.discipline.average.replaceAll(" ", '').length==4?widget.discipline.average.toString().substring(0,widget.discipline.average.length-2):widget.discipline.average, title: 'Nota'),
                ],
              ),),
              Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(child: Text(widget.discipline.teacher, style: TextStyle(fontSize: 10))),
                  ]),
            ],
          )
        )
    ));
  }
}