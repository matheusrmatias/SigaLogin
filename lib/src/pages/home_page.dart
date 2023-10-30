import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:sigalogin/src/models/assessment.dart';
import 'package:sigalogin/src/models/historic.dart';
import 'package:sigalogin/src/models/schedule.dart';
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
  bool afterLogin;
  HomePage({Key? key, this.afterLogin=false}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int page = 1;
  late PageController pc;
  StudentController control = StudentController();
  late Student student;
  late SettingRepository prefs;
  bool inUpdateStudentData = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(!widget.afterLogin)_updateStudentDate(init: true);
    pc = PageController(initialPage: page);
  }

  @override
  Widget build(BuildContext context) {
    student = Provider.of<StudentRepository>(context).student;
    prefs = Provider.of<SettingRepository>(context);
    return DefaultTabController(length: 3,child:Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        toolbarHeight: 100,
        title: _header(),
        bottom: TabBar(
            labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
            unselectedLabelColor: Theme.of(context).colorScheme.onPrimary,
            labelColor: MainTheme.orange,
            unselectedLabelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
            labelPadding: const EdgeInsets.symmetric(vertical: 16),
            indicatorColor: MainTheme.orange,
            indicatorPadding: const EdgeInsets.only(bottom: 4),
            tabs: const [
              Text('Notas', overflow: TextOverflow.ellipsis),
              Text('Histórico',overflow: TextOverflow.ellipsis),
              Text('Horários',overflow: TextOverflow.ellipsis)
        ]),
        actions: [Container(margin: const EdgeInsets.only(right: 32),child: IconButton(onPressed: ()=>Navigator.push(context, PageTransition(child: const SettingPage(), type: PageTransitionType.rightToLeft, curve: Curves.linear, duration: const Duration(milliseconds: 300))), icon: Icon(Icons.settings, color: Theme.of(context).colorScheme.onPrimary)))],
        shadowColor: Colors.transparent,
      ),
      body: TabBarView(
        physics: const BouncingScrollPhysics(),
        children: [
          NotesTab(onPressed: _updateStudentDate),
          HistoricTab(onPressed: _updateStudentDate),
          ScheduleTab(onPressed: _updateStudentDate)
        ],
      ),
    ));
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

  Future<void> _updateStudentDate({bool init = false})async{
    final studentRep = context.read<StudentRepository>();
    final stud = context.read<StudentRepository>().student;

    List<Historic> historic = [];
    List<Schedule> schedule = [];
    List<DisciplineAssessment> assessment = [];
    Student student = Student(cpf: stud.cpf, password: stud.password);

    String? lasInfoUpdate;
    if(inUpdateStudentData){
      Fluttertoast.showToast(msg: 'Os dados estão sendo atualizados, aguarde.');
      return;
    }
    if(!init)lasInfoUpdate = prefs.lastInfoUpdate;
    inUpdateStudentData = true;
    StudentAccount account = StudentAccount();
    try{
      if(!init)prefs.lastInfoUpdate = 'Atualizando Dados';
      student = await account.userLogin(student);
      prefs.lastInfoUpdate = 'Atualizando Dados';
      historic = await account.userHistoric();
      assessment = await account.userAssessment();
      schedule = await account.userSchedule();
      assessment = await account.userAbsences(assessment);
      assessment = await account.userAssessmentDetails(assessment);
      await control.updateStudent(student);
      await control.updateAssessment(assessment);
      await control.updateHistoric(historic);
      await control.updateSchedule(schedule);

      studentRep.student = student;
      studentRep.historic = historic;
      studentRep.allHistoric = historic;

      studentRep.assessment = assessment;
      studentRep.allAssessment = assessment;

      studentRep.schedule = schedule;

      setState(() {
        this.student = student;
      });
      prefs.lastInfoUpdate = 'Última Atualização: ${DateFormat('dd/MM HH:mm').format(DateTime.now())}';
      Fluttertoast.showToast(msg: 'Dados atualizados com sucesso!');
    }catch(e){
      print('Error $e');
      if(lasInfoUpdate!=null)prefs.lastInfoUpdate=lasInfoUpdate;
      if(e.toString() == 'Exception: User or Password Incorrect'){
        Fluttertoast.showToast(msg: 'Faça o Login Novamente');
        control.deleteDatabase();
        Navigator.pushReplacement(context, PageTransition(child:const LoginPage(), type: PageTransitionType.fade));
      }else{
        if(!init)Fluttertoast.showToast(msg: 'Não foi possível atualizar os dados, tente novamente!');
      }
    }finally{
      setState(()=>inUpdateStudentData = false);
    }
  }

}

