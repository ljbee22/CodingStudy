import 'package:flutter/material.dart';

class DayofWeek extends StatelessWidget {
  const DayofWeek({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
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
      ],
    );
  }
}

class MyText extends StatelessWidget {
  String t;
  double fsize;
  MyText(this.t, this.fsize, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      t,
      textAlign: TextAlign.start,
      style: TextStyle(
          fontSize: fsize,
          color: const Color(0xff202020)
      ),
    );
  }
}

