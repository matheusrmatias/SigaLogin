import 'package:flutter/material.dart';
import 'package:sigalogin/src/themes/main_theme.dart';

class SettingSwitch extends StatefulWidget {
  final String text;
  Function(bool) onChange;
  IconData? icon;
  bool value;
  SettingSwitch({super.key, required this.text, required this.onChange, required this.value, this.icon});

  @override
  State<SettingSwitch> createState() => _SettingSwitchState();
}

class _SettingSwitchState extends State<SettingSwitch> {

  @override
  Widget build(BuildContext context) {
    return Container(margin: const EdgeInsets.symmetric(vertical: 8),child:InkWell(
        onTap: ()=>widget.onChange(!widget.value),
        borderRadius: const BorderRadius.all(Radius.circular(16)),
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
            color: Theme.of(context).brightness==Brightness.dark?MainTheme.black:MainTheme.lightGrey,
            borderRadius: const BorderRadius.all(Radius.circular(16))
        ),
        child: Row(
            children: [
              widget.icon==null? const SizedBox():Icon(widget.icon, color: widget.value?MainTheme.orange:MainTheme.grey),
              SizedBox(width: widget.icon==null?0:4),
              Expanded(child: Text(widget.text ,style: const TextStyle(fontSize: 14))),
              Switch(value: widget.value, onChanged: widget.onChange, activeColor: MainTheme.orange)
            ]
        ),
      )
    ));
  }
}