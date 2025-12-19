import 'package:flutter/material.dart';

class Themefont {
  ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.amber,
    scaffoldBackgroundColor: Colors.white,
    fontFamily: 'OpenSans',

    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Color.fromARGB(255, 0, 0, 0),
      ),
      iconTheme: IconThemeData(color: Color.fromARGB(255, 0, 0, 0)),
    ),

    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.black),
      titleLarge: TextStyle(color: Colors.black),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        foregroundColor: Colors.black,
      ),
    ),
  );

  ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.amber,
    scaffoldBackgroundColor: Colors.black,
    // fontFamily: 'OpenSans',

    // appBarTheme: const AppBarTheme(
    //   backgroundColor: Colors.black,
    //   titleTextStyle: TextStyle(
    //     fontSize: 20,
    //     fontWeight: FontWeight.bold,
    //     color: Colors.white,
    //   ),
    //   iconTheme: IconThemeData(color: Colors.white),
    // ),

    // textTheme: const TextTheme(
    //   bodyMedium: TextStyle(color: Colors.white),
    //   titleLarge: TextStyle(color: Colors.white),
    // ),

    // elevatedButtonTheme: ElevatedButtonThemeData(
    //   style: ElevatedButton.styleFrom(
    //     backgroundColor: Colors.amber,
    //     foregroundColor: Colors.black,
    //   ),
    // ),
  );
}
