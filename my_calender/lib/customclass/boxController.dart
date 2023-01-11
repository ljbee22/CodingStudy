import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:my_calender/customclass/scheduleClass.dart';

class BoxController {
  // 새로운 일정을 만듦 (맨 아래에)
  void newSchedule(Box box, String scheduleDate, ScheduleClass nSchedule) {
    if(box.containsKey(scheduleDate)) {
      List tmp = box.get(scheduleDate)!;
      tmp.add(nSchedule);
      box.put(scheduleDate, tmp);
    }
    else {
      List tmp = [nSchedule];
      box.put(scheduleDate, tmp);
    }
  }
  // 일정 삭제
  void deleteSchedule(Box box, String scheduleDate, int idx) {
    List totalList = box.get(scheduleDate);
    totalList.removeAt(idx);
    if(totalList.isEmpty){
      box.delete(scheduleDate);}
    else {box.put(scheduleDate, totalList);}
  }
  // 일정의 인덱스를 유지하면서 수정
  void editSchedule(Box box, String scheduleDate, ScheduleClass nSchedule, int idx) {
    List totalList = box.get(scheduleDate);
    totalList[idx] = nSchedule;
    box.put(scheduleDate, totalList);
  }
  // 기존 일정을 삭제하고 새로운 날짜에 일정을 만듦
  void changeScheduleDate(Box box, String scheduleDate, DateTime newDate, ScheduleClass nSchedule, int idx) {
    newSchedule(box, DateFormat('yyyy.MM.dd').format(newDate), nSchedule);
    deleteSchedule(box, scheduleDate, idx);
  }
}