import 'package:flutter/material.dart';
import 'package:my_calender/cursor.dart';
import 'calender_element.dart';

class EveryDay extends StatefulWidget {
  final Cursor cursor;
  final DateTime oneDay;
  final bool isSchedule = false; //일정 존재여부 관련 변수
  EveryDay(this.cursor, this.oneDay, {Key? key}) : super(key: key);

  @override
  State<EveryDay> createState() => _EveryDayState();
}

class _EveryDayState extends State<EveryDay> {

  @override
  Widget build(BuildContext context) {
    return Expanded(child: GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: (){
        setState(() {
          widget.cursor.selected = widget.oneDay;
        });
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(0, 4, 0, 10),
        height: 50,
        child: widget.oneDay.month != widget.cursor.selected.month ? null : Stack(
          children: [
            Positioned(
                // left: 0.95,
                child: Container(
                    height: 20,
                    width: 20,
                    decoration: widget.cursor.selected == widget.oneDay ?  const BoxDecoration(
                      color: Color(0xFFBBDED6),
                      shape: BoxShape.circle,
                    ) : null
                )
            ),
            Positioned(
              top: 1,
              height: 15,
              width: 20,
              child: MyText(widget.oneDay.day.toString(), 15),
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
            ),
            // Positioned(
            //     child: Icon,
            // )
          ],
        )
      ),
    ));
  }
}

