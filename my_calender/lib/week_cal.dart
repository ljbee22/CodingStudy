import 'package:flutter/material.dart';
import 'text.dart';

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
        backgroundColor: const Color(0xFFFAE3D9),
        elevation: 0,
        title: MyText(
            "$nowMonth월 $today주차", 22
        )
      ),
      body: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: MyText("월", 15)),
              Expanded(child: MyText("화", 15)),
              Expanded(child: MyText("수", 15)),
              Expanded(child: MyText("목", 15)),
              Expanded(child: MyText("금", 15)),
              Expanded(child: MyText("토", 15)),
              Expanded(child: MyText("일", 15)),
            ],
          ), //요일 표시 -> 항상 고정
          const Divider(
            height: 0,
          ),
          Row(
            children: [
              Expanded(child: Container(
                height: 40,
                child: MyText("1", 15),
              )),
              Expanded(child: Container(
                  height: 40,
                  child: MyText("1", 15)
              )),
              Expanded(child: Container(
                  height: 40,
                  child: MyText("1", 15)
              )),
              Expanded(child: Container(
                  height: 40,
                  child: MyText("1", 15)
              )),
              Expanded(child: Container(
                  height: 40,
                  child: MyText("1", 15)
              )),
              Expanded(child: Container(
                  height: 40,
                  child: MyText("1", 15)
              )),
              Expanded(child: Container(
                  height: 40,
                  child: MyText("1", 15)
              )),
            ],
          ),
          Row(
            children: [
              Expanded(child: Container(
                  height: 40,
                  child: MyText("1", 15)
              )),
              Expanded(child: Container(
                  height: 40,
                  child: MyText("1", 15)
              )),
              Expanded(child: Container(
                  height: 40,
                  child: MyText("1", 15)
              )),
              Expanded(child: Container(
                  height: 40,
                  child: MyText("1", 15)
              )),
              Expanded(child: Container(
                  height: 40,
                  child: MyText("1", 15)
              )),
              Expanded(child: Container(
                  height: 40,
                  child: MyText("1", 15)
              )),
              Expanded(child: Container(
                  height: 40,
                  child: MyText("1", 15)
              )),
            ],
          ),
          Row(
            children: [
              Expanded(child: Container(
                  height: 40,
                  child: MyText("1", 15)
              )),
              Expanded(child: Container(
                  height: 40,
                  child: MyText("1", 15)
              )),
              Expanded(child: Container(
                  height: 40,
                  child: MyText("1", 15)
              )),
              Expanded(child: Container(
                  height: 40,
                  child: MyText("1", 15)
              )),
              Expanded(child: Container(
                  height: 40,
                  child: MyText("1", 15)
              )),
              Expanded(child: Container(
                  height: 40,
                  child: MyText("1", 15)
              )),
              Expanded(child: Container(
                  height: 40,
                  child: MyText("1", 15)
              )),
            ],
          ),
          Row(
            children: [
              Expanded(child: Container(
                  height: 40,
                  child: MyText("1", 15)
              )),
              Expanded(child: Container(
                  height: 40,
                  child: MyText("1", 15)
              )),
              Expanded(child: Container(
                  height: 40,
                  child: MyText("1", 15)
              )),
              Expanded(child: Container(
                  height: 40,
                  child: MyText("1", 15)
              )),
              Expanded(child: Container(
                  height: 40,
                  child: MyText("1", 15)
              )),
              Expanded(child: Container(
                  height: 40,
                  child: MyText("1", 15)
              )),
              Expanded(child: Container(
                  height: 40,
                  child: MyText("1", 15)
              )),
            ],
          ),
          Row(
            children: [
              Expanded(child: Container(
                  height: 40,
                  child: MyText("1", 15)
              )),
              Expanded(child: Container(
                  height: 40,
                  child: MyText("1", 15)
              )),
              Expanded(child: Container(
                  height: 40,
                  child: MyText("1", 15)
              )),
              Expanded(child: Container(
                  height: 40,
                  child: MyText("1", 15)
              )),
              Expanded(child: Container(
                  height: 40,
                  child: MyText("1", 15)
              )),
              Expanded(child: Container(
                  height: 40,
                  child: MyText("1", 15)
              )),
              Expanded(child: Container(
                  height: 40,
                  child: MyText("1", 15)
              )),
            ],
          ),
          // if(week > 5)
          Row(
            children: [
              Expanded(child: Container(
                  height: 40,
                  child: MyText("1", 15)
              )),
              Expanded(child: Container(
                  height: 40,
                  child: MyText("1", 15)
              )),
              Expanded(child: Container(
                  height: 40,
                  child: MyText("1", 15)
              )),
              Expanded(child: Container(
                  height: 40,
                  child: MyText("1", 15)
              )),
              Expanded(child: Container(
                  height: 40,
                  child: MyText("1", 15)
              )),
              Expanded(child: Container(
                  height: 40,
                  child: MyText("1", 15)
              )),
              Expanded(child: Container(
                  height: 40,
                  child: MyText("1", 15)
              )),
            ],
          ),
          Row(
            children: [
              Expanded(child: Container(
                  height: 40,
                  child: MyText("1", 15)
              )),
              Expanded(child: Container(
                  height: 40,
                  child: MyText("1", 15)
              )),
              Expanded(child: Container(
                  height: 40,
                  child: MyText("1", 15)
              )),
              Expanded(child: Container(
                  height: 40,
                  child: MyText("1", 15)
              )),
              Expanded(child: Container(
                  height: 40,
                  child: MyText("1", 15)
              )),
              Expanded(child: Container(
                  height: 40,
                  child: MyText("1", 15)
              )),
              Expanded(child: Container(
                  height: 40,
                  child: MyText("1", 15)
              )),
            ],
          ),
        ],
      ),
    );
  }
}
