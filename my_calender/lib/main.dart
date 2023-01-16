import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_calender/customclass/hiveClass.dart';
import 'package:provider/provider.dart';
import 'package:my_calender/customclass/cursor.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:my_calender/Calender.dart';
import 'package:my_calender/customclass/calenderElement.dart' as data;


void main() async{
  await Hive.initFlutter(); // hive database 초기화
  Hive.registerAdapter(ScheduleClassAdapter());
  await Hive.openBox<List>('Box');
  await Hive.openBox('setting');
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
              fontFamily: data.fontList[0], //TODO box에서 idx 가져오는걸로 수정
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