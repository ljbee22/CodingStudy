import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';

@HiveType(typeId: 2)
class SettingClass {
  @HiveField(0)
  bool isMondayStart; // 월요일 시작 or 일요일 시작?
  @HiveField(1)
  int themeIdx; // 컬러테마 인덱스

  SettingClass({
    this.isMondayStart = false, // default = 월요일 시작
    this.themeIdx = 0, // default = 기본 컬러 테마(=0)
  });
}