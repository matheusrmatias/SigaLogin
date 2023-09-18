import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sigalogin/src/themes/main_theme.dart';

import '../models/assessment.dart';
import 'circle_info.dart';

class DisciplineNoteCard extends StatelessWidget {
  final DisciplineAssessment discipline;
  DisciplineNoteCard({Key? key, required this.discipline}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
        onTap:(){
          showDialog(context: context, builder: (ctx) => AlertDialog(
            title: Text(discipline.name.toUpperCase(), style: const TextStyle(fontSize: 16), textAlign: TextAlign.center,),
            backgroundColor: Theme.of(context).colorScheme.primary,
            titleTextStyle: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
            contentTextStyle: TextStyle(color: MainTheme.orange),
            content: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  const Row(children: [Flexible(child: Text('Ementa', style: TextStyle(fontSize: 14)))]),
                  Row(children: [Flexible(child: Text(discipline.syllabus, style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onPrimary), textAlign: TextAlign.justify,))]),
                  const SizedBox(height: 8),
                  const Row(children: [Flexible(child: Text('Objetivo', style: TextStyle(fontSize: 14)))]),
                  Row(children: [Flexible(child: Text(discipline.objective, style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onPrimary), textAlign: TextAlign.justify,))]),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(child: CircleInfo(MainTheme.orange, title: discipline.name.contains('Estágio')?'Carga Horária':'Total de Aulas', text: discipline.totalClasses,textColor: Theme.of(context).colorScheme.onPrimary)),
                    ],
                  ),
                  const SizedBox(height: 8),

                  discipline.name.contains('Estágio')||discipline.name.contains('Trabalho de Graduação')?SizedBox():SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleInfo(MainTheme.lightOrange, title: 'Máximo de Faltas', text: discipline.maxAbsences, textColor: Theme.of(context).colorScheme.onPrimary),
                        const SizedBox(width: 4),
                        CircleInfo(MainTheme.lightBlue, title: 'Faltas Restantes', text: (int.parse(discipline.maxAbsences)-int.parse(discipline.absence).toInt()).toString(),textColor: Theme.of(context).colorScheme.onPrimary)
                      ],
                    ),
                  )



                  // Row(children: [Flexible(child: Text('Total de Aulas: ', style: TextStyle(fontSize: 14))), Flexible(child: Text(discipline.totalClasses, style: TextStyle(fontSize: 12, color: MainColors.white), textAlign: TextAlign.justify,))]),
                  // const SizedBox(height: 8),
                  // Row(children: [Flexible(child: Text('Máximo de Faltas: ', style: TextStyle(fontSize: 14))), Flexible(child: Text(discipline.maxAbsences, style: TextStyle(fontSize: 12, color: MainColors.white), textAlign: TextAlign.justify,))]),
                  // const SizedBox(height: 8),
                  // Row(children: [Flexible(child: Text('Faltas restantes: ', style: TextStyle(fontSize: 14))), Flexible(child: Text((int.parse(discipline.maxAbsences)-int.parse(discipline.absence).toInt()).toString(), style: TextStyle(fontSize: 12, color: MainColors.white), textAlign: TextAlign.justify,))]),
                ],
              ),
            ),
          ));
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 4),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: MainTheme.tertiary,
              borderRadius: const BorderRadius.all(Radius.circular(8))
          ),
          child: Column(
            children: [
              Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: Text(discipline.name, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: MainTheme.black))),
                  ]),
              Container(margin: const EdgeInsets.symmetric(vertical: 16),child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Builder(builder: (BuildContext context) {
                      List<Widget> assessment = [];
                      for (var element in discipline.assessment.keys) {
                        assessment.add(CircleInfo(MainTheme.lightBlue, text: discipline.assessment[element].toString(),title: element, textColor: MainTheme.black));
                      }
                      return Row(
                        children: assessment,
                      );
                    },),
                  )
                  ),
                  discipline.name.contains('Estágio')||discipline.name.contains('Trabalho de Graduação')?SizedBox():CircleInfo(MainTheme.lightOrange,text:discipline.absence,title:'Faltas', textColor: MainTheme.black,),
                  CircleInfo(MainTheme.orange, text:discipline.average, title: 'Nota', textColor: MainTheme.black),
                ],
              ),),
              Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(child: Text(discipline.teacher, style: TextStyle(fontSize: 10, color: MainTheme.black))),
                  ]),
            ],
          ),
        )
    );
  }

}