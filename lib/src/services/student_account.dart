import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:sigalogin/src/models/assessment.dart';
import 'package:sigalogin/src/models/historic.dart';
import 'package:sigalogin/src/models/schedule.dart';
import 'package:sigalogin/src/models/student.dart';
import 'package:webview_flutter/webview_flutter.dart';

class StudentAccount{
  WebViewController view = WebViewController();
  WebViewCookieManager cookie = WebViewCookieManager();
  bool _isLoad = false;
  int? countDown;

  StudentAccount({this.countDown}){
    print('Contructor');
    _initialize();
  }

  Future<void> _initialize() async{
    print('initialize');
    await view.setJavaScriptMode(JavaScriptMode.unrestricted);
    await view.loadRequest(Uri.parse('https://siga.cps.sp.gov.br/aluno/login.aspx'));
    await view.setNavigationDelegate(NavigationDelegate(
      onWebResourceError: (e)=>throw Exception('WEB failed'),
      onPageFinished: (e){
        _isLoad = true;
      },
    ));
  }

  Future<Student> userLogin(Student student)async{
    int i=0;
    for(i; i<(countDown??10); i++){
      await Future.delayed(const Duration(milliseconds: 1000),()async{
        if(await view.currentUrl() == 'https://siga.cps.sp.gov.br/aluno/home.aspx' && _isLoad){
          print('home loaded');
          await view.runJavaScriptReturningResult("document.getElementById('span_vUNI_UNIDADENOME_MPAGE').textContent").then((value) => student.fatec=value.toString().replaceAll('"', ''));
          await view.runJavaScriptReturningResult("document.getElementById('span_vACD_CURSONOME_MPAGE').textContent").then((value) => student.graduation=value.toString().replaceAll('"', ''));
          await view.runJavaScriptReturningResult("document.getElementById('span_vSITUACAO_MPAGE').textContent").then((value) => student.progress=value.toString().replaceAll('"', ''));
          await view.runJavaScriptReturningResult("document.getElementById('span_vACD_PERIODODESCRICAO_MPAGE').textContent").then((value) => student.period=value.toString().replaceAll('"', ''));
          await view.runJavaScriptReturningResult("document.getElementById('span_MPW0041vPRO_PESSOALNOME').textContent").then((value) => student.name=value.toString().replaceAll('"', '').replaceAll('-', '').trim());
          await view.runJavaScriptReturningResult("document.getElementById('span_MPW0041vACD_ALUNOCURSOREGISTROACADEMICOCURSO').textContent").then((value) => student.ra=value.toString().replaceAll('"', ''));
          await view.runJavaScriptReturningResult("document.getElementById('span_MPW0041vACD_ALUNOCURSOCICLOATUAL').textContent").then((value) => student.cycle=value.toString().replaceAll('"', ''));
          await view.runJavaScriptReturningResult("document.getElementById('span_MPW0041vACD_ALUNOCURSOINDICEPP').textContent").then((value) => student.pp=value.toString().replaceAll('"', '').trim());
          await view.runJavaScriptReturningResult("document.getElementById('span_MPW0041vACD_ALUNOCURSOINDICEPR').textContent").then((value) => student.pr=value.toString().replaceAll('"', '').trim());
          await view.runJavaScriptReturningResult("document.getElementById('span_MPW0041vINSTITUCIONALFATEC').textContent").then((value) => student.email=value.toString().replaceAll('"', ''));
          await view.runJavaScriptReturningResult("document.getElementById('MPW0041FOTO').firstChild.src").then((value)async => student.image=(await get(Uri.parse(value.toString().replaceAll('"', '')))).bodyBytes);
          _isLoad = false;
          i=countDown==null? 11:countDown!+1;
          debugPrint('user basic data coleted');
        }else if(_isLoad && await view.currentUrl() == 'https://siga.cps.sp.gov.br/aluno/login.aspx'){
          print('login loaded');
          _isLoad = false;
          await view.runJavaScript("document.getElementById('vSIS_USUARIOID').value='${student.cpf}'");
          await view.runJavaScript("document.getElementById('vSIS_USUARIOSENHA').value='${student.password}'");
          await view.runJavaScript("document.getElementsByName('BTCONFIRMA')[0].click()");
        }

      });
    }
    if(i==(countDown??10)){
      String error = '';
      if(Platform.isAndroid) {
        await view.runJavaScriptReturningResult(
            "document.getElementById('span_vSAIDA').textContent").then((value) {
          error = value.toString();
        });
      }
      if(error=='"Não confere Login e Senha"'){
        throw Exception('User or Password Incorrect');
      }else{
        throw Exception('User not loaded');
      }
    }
    return student;
  }

  Future<List<Historic>> userHistoric() async{
    int k = 0;
    List<Historic> historic = [];
    if(await view.currentUrl() == 'https://siga.cps.sp.gov.br/aluno/home.aspx'){
      await view.loadRequest(Uri.parse('https://siga.cps.sp.gov.br/aluno/historicocompleto.aspx'));
      for(k;k<(countDown??10);k++){
        await Future.delayed(const Duration(milliseconds: 1000),()async{
          if(_isLoad){
            print('historic loaded');
            await view.runJavaScriptReturningResult("document.getElementById('Grid1ContainerTbl').getElementsByTagName('tbody')[0].getElementsByTagName('tr').length").then((value)async{
              for(int i=1; i<int.parse(value.toString()); i++){
                await view.runJavaScriptReturningResult("document.getElementById('Grid1ContainerTbl').getElementsByTagName('tbody')[0].getElementsByTagName('tr')[$i].getElementsByTagName('span').length").then((value)async{
                  Historic discipline = Historic.empty();
                  for(int j=0; j<(double.parse(value.toString())).toInt();j++){
                    await view.runJavaScriptReturningResult("document.getElementById('Grid1ContainerTbl').getElementsByTagName('tbody')[0].getElementsByTagName('tr')[$i].getElementsByTagName('span')[$j].textContent").then((value){
                      if(j==0){
                        discipline.acronym = value.toString().replaceAll('"', '').trim();
                      }else if(j==1){
                        discipline.name =value.toString().replaceAll('"', '').trim();
                      }else if(j==2){
                        discipline.period = value.toString().replaceAll('"', '').trim();
                      }else if(j==3){
                        discipline.avarage = double.tryParse(value.toString().replaceAll('"', '').trim())??0;
                      }else if(j==4){
                        discipline.frequency = double.tryParse(value.toString().replaceAll('"', '').replaceAll('%', '').trim())??0;
                      }else if(j==5){
                        discipline.absence = int.parse(value.toString().replaceAll('"', '').trim());
                      }else if(j==6){
                        discipline.observation = value.toString().replaceAll('"', '');
                      }
                    });
                  }
                  historic.add(discipline);
                });
              }

            });
            k=countDown==null? 11:countDown!+1;
            _isLoad = false;
            historic.sort((a, b) {
              int periodComparison = a.period.compareTo(b.period);
              if (periodComparison != 0) {
                return periodComparison;
              } else {
                return a.name.compareTo(b.name);
              }
            });
          }
        });
      }
      if(k==(countDown??10)){
        throw Exception('Historic User Data not loaded');
      }
      return historic;
    }else{
      throw Exception('User not loaded');
    }
  }

  Future<List<DisciplineAssessment>> userAssessment() async{
    int i = 0;
    List<DisciplineAssessment> assessments = [];
    if(await view.currentUrl() == 'https://siga.cps.sp.gov.br/aluno/home.aspx' || await view.currentUrl() == 'https://siga.cps.sp.gov.br/aluno/historicocompleto.aspx'){
      await view.loadRequest(Uri.parse('https://siga.cps.sp.gov.br/aluno/notasparciais.aspx'));
      for(i; i<(countDown??10); i++){
        await Future.delayed(const Duration(milliseconds: 1000),()async{
          if(_isLoad){
            print('assessments loaded');
            await view.runJavaScriptReturningResult("document.getElementById('Grid4ContainerTbl').firstChild.children.length/3").then((value)async{
              for(int j=0; j<(double.parse(value.toString())).toInt(); j++){
                DisciplineAssessment discipline = DisciplineAssessment();
                String prefix = '00';
                if(j>=9){
                  prefix+=(j+1).toString();
                }else{
                  prefix+='0${j+1}';
                }
                await view.runJavaScriptReturningResult("document.getElementById('TABLE2_$prefix').firstChild.children[0].children[0].firstChild.textContent").then((value) => discipline.acronym = value.toString().replaceAll('"', ''));
                await view.runJavaScriptReturningResult("document.getElementById('TABLE2_$prefix').firstChild.children[0].children[1].textContent").then((value) => discipline.name = value.toString().replaceAll('"', ''));

                await view.runJavaScriptReturningResult("document.getElementById('TABLE2_$prefix').firstChild.children[1].children[1].textContent").then((value) => discipline.average = value.toString().replaceAll('"', '').trim());
                // await view.runJavaScriptReturningResult("document.getElementById('TABLE2_$prefix').firstChild.children[2].children[1].textContent").then((value) => discipline.absence = value.toString().replaceAll('"', ''));
                await view.runJavaScriptReturningResult("document.getElementById('TABLE2_$prefix').firstChild.children[3].children[1].textContent").then((value) => discipline.frequency = value.toString().replaceAll('"', ''));

                await view.runJavaScriptReturningResult("document.getElementById('Grid1Container_${prefix}Tbl').firstChild.children.length").then((grid)async{
                  if(double.parse(grid.toString())>1){
                    for(int k=1; k<int.parse(grid.toString()); k++){
                      await view.runJavaScriptReturningResult("document.getElementById('Grid1Container_${prefix}Tbl').firstChild.children[$k].children[0].textContent").then((key)async{
                        await view.runJavaScriptReturningResult("document.getElementById('Grid1Container_${prefix}Tbl').firstChild.children[$k].children[2].textContent").then((val){discipline.assessment[key.toString().replaceAll('"', '')]=val.toString().replaceAll('"', '').trim();});
                      });
                    }
                  }
                });
                assessments.add(discipline);
              }
            });
            i=countDown==null? 11:countDown!+1;
            _isLoad=false;
            assessments.sort((a, b){
              if(a.name!.contains('Estágio') || a.name!.contains('Trabalho de Graduação')){
                return 1;
              }else if(b.name!.contains('Estágio') || b.name!.contains('Trabalho de Graduação')){
                return -1;
              }else{
                return a.name!.compareTo(b.name!);
              }
            });
          }
        });
      }
      if(i==(countDown??10)){
        throw Exception('Assessment User Data not loaded');
      }
      return assessments;
    }else{
      throw Exception('User not loaded');
    }
  }


  Future<List<Schedule>> userSchedule()async{
    int i = 0;
    List<Schedule> schedule = [];
    if(await view.currentUrl() == 'https://siga.cps.sp.gov.br/aluno/home.aspx' || await view.currentUrl() == 'https://siga.cps.sp.gov.br/aluno/notasparciais.aspx'){
      List<Schedule> schedule = [];
      await view.loadRequest(Uri.parse('https://siga.cps.sp.gov.br/aluno/horario.aspx'));
      for(i; i<(countDown??10); i++){
        await Future.delayed(const Duration(milliseconds: 1000),()async{
          if(_isLoad) {
            print('schedule loaded');
            Map<String, String> acronyms = {};
            await view.runJavaScriptReturningResult(
                "document.getElementById('Grid1ContainerTbl').firstChild.children.length")
                .then((value) async {
              for (int j = 1; j < (double.parse(value.toString())).toInt(); j++) {
                await view.runJavaScriptReturningResult("document.getElementById('Grid1ContainerTbl').firstChild.children[$j].children[0].textContent").then((disciplineAcronym)async{
                  await view.runJavaScriptReturningResult("document.getElementById('Grid1ContainerTbl').firstChild.children[$j].children[1].textContent").then((disciplineName)async{
                    acronyms[disciplineAcronym.toString()]=disciplineName.toString().replaceAll('"', '').substring(0,disciplineName.toString().indexOf('-')-1);
                  });
                });
              }
            });
            for(int j = 2; j<7; j++){
              Schedule scheduleTemp = Schedule();
              await view.runJavaScriptReturningResult("document.getElementById('TEXTBLOCK${j+3}').textContent").then((value){
                scheduleTemp.weekDay = value.toString().replaceAll('"', '');
              });
              await view.runJavaScriptReturningResult("document.getElementById('Grid${j}ContainerTbl').firstChild.children.length").then((value)async{
                for (int k = 1; k < (double.parse(value.toString())).toInt(); k++) {
                  await view.runJavaScriptReturningResult("document.getElementById('Grid${j}ContainerTbl').firstChild.children[$k].children[1].textContent").then((time)async{
                    await view.runJavaScriptReturningResult("document.getElementById('Grid${j}ContainerTbl').firstChild.children[$k].children[2].textContent").then((discipline){
                      scheduleTemp.schedule.add([time.toString().replaceAll('"', ''),acronyms[discipline].toString()]);
                    });
                  });
                }
              });
              scheduleTemp.schedule.sort((a,b)=>a[0].compareTo(b[0]));
              schedule.add(scheduleTemp);
            }
            i=countDown==null? 11:countDown!+1;
            _isLoad=false;
          }
        });
      }
      if(i == (countDown??10)){
        throw Exception('Schedule User Data not loaded');
      }
      return schedule;
    }else{
      throw Exception('User Not Loaded');
    }
  }

  Future<List<DisciplineAssessment>> userAbsences(List<DisciplineAssessment> assessment)async{
    int i = 0;
    if(await view.currentUrl() == 'https://siga.cps.sp.gov.br/aluno/home.aspx' || await view.currentUrl() == 'https://siga.cps.sp.gov.br/aluno/horario.aspx'){
      await view.loadRequest(Uri.parse('https://siga.cps.sp.gov.br/aluno/faltasparciais.aspx'));
      for(i; i<(countDown??10); i++){
        await Future.delayed(const Duration(milliseconds: 1000),()async{
          if(_isLoad) {
            print('absences loaded');
            for(int j = 0; j< assessment.length; j++){
              String prefix = '00';
              if(j>=9){
                prefix+=(j+1).toString();
              }else{
                prefix+='0${j+1}';
              }
              await view.runJavaScriptReturningResult("document.getElementById('span_vACD_DISCIPLINASIGLA_$prefix').textContent").then((acronym) async {
                for (var element in assessment) {
                  if(element.acronym == acronym.toString().replaceAll('"', '')){
                    await view.runJavaScriptReturningResult("document.getElementById('span_vAUSENCIAS_$prefix').textContent").then((value) async {
                      assessment[assessment.indexWhere((disc) => disc == element)].absence = value.toString().replaceAll('"', '');
                    });
                  }
                }
              });
            }
            i=countDown??10;
            _isLoad=false;
          }
        });
      }
      if(i == (countDown??10)){
        throw Exception('Absences User Data not loaded');
      }
      return assessment;
    }else{
      throw Exception('User Not Loaded');
    }
  }


  Future<List<DisciplineAssessment>> userAssessmentDetails(List<DisciplineAssessment> assessment) async{

    for(int i = 0; i<assessment.length; i++){
      await view.loadRequest(Uri.parse("https://siga.cps.sp.gov.br/aluno/planoensino.aspx?" + assessment[i].acronym, 0, 56));

      int j = 0;
      for(j; j<(countDown??10); j++){
        await Future.delayed(const Duration(milliseconds: 1000), ()async{
          if(_isLoad){
            await view.runJavaScriptReturningResult('document.getElementById("span_W0008W0013vACD_DISCIPLINAAULASTOTAISPERIODO").textContent').then((value){
              assessment[i].maxAbsences = (double.parse(value.toString().replaceAll('"', "").replaceAll(" ", ""))~/4).toString();
              assessment[i].totalClasses = value.toString().replaceAll('"', "").replaceAll(" ", "");
            });
            await view.runJavaScriptReturningResult('document.getElementById("span_W0008W0013vACD_DISCIPLINAEMENTA").textContent').then((value){
              assessment[i].syllabus = value.toString().replaceAll('"', '');
            });
            await view.runJavaScriptReturningResult('document.getElementById("span_W0008W0013vACD_DISCIPLINAOBJETIVO").textContent').then((value){
              assessment[i].objective = value.toString().replaceAll('"', '');
            });
            await view.runJavaScriptReturningResult('document.getElementById("span_W0005vPRO_PESSOALNOME").textContent').then((value){
              assessment[i].teacher = value.toString().replaceAll('"', '');
            });
            _isLoad = false;
            j = countDown??10;
          }
        });
      }

      if(j==(countDown??10)){
        throw Exception("User not loaded - Syllabus ");
      }
    }
    return assessment;
  }
}