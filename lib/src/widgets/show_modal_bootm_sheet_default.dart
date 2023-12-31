import 'package:flutter/material.dart';
import 'package:sigalogin/src/themes/main_theme.dart';

showModalBottomSheetDefault(BuildContext context, String text, {String? title}){
  showModalBottomSheet(backgroundColor: Colors.transparent,context: context, builder: (BuildContext context){
    return Container( decoration: BoxDecoration(
        color: Theme.of(context).brightness==Brightness.dark?MainTheme.black:MainTheme.white,
        borderRadius: const BorderRadius.all(Radius.circular(16))
    ),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Column(mainAxisAlignment: MainAxisAlignment.center,children: [ClipRRect(borderRadius: BorderRadius.circular(10),child: Image.asset('assets/images/icon.png', width: 50))]),
                  const SizedBox(width: 8),
                  Expanded(child: Column(
                    children: [
                      title==null? const SizedBox():Row(children: [Expanded(child: Text(title, style: TextStyle(color: MainTheme.orange, fontSize: 16,fontWeight: FontWeight.bold),textAlign: TextAlign.center,))]),
                      Row(children: [Expanded(child: Text(text, style: TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontSize: 16),textAlign: TextAlign.justify,))]),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Flexible(child: GestureDetector(
                              onTap: ()=>Navigator.pop(context),
                              child: Text('OK', style: TextStyle(color: MainTheme.orange, fontSize: 16, fontWeight: FontWeight.bold))
                          ))
                        ],
                      ),
                    ],
                  ))
                ],
              ),
            ],
          )
      ),
    );
  });
}

showModalBottomSheetConfirmAction(BuildContext context,String text, Function() function,{String? afirmativeText,String? negativeText}){
  showModalBottomSheet(backgroundColor: Colors.transparent,context: context, builder: (BuildContext context){
    return Container(decoration: BoxDecoration(
        color: Theme.of(context).brightness==Brightness.dark?MainTheme.black:MainTheme.white,
        borderRadius: const BorderRadius.all(Radius.circular(16))
    ),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(borderRadius: BorderRadius.circular(10),child: Image.asset('assets/images/icon.png', width: 50)),
                const SizedBox(width: 8),
                Expanded(child: Text(text, style: TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontSize: 16),textAlign: TextAlign.justify))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(child: GestureDetector(
                    onTap: ()=>Navigator.pop(context),
                    child: Text(negativeText??'Não', style: TextStyle(color: MainTheme.orange, fontSize: 16, fontWeight: FontWeight.bold))
                )),
                const SizedBox(width: 16),
                Flexible(child: GestureDetector(
                    onTap: (){function();Navigator.pop(context);},
                    child: Text(afirmativeText??'Sim', style: TextStyle(color: MainTheme.orange, fontSize: 16, fontWeight: FontWeight.bold))
                ))
              ],
            ),
          ],
        ),
      )
    );
  });
}