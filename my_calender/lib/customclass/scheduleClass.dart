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
  String memo; // 간단한 메모
  @HiveField(2)
  DateTime date; // 날짜, 시간 저장
  @HiveField(3)
  bool btime; // 시간 존재 여부
  @HiveField(4)
  bool done; // 일정 해결 여부
  @HiveField(5)
  bool alarm; // 알림 여부


  ScheduleClass({
    required this.name,
    this.memo = "",
    required this.date,
    this.btime = false,
    this.done = false,
    this.alarm = false
  });

  void newDate(DateTime A) {
    date = A;
  }

  void changeDateAndTime(DateTime newDate, DateTime newTime){
    date = DateTime(newDate.year, newDate.month, newDate.day, newTime.hour, newTime.minute);
  }

  bool isDayChanged(DateTime A){
    if(date.year != A.year) return true;
    if(date.month != A.month) return true;
    if(date.day != A.day) return true;
    return false;
  }

  changeScheduleElements(String name, String memo, DateTime newDate, DateTime newTime, bool btime, bool alarm){
    this.name = name;
    this.memo = memo;
    this.date = DateTime(newDate.year, newDate.month, newDate.day, newTime.hour, newTime.minute);
    this.btime = btime;
    this.alarm = alarm;
    //TODO done에 관한 것도 넣기
  }
}