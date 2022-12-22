import 'package:flutter/cupertino.dart';

class Cursor with ChangeNotifier{
  late DateTime selected;

  Cursor({
    required this.selected
  });

  /*특정 요일을 대입 -> 그 요일이 속한 달의 첫번째 요일을 숫자로 리턴*/
  int dayofweek(){
    final firstDay = DateTime(selected.year, selected.month, 1);
    var firstDayVal = firstDay.weekday;
    return ((selected.day+firstDayVal-2) ~/ 7) + 1;
  }

  List<DateTime> daylist() {
    DateTime firstday = DateTime(selected.year, selected.month,1);
    List<DateTime> dlist = List<DateTime>.filled(42,DateTime(0,0,0));
    int i = 0;
    int j = 2-firstday.weekday;
    while (i <= 41) {
      dlist[i] = DateTime(firstday.year, firstday.month, j++);
      i++;
    }
    return dlist;
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
}