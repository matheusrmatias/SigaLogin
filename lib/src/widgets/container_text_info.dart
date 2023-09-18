import 'package:flutter/material.dart';
import 'package:sigalogin/src/themes/main_theme.dart';

class TextInfo extends StatelessWidget {
  final String text;
  const TextInfo({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Expanded(child: Container(
        decoration: BoxDecoration(color: MainTheme.tertiary, borderRadius: const BorderRadius.all(Radius.circular(8))),
        padding: const EdgeInsets.all(8),
        child: Text(text, style: TextStyle(color: MainTheme.black,fontSize: 16, fontWeight: FontWeight.bold),textAlign: TextAlign.center)
    ));
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
