import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:my_calender/cursor.dart';
import 'package:my_calender/customclass/palette.dart';
import 'package:provider/provider.dart';
import 'calenderElement.dart';

class OneDay extends StatefulWidget {
  final DateTime oneDay; //자기 자신
  final Box box;
  final bool isSchedule = false; //일정 존재여부 관련 변수
  const OneDay(this.oneDay, this.box, {Key? key}) : super(key: key);

  @override
  State<OneDay> createState() => _OneDayState();
}

class _OneDayState extends State<OneDay> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: GestureDetector(
          behavior:
          widget.oneDay.month != Provider.of<Cursor>(context).selected.month
              ? null
              : HitTestBehavior.translucent,
          onTap: () {
            Provider.of<Cursor>(context, listen: false).changeCursor(widget.oneDay);
          },
          child: Container(
              decoration: (Provider.of<Cursor>(context).selected.day ==
                  widget.oneDay.day) &&
                  (Provider.of<Cursor>(context).selected.month ==
                      widget.oneDay.month)
                  ? BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Pastel.grey, width: 0))
                  : null,
              padding: const EdgeInsets.fromLTRB(0, 4, 0, 10),
              height: 80,
              child:
              widget.oneDay.month != Provider.of<Cursor>(context).selected.month
                  ? null
                  : Stack(
                children: [
                  Positioned(
                    top: 1,
                    height: 20,
                    width: 20,
                    left: 3,
                    child: MyText(
                        widget.oneDay.day.toString(),
                        15,
                        widget.oneDay.weekday == 7
                            ? Pastel.redaccent
                            : Pastel.black),
                  ),
                  if (widget.box.containsKey(
                      DateFormat('yyyy.MM.dd').format(widget.oneDay)))
                    Positioned(
                        top: 7,
                        left: 30,
                        child: Container(
                            height: 7,
                            width: 7,
                            decoration: const BoxDecoration(
                              color: Pastel.red,
                              shape: BoxShape.circle,
                            ))),
                ],
              )),
        ));
  }
}
