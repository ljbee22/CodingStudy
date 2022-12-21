import 'package:flutter/material.dart';
import 'package:my_calender/cursor.dart';
import 'calender_element.dart';

class EveryDay extends StatefulWidget {
  final Cursor cursor;
  final DateTime oneDay;
  final bool isSchedule = false; //일정 존재여부 관련 변수
  const EveryDay(this.cursor, this.oneDay, {Key? key}) : super(key: key);

  @override
  State<EveryDay> createState() => _EveryDayState();
}

class _EveryDayState extends State<EveryDay> {

  @override
  Widget build(BuildContext context) {
    return Expanded(child: GestureDetector(
      onTap: (){
        setState(() {
          widget.cursor.selected = widget.oneDay;
        });
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(0, 8, 0, 10),
        height: 50,
        child: widget.oneDay.month != widget.cursor.selected.month ? null : Stack(
          children: [
            Positioned(
              child: Container(
                child: MyText(widget.oneDay.day.toString(), 15),
              ),
            ),
            Positioned(
                top: 5,
                left: 25,
                child: Container(
                  height: 7,
                  width: 7,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFB6B9),
                    shape: BoxShape.circle,
                  )
                )
            )
          ],
        )
      ),
    ));
  }
}

