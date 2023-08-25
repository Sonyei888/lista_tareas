import 'package:flutter/material.dart';
import 'package:lista_tareas/app/view/home/home_psge.dart';
import 'package:lista_tareas/app/view/splash/splash_page.dart';
import 'package:lista_tareas/app/view/task_list/task_list_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {

    const primary = Color(0xff40B7AD);
    const textcolor = Color(0xff4A4A4A);
    const backgroundColor = Color(0xFFF5F5F5);

    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: primary),
        scaffoldBackgroundColor: backgroundColor,
        textTheme: Theme.of(context).textTheme.apply(
          fontFamily: 'Poppins',
          bodyColor: textcolor,
          displayColor: textcolor,
        ),

      ),
      home: SplashPage(),
    );
  }
}