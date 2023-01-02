import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import '../cursor.dart';
import '../Calender.dart';

part 'scheduleClass.g.dart';

@HiveType(typeId: 1)
class ScheduleClass{
  @HiveField(0)
  String name; // 일정 이름
  @HiveField(1)
  bool alarm; // 알림 여부
  @HiveField(2)
  DateTime date; // 일정 날짜 및 시간 저장
  @HiveField(3)
  bool btime; // 시간 존재 여부
  @HiveField(4)
  bool done; // 일정 해결 여부
  @HiveField(5)
  String memo; // 간단한 메모


  ScheduleClass({
    required this.name,
    this.alarm = false,
    required this.date,
    this.btime = false,
    this.done = false,
    this.memo = "메모"
  });
}