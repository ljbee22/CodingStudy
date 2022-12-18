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