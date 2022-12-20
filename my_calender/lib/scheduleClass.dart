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