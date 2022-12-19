class GenerateDay{
  List<DateTime> daylist(DateTime cursor) {
    var firstday = DateTime(cursor.year, cursor.month,1);
    var dlist = List<DateTime>.filled(42,DateTime(0,0,0));
    dlist[firstday.weekday-1] = firstday;
    int i = firstday.weekday;
    int j = 2;
    while (i <= 41) {
      dlist[i] = DateTime(firstday.year, firstday.month, j++);
      i++;
    }
    return dlist;
  }
}

/*특정 요일을 대입 -> 그 요일이 속한 달의 첫번째 요일을 숫자로 리턴*/
int dayCal(int year, int month, int day){
  final firstDay = DateTime(year, month, 1);
  var firstDayVal = firstDay.weekday;
  int nthWeek = ((day+firstDayVal-2) ~/ 7) + 1;
  return nthWeek;
}
