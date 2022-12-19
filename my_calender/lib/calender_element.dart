import 'package:flutter/material.dart';
import 'package:my_calender/text.dart';

class DayofWeek extends StatelessWidget {
  const DayofWeek({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
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
    ); //요일 표시 -> 항상 고정
  }
}

class DivBox extends StatelessWidget {
  const DivBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Divider(
          indent: 5.0,
          endIndent: 5.0,
          height: 0,
        ),
        SizedBox(
          height: 8.0,
        ),
      ],
    );
  }
}

