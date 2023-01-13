import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_calender/customclass/scheduleClass.dart';
import 'package:my_calender/localNotification.dart';
import 'package:provider/provider.dart';
import 'package:my_calender/customclass/cursor.dart';
import 'Calender.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


void main() async{
  await Hive.initFlutter(); // hive database 초기화
  Hive.registerAdapter(ScheduleClassAdapter());
  await Hive.openBox<List>('Box');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Cursor(selected: DateTime.now())),
      ],
      builder: (context, child){
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'My_Calender',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              fontFamily: 'Myfont',
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('ko', ''),
              Locale('en', ''),
            ],
            home: const Calender(),
        );
      }
    );
  }
}