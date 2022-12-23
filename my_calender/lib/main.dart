import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'package:my_calender/monthCal.dart';
import 'cursor.dart';
import 'weekCal.dart';


void main() async{
  await Hive.initFlutter(); // hive database 초기화
  await Hive.openBox('lib');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Cursor(selected: DateTime.now())),
        ChangeNotifierProvider(create: (context) => IsMonth(isMonth: true)),
      ],
      builder: (context, child){
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'My_Calender',
            theme: ThemeData(primarySwatch: Colors.blue,),
            home: Provider.of<IsMonth>(context).isMonth ? MonthCal() : WeekCal()
        );
      }
    );
  }
}

