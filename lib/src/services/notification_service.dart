import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sigalogin/src/controllers/student_controller.dart';
import 'package:sigalogin/src/models/schedule.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;


class NotificationService{
  late FlutterLocalNotificationsPlugin localNotificationsPlugin;
  late AndroidNotificationDetails androidDetails;

  NotificationService(){
    localNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _setupNotifications();
  }

  _setupNotifications()async{
    await _setupTimeZone();
    await _initializaNotifications();
  }

  _setupTimeZone()async{
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  _initializaNotifications() async{
    const android = AndroidInitializationSettings('@mipmap/launcher_icon');
    await localNotificationsPlugin.initialize(
      const InitializationSettings(
        android: android
      ),
    );
  }

  Future<List<Schedule>> _loadSchedules()async{
    StudentController controller = StudentController();
     return await controller.querySchedule();
  }

  Future<String> _getStudentPeriod()async{
    StudentController controller = StudentController();
    return (await controller.queryStudent()).period.trim();
  }

  int _daysInMonth(DateTime date){
    var firstDayThisMonth = DateTime(date.year, date.month, date.day);
    var firstDayNextMonth = DateTime(firstDayThisMonth.year, firstDayThisMonth.month + 1, firstDayThisMonth.day);
    return firstDayNextMonth.difference(firstDayThisMonth).inDays;
  }

  showNotification()async{
    await Permission.notification.request();
    List<Schedule> schedules = await _loadSchedules();
    String period = await _getStudentPeriod();
    if(schedules.isEmpty)return;
    androidDetails = const AndroidNotificationDetails(
      "Lembretes",
      "Lembretes de Horários",
      importance: Importance.max,
      priority: Priority.max,
      enableVibration: true,
      styleInformation: BigTextStyleInformation(''),
    );

    DateTime now = DateTime.now();
    int today = DateTime.now().day;

    DateTime scheduleDate = DateTime(
      now.year,
      now.month,
      today,
      period=="Noite"?17:7,
    );

    for(int i = today; i<today+30; i++){
      if(scheduleDate.weekday != 6 && scheduleDate.weekday != 7 && scheduleDate.millisecondsSinceEpoch>now.millisecondsSinceEpoch){
        print(scheduleDate);
        localNotificationsPlugin.zonedSchedule(
            i,
            'Aulas de hoje, ${schedules[scheduleDate.weekday-1].weekDay}',
            schedules[scheduleDate.weekday-1].schedule.toString().replaceAll(', ','\n').replaceAll("{", '').replaceAll("}", ''),
            tz.TZDateTime.from(scheduleDate, tz.local),
            NotificationDetails(
                android: androidDetails
            ),
            androidAllowWhileIdle: true,
            uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime
        );
      }else{
        print(scheduleDate);
        localNotificationsPlugin.zonedSchedule(
            i,
            'Hoje não tem aula',
            'Aproveite e descanse',
            tz.TZDateTime.from(scheduleDate, tz.local),
            NotificationDetails(
                android: androidDetails
            ),
            androidAllowWhileIdle: true,
            uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime
        );
      }
      scheduleDate = scheduleDate.add(const Duration(days: 1));
    }

  }

  cancelNotitifications()async{
    localNotificationsPlugin.cancelAll();
  }


}