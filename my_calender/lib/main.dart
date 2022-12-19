import 'package:flutter/material.dart';
import 'package:my_calender/month_cal.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async{
  await Hive.initFlutter(); // hive database 초기화
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
      home: MonthCal(),
    );
  }
}

