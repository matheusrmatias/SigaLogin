import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sigalogin/src/pages/splash_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sigalogin/src/controllers/student_controller.dart';
import 'package:sigalogin/src/models/student.dart';
import 'package:sigalogin/src/my_app.dart';
import 'package:sigalogin/src/pages/home_page.dart';
import 'package:sigalogin/src/pages/login_page.dart';
import 'package:sigalogin/src/repositories/student_repository.dart';
import 'package:sigalogin/src/repositories/settings_repository.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp
  ]);
  runApp(const MyApp(page: SplashPage()));

  SharedPreferences prefs = await SharedPreferences.getInstance();

  Student student = Student(cpf: '', password: '');
  StudentController control = StudentController();
  await control.queryStudent(student);

  if(student.cpf == ''){
    runApp(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<SettingRepository>(create: (context)=>SettingRepository(prefs: prefs)),
            ChangeNotifierProvider<StudentRepository>(create: (context)=>StudentRepository(student))
          ],
          child: const MyApp(page: LoginPage()),
        )
    );
  }else{
    runApp(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<SettingRepository>(create: (context)=>SettingRepository(prefs: prefs)),
            ChangeNotifierProvider<StudentRepository>(create: (context)=>StudentRepository(student))
          ],
          child: const MyApp(page: HomePage()),
        )
    );
  }

}