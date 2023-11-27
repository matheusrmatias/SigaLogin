import 'package:flutter/material.dart';

import '../themes/main_theme.dart';

class TimePickerInput extends StatelessWidget {
  final IconData? icon;
  final Color? backgroundColor;
  final Color? color;
  TimeOfDay? time;
  ValueSetter<TimeOfDay?> setTime;
  final String text;
  final bool? enable;

  TimePickerInput(
      {super.key,
      required this.text,
      required this.time,
      required this.setTime,
      this.backgroundColor,
      this.icon,
      this.color,
      this.enable});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        child: InkWell(
            borderRadius: const BorderRadius.all(Radius.circular(16)),
            onTap: !(enable ?? true)
                ? null
                : () async {
                    TimeOfDay? timeTemp = await showTimePicker(
                        context: context,
                        initialTime: time??const TimeOfDay(hour: 7, minute: 0),
                        helpText: 'Informe o Horário',
                        initialEntryMode: TimePickerEntryMode.inputOnly,
                        errorInvalidText: 'Informe um valor válido',
                        confirmText: 'Ok',
                        cancelText: 'Cancelar',
                        hourLabelText: 'Hora',
                        minuteLabelText: 'Minuto',
                        builder: (context, child) {
                          return Theme(
                            data: ThemeData(
                                brightness: Theme.of(context).brightness,
                                useMaterial3: false,
                                textButtonTheme: TextButtonThemeData(
                                    style: ButtonStyle(
                                        foregroundColor:
                                            MaterialStateColor.resolveWith(
                                                (states) => MainTheme.orange))),
                                timePickerTheme: TimePickerThemeData(
                                  inputDecorationTheme: InputDecorationTheme(
                                    contentPadding: EdgeInsets.zero,
                                    filled: true,                                    
                                    focusColor: Colors.transparent,
                                    enabledBorder: const OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.transparent),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: MainTheme.red, width: 2),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: MainTheme.orange, width: 2),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: MainTheme.red, width: 2),
                                    ),                                    
                                    errorStyle:
                                        const TextStyle(fontSize: 0, height: 0),
                                  ),
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(16))),
                                  dayPeriodTextColor: MainTheme.orange,
                                  hourMinuteTextColor:
                                      MaterialStateColor.resolveWith((states) =>
                                          states.contains(
                                                  MaterialState.selected)
                                              ? MainTheme.orange
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary),
                                  backgroundColor:
                                      Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? MainTheme.black
                                          : MainTheme.lightGrey,
                                )),
                            child: child ?? const SizedBox(),
                          );
                        });
                    setTime(timeTemp ?? time);                
                  },
            child: Ink(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                color: backgroundColor ??
                    (Theme.of(context).brightness == Brightness.dark
                        ? MainTheme.black
                        : MainTheme.lightGrey),
              ),
              child: Row(
                children: [
                  Icon(
                    icon,
                    color: color ?? MainTheme.grey,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                      child: Text(text,
                          style: TextStyle(fontSize: 14, color: color))),
                  TextButton(
                      onPressed: null,
                      child: Text(
                        time==null? const TimeOfDay(hour: 7, minute: 0).format(context):time!.format(context),
                        style: TextStyle(
                            fontSize: 16,
                            color: enable ?? true
                                ? MainTheme.orange
                                : MainTheme.grey,
                            fontWeight: FontWeight.bold),
                      ))
                ],
              ),
            )));
    ;
  }
}
