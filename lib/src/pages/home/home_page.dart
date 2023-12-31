import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:sigalogin/src/models/assessment.dart';
import 'package:sigalogin/src/models/historic.dart';
import 'package:sigalogin/src/models/schedule.dart';
import 'package:sigalogin/src/models/update.dart';
import 'package:sigalogin/src/pages/settings/settings_page.dart';
import 'package:sigalogin/src/pages/home/tabs/historic_tab.dart';
import 'package:sigalogin/src/pages/home/tabs/notes_tab.dart';
import 'package:sigalogin/src/pages/home/tabs/schedule_tab.dart';
import 'package:sigalogin/src/pages/settings/update_page.dart';
import 'package:sigalogin/src/repositories/settings_repository.dart';
import 'package:sigalogin/src/repositories/update_repository.dart';
import 'package:sigalogin/src/services/notification_service.dart';
import 'package:sigalogin/src/themes/main_theme.dart';
import 'package:sigalogin/src/controllers/student_controller.dart';
import 'package:sigalogin/src/models/student.dart';
import 'package:sigalogin/src/repositories/student_repository.dart';
import 'package:sigalogin/src/services/student_account.dart';
import '../login_page.dart';

class HomePage extends StatefulWidget{
  bool afterLogin;
  Update? update;
  HomePage({Key? key, this.afterLogin=false, this.update}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  StudentController control = StudentController();
  late Student student;
  late SettingRepository prefs;
  late Update update;
  bool inUpdateStudentData = false;
  late TabController _tabController;
  int page=0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if(widget.update?.available??false)Fluttertoast.showToast(msg: 'Há uma nova atualização disponível !');

    _tabController = TabController(length: 3, initialIndex: 0,vsync: this,animationDuration: const Duration(milliseconds: 500))..addListener(() {
      setState(() {
        page=_tabController.index;
      });
    });
    if (!widget.afterLogin) _updateStudentDate(init: true);

    _initializeReminder();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    student = Provider.of<StudentRepository>(context).student;
    prefs = Provider.of<SettingRepository>(context);
    update = Provider.of<UpdateRepository>(context).update!;
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        toolbarHeight: 100,
        title: _header(),
        bottom: TabBar(
            controller: _tabController,
            labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
            unselectedLabelColor: Theme.of(context).colorScheme.onPrimary,
            labelColor: MainTheme.orange,
            unselectedLabelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
            labelPadding: const EdgeInsets.symmetric(vertical: 16),
            indicatorColor: MainTheme.orange,
            indicatorPadding: const EdgeInsets.only(bottom: 4),
            tabs: [
              page==0?const Row(mainAxisAlignment: MainAxisAlignment.center,children: [Icon(Icons.school),SizedBox(width: 4),Flexible(child: Text('Cursando', overflow: TextOverflow.ellipsis))]):const Icon(Icons.school),
              page==1?const Row(mainAxisAlignment: MainAxisAlignment.center,children: [Icon(Icons.history),SizedBox(width: 4),Flexible(child: Text('Histórico', overflow: TextOverflow.ellipsis))]):const Icon(Icons.history),
              page==2?const Row(mainAxisAlignment: MainAxisAlignment.center,children: [Icon(Icons.schedule),SizedBox(width: 4),Flexible(child: Text('Horários', overflow: TextOverflow.ellipsis))]):const Icon(Icons.schedule),
            ]),
        actions: [
          Container(
              margin: const EdgeInsets.only(right: 32),child: Row(
            children: [
              update.available? IconButton(onPressed: ()=>Navigator.push(context, PageTransition(child: const UpdatePage(), type: PageTransitionType.rightToLeft, curve: Curves.linear, duration: const Duration(milliseconds: 300))), icon: Icon(Icons.download, color: MainTheme.orange)):const SizedBox(),
              IconButton(onPressed: ()=>Navigator.push(context, PageTransition(child: const SettingPage(), type: PageTransitionType.rightToLeft, curve: Curves.linear, duration: const Duration(milliseconds: 300))), icon: Icon(Icons.settings, color: Theme.of(context).colorScheme.onPrimary))
            ],
          ))],
        shadowColor: Colors.transparent,
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          NotesTab(onPressed: _updateStudentDate),
          HistoricTab(onPressed: _updateStudentDate),
          ScheduleTab(onPressed: _updateStudentDate)
        ],
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
          Expanded(child: Text(student.name,maxLines: student.name.split(' ').length,style: TextStyle(color: Theme.of(context).colorScheme.onPrimary,fontSize: 14))),
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
      studentRep.student = student;
      await control.updateStudent(student);
      prefs.lastInfoUpdate = 'Atualizando Dados';

      historic = await account.userHistoric();
      studentRep.historic = historic;
      studentRep.allHistoric = historic;
       await control.updateHistoric(historic);   

      assessment = await account.userAssessment(oldAssessments: studentRep.allAssessment);
      assessment = await account.userAbsences(assessment);
      studentRep.assessment = assessment;
      studentRep.allAssessment = assessment;
      await control.updateAssessment(assessment);

      schedule = await account.userSchedule();
      if(prefs.updateSchedule) await control.updateSchedule(schedule);

      assessment = await account.userAssessmentDetails(assessment);
      studentRep.assessment = assessment;
      studentRep.allAssessment = assessment;
      await control.updateAssessment(assessment);
      
      if(prefs.updateSchedule) studentRep.schedule = schedule;

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
      if(mounted){
        setState(()=>inUpdateStudentData = false);
      }
    }
  }

  _initializeReminder(){
    NotificationService service = Provider.of<NotificationService>(context,listen: false);
    SettingRepository prefs = Provider.of<SettingRepository>(context,listen: false);
    if(prefs.enableReminder){
      service.showNotification(time: prefs.scheduleNotificationTime);
    }else{
      service.cancelNotitifications();
    }
  }

}

