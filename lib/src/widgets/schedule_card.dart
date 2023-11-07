import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:sigalogin/src/controllers/student_controller.dart';
import 'package:sigalogin/src/models/schedule.dart';
import 'package:sigalogin/src/repositories/settings_repository.dart';
import 'package:sigalogin/src/repositories/student_repository.dart';
import 'package:sigalogin/src/themes/main_theme.dart';

class ScheduleCard extends StatefulWidget {
  final Schedule schedule;
  const ScheduleCard({super.key, required this.schedule});

  @override
  State<ScheduleCard> createState() => _ScheduleCardState();
}

class _ScheduleCardState extends State<ScheduleCard> {
  late StudentRepository repository;
  late SettingRepository setting;
  bool inEdit = false;
  bool inSave = false;
  Map<String,String> hours = {
    '18:45-19:35': '',
    '19:35-20:25': '',
    '20:25-21:15': '',
    '21:25-22:15': '',
    '22:15-23:05': '',
  };
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.schedule.schedule.forEach((key, value) {
      hours[key.trim()] = value.trim();
    });
  }

  @override
  Widget build(BuildContext context) {
    repository = Provider.of<StudentRepository>(context);
    setting = Provider.of<SettingRepository>(context);
    return AnimatedSize(
        duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      alignment: Alignment.topCenter,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Theme.of(context).brightness==Brightness.dark?MainTheme.black:MainTheme.lightGrey,
            borderRadius: const BorderRadius.all(Radius.circular(16))
        ),
        child: Column(
          children: inEdit?_editData():_data(),
        ),
      ),
    );
  }
  List<Widget> _data(){
    List<Widget> list = [];
    list.add(
        Row(
            children: [
              Expanded(child: Text(widget.schedule.weekDay,style: TextStyle(fontSize: 14, color: MainTheme.orange, fontWeight: FontWeight.bold))),
              GestureDetector(
                child: Icon(Icons.edit, color: MainTheme.orange),
                onTap: ()=>setState(()=>inEdit=true))
            ]
        )
    );

    widget.schedule.schedule.forEach((key, value) {
      list.add(Divider(color: MainTheme.orange));
      list.add(
          Container(
            margin: const EdgeInsets.only(top: 8),
            child: Row(crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [Text(key,style: const TextStyle(fontSize: 12, fontFamily: "Arial"), textAlign: TextAlign.justify),const SizedBox(width: 8),Expanded(child: Text(value,style: const TextStyle( fontSize: 14),textAlign: TextAlign.end))]),
          )
      );
    });

    if(list.length==1){
      list.add(Divider(color: MainTheme.orange));
      list.add(const Row(crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [Flexible(child: Text("Nenhum horário de aula encontrado.",style: TextStyle( fontSize: 12, fontFamily: "Arial")))]));
    }
    return list;
  }

  List<Widget> _editData(){
    List<Widget> list = [];
    StudentController controller = StudentController();

    list.add(
        Row(
            children: [
              Expanded(child: Text(widget.schedule.weekDay,style: TextStyle(fontSize: 14, color: MainTheme.orange, fontWeight: FontWeight.bold))),
              GestureDetector(
                  child: Icon(Icons.close, color: MainTheme.orange),
                  onTap: ()=>setState(()=>inEdit=false))
            ]
        )
    );
    hours.forEach((key, value) {
      list.add(Divider(color: MainTheme.orange));
      list.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(key,style: const TextStyle(fontSize: 12, fontFamily: 'Arial')),
              const SizedBox(width: 16),
              Expanded(child: DropdownButton(
                onChanged: (e){
                  Map<String,String> resultsTemp = hours;
                  resultsTemp[key]=e.toString();
                  setState(()=>hours=resultsTemp);
                },
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                isDense: false,
                onTap: hours[key]!.isEmpty?null:(){
                  Map<String,String> resultsTemp = hours;
                  resultsTemp[key]='';
                  setState(()=>hours=resultsTemp);
                },
                alignment: AlignmentDirectional.centerEnd,
                underline: const SizedBox(),
                style: TextStyle(fontSize: 14,fontWeight: FontWeight.normal,fontFamily: 'ResolveLight',color: Theme.of(context).brightness==Brightness.dark?MainTheme.white:MainTheme.black),
                dropdownColor: Theme.of(context).brightness==Brightness.dark?MainTheme.black:MainTheme.lightGrey,
                iconEnabledColor: Theme.of(context).brightness==Brightness.dark?MainTheme.white:MainTheme.black,
                iconDisabledColor: Theme.of(context).brightness==Brightness.dark?MainTheme.white:MainTheme.black,
                isExpanded: true,
                value: hours[key]!.isEmpty?null:hours[key],
                hint: const Row(children: [Flexible(child: Text('Disciplina'))]),
                items: repository.assessment.map((e) => DropdownMenuItem(value: e.name,child: Text(e.name))).toList(),
              ))
            ],
          )
      );
    });

    list.addAll([
      const SizedBox(height: 16),
      inSave? CircularProgressIndicator(color: MainTheme.orange):ElevatedButton(onPressed: ()async{
        setState(()=>inSave = true);
        Schedule newSchedule = Schedule(
          weekDay: widget.schedule.weekDay,
          schedule: _filterHours(hours)
        );
        try{
          await controller.updateOnlySchedule(newSchedule);
          repository.schedule = await controller.querySchedule();
          setState(()=>inEdit=false);
          setting.updateSchedule=false;
          Fluttertoast.showToast(msg: 'Horário salvo com sucesso');
        }catch (e){
          debugPrint('Error: $e');
          Fluttertoast.showToast(msg: 'Ocorreu um erro ao salvar');
        }finally{
          setState(()=>inSave = false);
        }
      },style: ElevatedButton.styleFrom(backgroundColor: MainTheme.orange,minimumSize: const Size(double.maxFinite, 0),padding: const EdgeInsets.all(16)), child: Text('Salvar',style: TextStyle(color: MainTheme.white,fontSize: 16)))
    ]);

    return list;
  }

  Map<String, String> _filterHours(Map<String,String> map){
    List<MapEntry<String, String>> entryList = hours.entries.toList();

    List<MapEntry<String, String>> filteredEntries = entryList.where((entry) {
      return entry.value.isNotEmpty;
    }).toList();

    Map<String, String> filteredMap = Map.fromEntries(filteredEntries);
    return filteredMap;
  }

}