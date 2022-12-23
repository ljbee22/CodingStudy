import 'package:flutter/material.dart';
import 'package:my_calender/cursor.dart';
import 'calenderElement.dart';
import 'package:provider/provider.dart';

class MonthDays extends StatefulWidget {
  final DateTime oneDay; //자기 자신
  final bool isSchedule = false; //일정 존재여부 관련 변수
  const MonthDays(this.oneDay, {Key? key}) : super(key: key);

  @override
  State<MonthDays> createState() => _MonthDaysState();
}

class _MonthDaysState extends State<MonthDays> {

  @override
  Widget build(BuildContext context) {
    return Expanded(child: GestureDetector(
      behavior: widget.oneDay.month != Provider.of<Cursor>(context).selected.month ? null : HitTestBehavior.translucent,
      onTap: (){
        Provider.of<Cursor>(context, listen: false).changeCursor(widget.oneDay);
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(0, 4, 0, 10),
        height: 50,
        child: widget.oneDay.month != Provider.of<Cursor>(context).selected.month ? null : Stack(
          children: [
            Positioned(
                // left: 0.95,
                child: Container(
                    height: 20,
                    width: 20,
                    decoration: Provider.of<Cursor>(context).selected.day == widget.oneDay.day ?  const BoxDecoration(
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




class WeekDays extends StatefulWidget {
  final DateTime oneDay; //자기 자신
  final bool isSchedule = false; //일정 존재여부 관련 변수
  const WeekDays(this.oneDay, {Key? key}) : super(key: key);

  @override
  State<WeekDays> createState() => _WeekDaysState();
}

class _WeekDaysState extends State<WeekDays> {
  @override
  Widget build(BuildContext context) {
    return Expanded(child: GestureDetector(
      onTap: (){
        Provider.of<Cursor>(context, listen: false).changeCursor(widget.oneDay);
      },
      child: Container(
          padding: const EdgeInsets.fromLTRB(0, 4, 0, 10),
          height: 50,
          child: Stack(
            children: [
              Positioned(
                // left: 0.95,
                  child: Container(
                      height: 20,
                      width: 20,
                      decoration: Provider.of<Cursor>(context).selected.day == widget.oneDay.day ?  const BoxDecoration(
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


