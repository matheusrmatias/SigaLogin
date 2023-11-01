import 'package:flutter/material.dart';
import 'package:sigalogin/src/themes/main_theme.dart';

class LinkButton extends StatefulWidget {
  Function()? func;
  String text;
  Color? color;
  IconData? icon;
  LinkButton({super.key, required this.func, required this.text, this.color, this.icon});

  @override
  State<LinkButton> createState() => _LinkButtonState();
}

class _LinkButtonState extends State<LinkButton> {
  @override
  Widget build(BuildContext context) {
    return Container(margin: const EdgeInsets.symmetric(vertical: 8), child: InkWell(
        splashColor: MainTheme.blackLowOpacity,
        highlightColor: MainTheme.blackLowOpacity,
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        onTap: widget.func,
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
              color: MainTheme.lightGrey,
              borderRadius: const BorderRadius.all(Radius.circular(16))
          ),
          child: Row(
            children: [
              widget.icon==null?const SizedBox():Icon(widget.icon,color: widget.color??MainTheme.black),
              SizedBox(width: widget.icon==null?0:4),
              Expanded(child: Text(
                  widget.text, style: TextStyle(fontSize: 14, color: MainTheme.black))),
              IconButton(onPressed: null,
                  icon: Icon(Icons.arrow_forward_ios, color: MainTheme.black,))
            ],
          ),
        )
    ));
  }
}