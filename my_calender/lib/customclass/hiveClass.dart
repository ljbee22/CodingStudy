import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
part 'hiveClass.g.dart';

//typeId 0은 안된다
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
  @HiveField(6)
  int colorIdx;

  ScheduleClass({
    required this.name,
    this.memo = "",
    required this.date,
    this.btime = false,
    this.done = false,
    this.alarm = false,
    this.colorIdx = 0,
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

  changeScheduleElements(String name, String memo, DateTime newDate, DateTime newTime, bool btime, bool alarm, int colorIdx){
    this.name = name;
    this.memo = memo;
    this.date = DateTime(newDate.year, newDate.month, newDate.day, newTime.hour, newTime.minute);
    this.btime = btime;
    this.alarm = alarm;
    this.colorIdx = colorIdx;
  }

  String timeString() {
    return DateFormat.jm().format(date);
  }
}

@HiveType(typeId: 2)
class SettingClass{
  @HiveField(0)
  bool isSunday; // 월요일 시작 or 일요일 시작?
  @HiveField(1)
  int themeIdx; // 컬러테마 인덱스
  @HiveField(2)
  int fontIdx;
  @HiveField(3)
  bool isEmoticon;

  SettingClass({
    this.isSunday = false, // default = 월요일 시작
    this.themeIdx = 0, // default = 기본 컬러 테마(=0)
    this.fontIdx = 0, // default = 기본 폰트(=0)
    this.isEmoticon = true,
  });

  SettingClass sunday(bool isSundayA) {
    return SettingClass(isSunday: isSundayA, fontIdx: fontIdx, themeIdx : themeIdx, isEmoticon: isEmoticon);
  }

  SettingClass fontChange(int newFontIdx){
    return SettingClass(isSunday: isSunday, fontIdx: newFontIdx, themeIdx: themeIdx, isEmoticon: isEmoticon);
  }
  //TODO 매번 요소 하나하나를 바꿀때마다 그를 위한 함수를 만들어야함... 한번에 다 바꿀 수 있는 함수는 없을까?

  SettingClass emoticonOn(bool isEmoticonA){
    return SettingClass(isSunday: isSunday, fontIdx: fontIdx, themeIdx: themeIdx, isEmoticon: isEmoticonA);
  }
}

@HiveType(typeId: 3)
class DailyController{
  @HiveField(0)
  int doneCount;
  @HiveField(1)
  String emoticon;
  @HiveField(2)
  String dailyComment;

  DailyController({
    this.doneCount = 0,
    this.emoticon = 'assets/emoticon/plus.png',
    this.dailyComment = '',
});

  DailyController plusCount(bool A){
    if(A){
      doneCount++;
    }
    else{
      doneCount--;
    }
    return DailyController(doneCount: doneCount, emoticon: emoticon, dailyComment: dailyComment);
  }

}