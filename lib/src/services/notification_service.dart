import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sigalogin/src/controllers/student_controller.dart';
import 'package:sigalogin/src/models/schedule.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/tzdata.dart';

class NotificationService {
  late FlutterLocalNotificationsPlugin localNotificationsPlugin;
  late AndroidNotificationDetails androidDetails;

  NotificationService() {
    localNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _setupNotifications();
  }

  _setupNotifications() async {
    await _setupTimeZone();
    await _initializaNotifications();
  }

  _setupTimeZone() async {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  _initializaNotifications() async {
    const android = AndroidInitializationSettings('@mipmap/launcher_icon');
    await localNotificationsPlugin.initialize(
      const InitializationSettings(android: android),
    );
  }

  Future<List<Schedule>> _loadSchedules() async {
    StudentController controller = StudentController();
    return await controller.querySchedule();
  }

  int _daysInMonth(DateTime date) {
    var firstDayThisMonth = DateTime(date.year, date.month, date.day);
    var firstDayNextMonth = DateTime(firstDayThisMonth.year,
        firstDayThisMonth.month + 1, firstDayThisMonth.day);
    return firstDayNextMonth.difference(firstDayThisMonth).inDays;
  }

  showNotification({TimeOfDay? time}) async {
    if (await Permission.notification.request() == PermissionStatus.denied)
      return;
    List<Schedule> schedules = await _loadSchedules();
    if (schedules.isEmpty) return;
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

    DateTime scheduleDate = DateTime(now.year, now.month, today,
        time == null ? 7 : time.hour, time == null ? 0 : time.minute);
    int i = today;
    for (i; i < today + 30; i++) {
      if (scheduleDate.millisecondsSinceEpoch < now.millisecondsSinceEpoch) {
        scheduleDate = scheduleDate.add(const Duration(days: 1));
        continue;
      }
      try {
        if (scheduleDate.weekday != 6 &&
            scheduleDate.weekday != 7 &&
            schedules[scheduleDate.weekday - 1].schedule.isNotEmpty) {
          await localNotificationsPlugin.zonedSchedule(
              i,
              'Aulas de hoje, ${schedules[scheduleDate.weekday - 1].weekDay}',
              schedules[scheduleDate.weekday - 1]
                  .schedule
                  .toString()
                  .replaceAll(', ', '\n')
                  .replaceAll("{", '')
                  .replaceAll("}", ''),
              tz.TZDateTime.from(scheduleDate, tz.local),
              NotificationDetails(android: androidDetails),
              androidAllowWhileIdle: true,
              uiLocalNotificationDateInterpretation:
                  UILocalNotificationDateInterpretation.absoluteTime);
        } else {
          await localNotificationsPlugin.zonedSchedule(
              i,
              'Hoje não tem aula',
              'Aproveite e descanse',
              tz.TZDateTime.from(scheduleDate, tz.local),
              NotificationDetails(android: androidDetails),
              androidAllowWhileIdle: true,
              uiLocalNotificationDateInterpretation:
                  UILocalNotificationDateInterpretation.absoluteTime);
        }
        scheduleDate = scheduleDate.add(const Duration(days: 1));
      } on ArgumentError catch (e) {
        debugPrint('Notification Error: ${e.message}');
      }
    }
    debugPrint('${i - today} Notifications Scheduled');
  }

  cancelNotitifications() async {
    await localNotificationsPlugin.cancelAll();
    debugPrint('All Notifications Canceled');
  }
}
