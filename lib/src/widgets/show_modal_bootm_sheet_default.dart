import 'package:flutter/material.dart';
import 'package:sigalogin/src/themes/main_theme.dart';

showModalBottomSheetDefault(BuildContext context, String text){
  showModalBottomSheet(backgroundColor: Colors.transparent,context: context, builder: (BuildContext context){
    return Container( decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: const BorderRadius.all(Radius.circular(16))
    ),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      child: SingleChildScrollView(
          child: Row(
            children: [
              Image.asset('assets/images/splash.png', width: 50),
              const SizedBox(width: 4),
              Expanded(child: Column(
                children: [
                  Row(crossAxisAlignment: CrossAxisAlignment.end,children: [Flexible(child: Text(text, style: TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontSize: 16),textAlign: TextAlign.justify,))],),
                  const SizedBox(width: 4),
                  SizedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Flexible(child: GestureDetector(
                            onTap: ()=>Navigator.pop(context),
                            child: Text('OK', style: TextStyle(color: MainTheme.orange, fontSize: 16, fontWeight: FontWeight.bold))
                        ),)
                      ],
                    ),
                  )
                ],
              ))
            ],
          )
      ),
    );
  });
}