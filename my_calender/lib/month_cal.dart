import 'package:flutter/material.dart';
import 'cursor.dart';
import 'customclass/calender_element.dart';
import 'package:hive_flutter/hive_flutter.dart';

// var now = DateTime.now();
Cursor cursor = Cursor(selected: DateTime.now());
List<DateTime> daylist = cursor.daylist();

class MonthCal extends StatefulWidget {
  const MonthCal({Key? key}) : super(key: key);

  @override
  State<MonthCal> createState() => _MonthCalState();
}

class _MonthCalState extends State<MonthCal> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAE3D9),
        elevation: 0,
        title: MyText(
            "${cursor.selected.month}월 ${cursor.dayofweek()}주차", 22
        )
      ),
      body: Column(
        children: [
          const DayofWeek(),
          const DivBox(),
          Row(
            children: [
              for(int i = 0; i<7; i++)
                Expanded(child: Container(
                  height: 40,
                  child: daylist[i].month != cursor.selected.month ? null : MyText(daylist[i].day.toString(), 15),
                )),
            ],
          ),
          const DivBox(),
          Row(
            children: [
              for(int i = 7; i<14; i++)
              Expanded(child: Container(
                height: 40,
                child: MyText(daylist[i].day.toString(), 15),
              )),
            ],
          ),
          const DivBox(),
          Row(
            children: [
              for(int i = 14; i<21; i++)
              Expanded(child: Container(
                height: 40,
                child: MyText(daylist[i].day.toString(), 15),
              )),
            ],
          ),
          const DivBox(),
          Row(
            children: [
              for(int i = 21; i<28; i++)
                Expanded(child: Container(
                  height: 40,
                  child: MyText(daylist[i].day.toString(), 15),
                )),
            ],
          ),
          const DivBox(),
          if(daylist[28].day > 8)
          Column(
            children: [
              Row(
                children: [
                  for(int i = 28; i<35; i++)
                    Expanded(child: Container(
                      height: 40,
                      child: daylist[i].month != cursor.selected.month  ? null : MyText(daylist[i].day.toString(), 15),
                    )),
                ],
              ),
              const DivBox(),
            ],
          ),
          if(daylist[35].day > 8)
          Column(
            children: [
              Row(
                children: [
                  for(int i = 35; i<42; i++)
                    Expanded(child: Container(
                      height: 40,
                      child: daylist[i].month != cursor.selected.month ? null : MyText(daylist[i].day.toString(), 15),
                    )),
                ],
              ),
              const Divider(height: 0),
            ],
          ),

          FloatingActionButton(onPressed: () {
            setState(() {
              cursor.selected = DateTime(2021,2,1);
            });
            // var libBox = await Hive.openBox("lib");
            // // libBox.put('now', cursor.month);
            // var a = libBox.get('now');
            // print(a);
          })
        ],
      ),
    );
  }
}
