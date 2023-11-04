import 'package:flutter/material.dart';
import 'package:sigalogin/src/themes/main_theme.dart';

class TextInfo extends StatelessWidget {
  final String text;
  final String title;
  Color? titleColor;
  Color? textColor;
  Color? backgroundColor;
  Function()? onTap;
  TextInfo({super.key, required this.text, required this.title, this.titleColor, this.textColor, this.backgroundColor,this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: MainTheme.blackLowOpacity,
      highlightColor: MainTheme.blackLowOpacity,
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      child: Ink(
          decoration: BoxDecoration(color: backgroundColor??(Theme.of(context).brightness==Brightness.dark?MainTheme.black:MainTheme.lightGrey), borderRadius: const BorderRadius.all(Radius.circular(16))),
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Text(title, style: TextStyle(color: titleColor,fontSize: 14, fontWeight: FontWeight.bold),textAlign: TextAlign.center),
              Text(text, style: TextStyle(color: textColor,fontSize: 14),textAlign: TextAlign.center)
            ],
          )
      ),
    );
  }
}


// class ContainerTextInfo extends StatefulWidget {
//   final String text;
//   const ContainerTextInfo({super.key, required this.text});
//
//   @override
//   State<ContainerTextInfo> createState() => _ContainerTextInfoState();
// }
//
// class _ContainerTextInfoState extends State<ContainerTextInfo> {
//   @override
//   Widget build(BuildContext context) {
//     return Expanded(child: Container(
//         decoration: BoxDecoration(color: MainTheme.tertiary, borderRadius: const BorderRadius.all(Radius.circular(8))),
//         padding: const EdgeInsets.all(8),
//         child: Text(widget.text, style: TextStyle(color: MainTheme.black,fontSize: 16, fontWeight: FontWeight.bold),textAlign: TextAlign.center)
//     ));
//   }
// }
