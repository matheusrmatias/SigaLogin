import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:sigalogin/src/pages/settings/settings_page.dart';
import 'package:sigalogin/src/pages/tabs/historic_tab.dart';
import 'package:sigalogin/src/pages/tabs/notes_tab.dart';
import 'package:sigalogin/src/pages/tabs/schedule_tab.dart';
import 'package:sigalogin/src/repositories/settings_repository.dart';
import 'package:sigalogin/src/themes/main_theme.dart';
import 'package:sigalogin/src/controllers/student_controller.dart';
import 'package:sigalogin/src/models/student.dart';
import 'package:sigalogin/src/repositories/student_repository.dart';
import 'package:sigalogin/src/services/student_account.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int page = 1;
  late PageController pc;
  StudentController control = StudentController();
  late StudentRepository studentRep;
  late Student student;
  late SettingRepository prefs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pc = PageController(initialPage: page);
  }

  @override
  Widget build(BuildContext context) {
    studentRep = Provider.of<StudentRepository>(context);
    student = Provider.of<StudentRepository>(context).student;
    prefs = Provider.of<SettingRepository>(context);
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        toolbarHeight: 100,
        title: _header(),
        actions: [Container(margin: const EdgeInsets.only(right: 32),child: IconButton(onPressed: ()=>Navigator.push(context, PageTransition(child: const SettingPage(), type: PageTransitionType.rightToLeft, curve: Curves.linear, duration: const Duration(milliseconds: 300))), icon: Icon(Icons.settings, color: Theme.of(context).colorScheme.onPrimary)))],
        shadowColor: Colors.transparent,
      ),
      body: ContainedTabBarView(
          tabBarProperties: TabBarProperties(
              padding: const EdgeInsets.only(bottom: 4),
              indicatorColor: MainTheme.orange,
              labelColor: MainTheme.orange,
              unselectedLabelColor: Theme.of(context).colorScheme.onPrimary,
          ),
          tabBarViewProperties: const TabBarViewProperties(
              physics: BouncingScrollPhysics()
          ),
          tabs: const [
            Tab(child: Text('Notas', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis)),
            Tab(child: Text('Histórico', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis)),
            Tab(child: Text('Horários', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis))
          ],
          views: [
            NotesTab(onPressed: _updateStudentDate),
            HistoricTab(onPressed: _updateStudentDate),
            ScheduleTab(onPressed: _updateStudentDate)
          ]
      ),
    );
  }
  _header(){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      height: 100,
      child: Row(
        children: [
          prefs.imageDisplay?GestureDetector(child: CircleAvatar(backgroundImage: MemoryImage(student.image),backgroundColor: MainTheme.orange,radius: 30),onTap: ()=>showDialog(context: context, builder: (BuildContext context)=>GestureDetector(child: Image.memory(student.image),onTap: ()=>Navigator.pop(context),))):CircleAvatar(radius: 30,backgroundColor: MainTheme.orange, child: Icon(Icons.person, color: Theme.of(context).colorScheme.primary)),
          const SizedBox(width: 16),
          Expanded(child: Text(student.name, maxLines: 3,style: TextStyle(color: Theme.of(context).colorScheme.onPrimary,fontSize: 14))),
        ],
      ),
    );
  }

  Future<void> _updateStudentDate()async{
    StudentAccount account = StudentAccount();

    try{
      await account.userLogin(student);
      await account.userHistoric(student);
      await account.userAssessment(student);
      await account.userSchedule(student);
      await account.userAbsences(student);
      await account.userAssessmentDetails(student);
      await control.updateDatabase(student);
      studentRep.student = student;
      setState(() {
        student = student;
      });
      prefs.lastInfoUpdate = DateFormat('dd/MM HH:mm').format(DateTime.now());
      Fluttertoast.showToast(msg: 'Dados atualizados com sucesso!');
    }catch(e){
      print('Error $e');
      if(e.toString() == 'Exception: User or Password Incorrect'){
        Fluttertoast.showToast(msg: 'Faça o Login Novamente');
        control.deleteDatabase();
        Navigator.pushReplacement(context, PageTransition(child:const LoginPage(), type: PageTransitionType.fade));
      }else{
        Fluttertoast.showToast(msg: 'Ocorreu um erro, tente novamente!');
      }
    }
  }

}