import 'package:flutter/material.dart';
import 'package:my_calender/week_cal.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My_Calender',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WeekCal(),
    );
  }
}

