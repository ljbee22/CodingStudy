import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class Cursor with ChangeNotifier{
  late DateTime selected;
  bool isMonth = false;

  Cursor({
    required this.selected
  });

  /*특정 요일을 대입 -> 그 요일이 속한 달의 첫번째 요일을 숫자로 리턴*/
  int dayOfWeek(){
    final firstDay = DateTime(selected.year, selected.month, 1);
    var firstDayVal = firstDay.weekday;
    return ((selected.day+firstDayVal-2) ~/ 7) + 1;
  }

  List<DateTime> dayList() {
    DateTime firstDay = DateTime(selected.year, selected.month,1);
    List<DateTime> dList = List<DateTime>.filled(42,DateTime(0,0,0));
    int i = 0;
    int j = 2-firstDay.weekday;
    while (i <= 41) {
      dList[i] = DateTime(firstDay.year, firstDay.month, j++);
      i++;
    }
    return dList;
  }

  void changeCursor(DateTime newCursor) {
    selected = newCursor;
    notifyListeners();
  }

  void plusMonth(bool plus) {
    if (plus) {
      selected = DateTime(selected.year, selected.month + 1, 1);
      notifyListeners();
    }
    else {
      selected = DateTime(selected.year, selected.month - 1, 1);
      notifyListeners();
    }
  }

  void plusWeek(bool plus) {
    if (plus) {
      selected = DateTime(selected.year, selected.month , selected.day + 7);
      notifyListeners();
    }
    else {
      selected = DateTime(selected.year, selected.month , selected.day - 7);
      notifyListeners();
    }
  }

  String returnAsString(){
    return DateFormat('yyyy.MM.dd').format(selected);
  }

  void changeIsMonth() {
    isMonth = !isMonth;
    notifyListeners();
  }
}