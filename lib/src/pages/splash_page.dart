import 'package:flutter/material.dart';
import 'package:sigalogin/src/themes/main_theme.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            color: MainTheme.orange,
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    'assets/images/icon.png',
                    width: 175,
                    height: 175,
                  ),
                  Padding(padding: const EdgeInsets.only(top: 196),child:  CircularProgressIndicator(color: MainTheme.white))
                ],
              ),
            )
        )
    );
  }
}
