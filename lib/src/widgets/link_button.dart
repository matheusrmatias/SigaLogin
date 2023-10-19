import 'package:flutter/material.dart';
import 'package:sigalogin/src/themes/main_theme.dart';

class LinkButton extends StatefulWidget {
  Function()? func;
  String text;
  LinkButton({super.key, required this.func, required this.text});

  @override
  State<LinkButton> createState() => _LinkButtonState();
}

class _LinkButtonState extends State<LinkButton> {
  @override
  Widget build(BuildContext context) {
    return Container(margin: const EdgeInsets.symmetric(vertical: 8), child: InkWell(
        splashColor: MainTheme.blackLowOpacity,
        highlightColor: MainTheme.blackLowOpacity,
        onTap: widget.func,
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
              color: MainTheme.lightGrey,
              borderRadius: const BorderRadius.all(Radius.circular(8))
          ),
          child: Row(
            children: [
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