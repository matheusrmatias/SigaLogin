import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum ThemeStatus {Dark,Light,System}

class MainTheme {

  static Color orange = const Color.fromRGBO(249, 115, 22, 1);
  static Color blackLowOpacity = const Color.fromRGBO(38, 38, 38, 0.1);
  static Color lightOrange = const Color.fromRGBO(251, 146, 60, 1);
  static Color lightBlue = const Color.fromRGBO(75, 158, 230, 1.0);
  static Color tertiary = const Color.fromRGBO(217, 217, 217, 1);
  static Color lightGrey = const Color.fromRGBO(217, 217, 217, 1);
  static Color grey = const Color.fromRGBO(150, 150, 150, 1.0);
  static Color black = const Color.fromRGBO(38, 38, 38, 1);
  static Color white = const Color.fromRGBO(242, 242, 242, 1);
  static Color red = const Color.fromRGBO(217, 4, 4, 1);
  static Color darkRed = const Color.fromRGBO(151, 37, 26, 1.0);

  static ThemeData darkTheme = ThemeData(
    fontFamily: 'ResolveLight',
    colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: Color.fromRGBO(38, 38, 38, 1),
        onPrimary: Color.fromRGBO(242, 242, 242, 1),
        secondary: Color.fromRGBO(249, 115, 22, 1),
        onSecondary: Color.fromRGBO(242, 242, 242, 1),
        error: Color.fromRGBO(217, 4, 4, 1),
        onError: Color.fromRGBO(242, 242, 242, 1),
        background: Color.fromRGBO(38, 38, 38, 1),
        onBackground: Color.fromRGBO(242, 242, 242, 1),
        surface: Color.fromRGBO(38, 38, 38, 1),
        onSurface: Color.fromRGBO(242, 242, 242, 1),
        tertiary: Color.fromRGBO(38, 38, 38, 1)
    ),
    canvasColor: const Color.fromRGBO(38, 38, 38, 1),
  );

  static ThemeData lightTheme = ThemeData(
    fontFamily: 'ResolveLight',
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: Color.fromRGBO(242, 242, 242, 1),
      onPrimary: Color.fromRGBO(38, 38, 38, 1),
      secondary: Color.fromRGBO(249, 115, 22, 1),
      onSecondary: Color.fromRGBO(242, 242, 242, 1),
      error: Color.fromRGBO(217, 4, 4, 1),
      onError: Color.fromRGBO(242, 242, 242, 1),
      background: Color.fromRGBO(242, 242, 242, 1),
      onBackground: Color.fromRGBO(38, 38, 38, 1),
      surface: Color.fromRGBO(242, 242, 242, 1),
      onSurface: Color.fromRGBO(38, 38, 38, 1),
      tertiary: Color.fromRGBO(217, 217, 217, 1),
    ),
    canvasColor: const Color.fromRGBO(242, 242, 242, 1),
    primaryColor: const Color.fromRGBO(242, 242, 242, 1),
  );

}
//
// ThemeData darkTheme(){
//   return ThemeData(
//     fontFamily: 'ResolveLight',
//     colorScheme: const ColorScheme(
//         brightness: Brightness.dark,
//         primary: Color.fromRGBO(38, 38, 38, 1),
//         onPrimary: Color.fromRGBO(242, 242, 242, 1),
//         secondary: Color.fromRGBO(249, 115, 22, 1),
//         onSecondary: Color.fromRGBO(242, 242, 242, 1),
//         error: Color.fromRGBO(217, 4, 4, 1),
//         onError: Color.fromRGBO(242, 242, 242, 1),
//         background: Color.fromRGBO(38, 38, 38, 1),
//         onBackground: Color.fromRGBO(242, 242, 242, 1),
//         surface: Color.fromRGBO(38, 38, 38, 1),
//         onSurface: Color.fromRGBO(242, 242, 242, 1),
//         tertiary: Color.fromRGBO(38, 38, 38, 1)
//     ),
//     canvasColor: const Color.fromRGBO(38, 38, 38, 1),
//   );
// }
//
// ThemeData lightTheme(){
//   return ThemeData(
//       fontFamily: 'ResolveLight',
//       colorScheme: const ColorScheme(
//           brightness: Brightness.light,
//           primary: Color.fromRGBO(242, 242, 242, 1),
//           onPrimary: Color.fromRGBO(38, 38, 38, 1),
//           secondary: Color.fromRGBO(249, 115, 22, 1),
//           onSecondary: Color.fromRGBO(242, 242, 242, 1),
//           error: Color.fromRGBO(217, 4, 4, 1),
//           onError: Color.fromRGBO(242, 242, 242, 1),
//           background: Color.fromRGBO(242, 242, 242, 1),
//           onBackground: Color.fromRGBO(38, 38, 38, 1),
//           surface: Color.fromRGBO(242, 242, 242, 1),
//           onSurface: Color.fromRGBO(38, 38, 38, 1),
//           tertiary: Color.fromRGBO(217, 217, 217, 1),
//       ),
//     canvasColor: const Color.fromRGBO(242, 242, 242, 1),
//     primaryColor: const Color.fromRGBO(242, 242, 242, 1),
//   );
// }