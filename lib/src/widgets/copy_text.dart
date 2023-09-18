import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sigalogin/src/themes/main_theme.dart';

class CopyCard extends StatefulWidget {
  final String text;
  Widget ico;
  CopyCard({super.key, required this.text, this.ico = const Text('')});

  @override
  State<CopyCard> createState() => _CopyCardState();
}

class _CopyCardState extends State<CopyCard> {
  bool onCopy = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _copyText,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
            color: MainTheme.tertiary,
            borderRadius: const BorderRadius.all(Radius.circular(8))
        ),
        child: Row(
          children: [
            widget.ico,
            Expanded(child: Container(margin: const EdgeInsets.only(left: 4),child: Text(onCopy? 'Copiado para área de transferência.':widget.text, style: TextStyle(fontSize: 14, color: MainTheme.black)))),
            IconButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: _copyText,
                icon: AnimatedSwitcher(duration: const Duration(milliseconds: 300),
                  switchInCurve: Curves.easeInOut,
                  switchOutCurve: Curves.easeInOut,
                  transitionBuilder: (child, animation)=>ScaleTransition(scale: animation, child: child),
                  child: onCopy? Icon(Icons.done,color: MainTheme.orange, key: ValueKey("true"),):Icon(Icons.copy,color: MainTheme.black, key: ValueKey("false"))
                  ,))
          ],
        ),
      ),
    );
  }

  _copyText()async{
    await Clipboard.setData(ClipboardData(text: widget.text));
    setState(()=>onCopy=true);
    await Future.delayed(const Duration(milliseconds: 1500));
    setState(()=>onCopy=false);

  }
}