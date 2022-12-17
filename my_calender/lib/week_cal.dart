import 'package:flutter/material.dart';

/*특정 요일을 대입 -> 그 요일이 속한 달의 첫번째 요일을 숫자로 리턴*/
int dayCal(int year, int month, int day){
  final firstDay = DateTime(year, month, 1);
  var firstDayVal = firstDay.weekday;
  int nthWeek = ((day+firstDayVal-2) ~/ 7) + 1;
  return nthWeek;
}

var now = DateTime.now();
var nowMonth = now.month;
var today = dayCal(now.year, now.month, now.day);


class WeekCal extends StatefulWidget {
  const WeekCal({Key? key}) : super(key: key);

  @override
  State<WeekCal> createState() => _WeekCalState();
}

class _WeekCalState extends State<WeekCal> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF26C6C),
        title: Text(
          "$nowMonth월 $today주차"
        ),
      ),
      body: Column(
        children: [
          Row(
            children: const [
              Expanded(child: Text("월", textAlign: TextAlign.center,)),
              Expanded(child: Text("화", textAlign: TextAlign.center,)),
              Expanded(child: Text("수", textAlign: TextAlign.center,)),
              Expanded(child: Text("목", textAlign: TextAlign.center,)),
              Expanded(child: Text("금", textAlign: TextAlign.center,)),
              Expanded(child: Text("토", textAlign: TextAlign.center,)),
              Expanded(child: Text("일", textAlign: TextAlign.center,)),
            ],
          ), //요일 표시 -> 항상 고정
          Row(
            children: [
              Expanded(child: Container(
                // height: 30,
                child: Text("1",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 21,
                ),),
              )),
            ],
          ),
          Row(),
          Row(),
          Row(),
          Row(),
          // if(week > 5)
          Row(),
        ],
      ),
    );
  }
}
