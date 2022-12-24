import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:my_calender/monthCal.dart';
import 'cursor.dart';
import 'weekCal.dart';

class ScheduleClass{
  String name;
  bool alarm;
  late DateTime date;
  bool btime;
  bool done;

  ScheduleClass({
    required this.name,
    this.alarm = false,
    required this.date,
    this.btime = false,
    this.done = false
  });
}

class HiveBox {
  Future<Box> openHive() async {
    Box lib = await Hive.openBox('lib');
    return lib;
  }
}