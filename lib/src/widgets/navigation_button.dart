import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sigalogin/src/themes/main_theme.dart';

class NavigationButton extends StatelessWidget {
  final String text;
  Widget child;
  Color? backgroundColor;
  Color? color;
  NavigationButton({super.key, required this.text, required this.child,this.backgroundColor, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(margin: const EdgeInsets.symmetric(vertical: 4),child:InkWell(
        splashColor: MainTheme.blackLowOpacity,
        highlightColor: MainTheme.blackLowOpacity,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        onTap: ()=>Navigator.push(context, PageTransition(child: child,type: PageTransitionType.rightToLeft, curve: Curves.linear, duration: const Duration(milliseconds: 300))),
        child: Ink(
          padding:const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            color: backgroundColor??MainTheme.lightGrey,
          ),
          child: Row(
            children: [
              Expanded(child: Text(text ,style: TextStyle(fontSize: 14, color: color??MainTheme.black))),
              IconButton(onPressed: null,icon: Icon(Icons.arrow_forward_ios, color: color?? MainTheme.black,))
            ],
          ),
        )
    ));
  }
}