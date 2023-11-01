import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sigalogin/src/controllers/student_card_controller.dart';
import 'package:sigalogin/src/models/assessment.dart';
import 'package:sigalogin/src/models/historic.dart';
import 'package:sigalogin/src/models/schedule.dart';
import 'package:sigalogin/src/models/student_card.dart';
import 'package:sigalogin/src/pages/auth_page.dart';
import 'package:sigalogin/src/pages/splash_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sigalogin/src/controllers/student_controller.dart';
import 'package:sigalogin/src/models/student.dart';
import 'package:sigalogin/src/my_app.dart';
import 'package:sigalogin/src/pages/home_page.dart';
import 'package:sigalogin/src/pages/login_page.dart';
import 'package:sigalogin/src/repositories/student_card_repository.dart';
import 'package:sigalogin/src/repositories/student_repository.dart';
import 'package:sigalogin/src/repositories/settings_repository.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp
  ]);

  SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(
      ChangeNotifierProvider(create:  (context)=>SettingRepository(prefs: prefs),child: MyApp(page: const SplashPage()),)
  );

  StudentController control = StudentController();
  StudentCardController cardControl = StudentCardController();

  Student student = await control.queryStudent();
  List<Schedule> schedule = await control.querySchedule();
  List<DisciplineAssessment> assessment = await control.queryAssessment();
  List<Historic> historic = await control.queryHistoric();
  StudentCard card = await cardControl.queryDatabase();


  if(student.cpf == ''){
    runApp(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<SettingRepository>(create: (context)=>SettingRepository(prefs: prefs)),
            ChangeNotifierProvider<StudentRepository>(create: (context)=>StudentRepository(student, [], [], [])),
            ChangeNotifierProvider<StudentCardRepository>(create: (context)=>StudentCardRepository(card))
          ],
          child: MyApp(page: const LoginPage()),
        )
    );

  }else{
    if(prefs.getBool('appLock')??false){
      runApp(
          MultiProvider(
            providers: [
              ChangeNotifierProvider<SettingRepository>(create: (context)=>SettingRepository(prefs: prefs)),
              ChangeNotifierProvider<StudentRepository>(create: (context)=>StudentRepository(student,historic,assessment,schedule)),
              ChangeNotifierProvider<StudentCardRepository>(create: (context)=>StudentCardRepository(card))
            ],
            child: MyApp(page: const AuthPage()),
          )
      );
    }else{
      runApp(
          MultiProvider(
            providers: [
              ChangeNotifierProvider<SettingRepository>(create: (context)=>SettingRepository(prefs: prefs)),
              ChangeNotifierProvider<StudentRepository>(create: (context)=>StudentRepository(student,historic,assessment,schedule)),
              ChangeNotifierProvider<StudentCardRepository>(create: (context)=>StudentCardRepository(card))
            ],
            child: MyApp(page: HomePage(afterLogin: !(prefs.getBool('updateOnOpen')??true))),
          )
      );
    }
  }
}
