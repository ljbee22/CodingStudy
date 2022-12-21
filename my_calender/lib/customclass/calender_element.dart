import 'package:flutter/material.dart';

class DayofWeek extends StatelessWidget {
  const DayofWeek({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        SizedBox(width: 2),
        Expanded(child:Text("월", textAlign: TextAlign.start, style: TextStyle(fontSize: 15, color: Color(0xff202020), fontWeight: FontWeight.w100),)),
        SizedBox(width: 2),
        Expanded(child:Text("화", textAlign: TextAlign.start, style: TextStyle(fontSize: 15, color: Color(0xff202020)),)),
        SizedBox(width: 2),
        Expanded(child:Text("수", textAlign: TextAlign.start, style: TextStyle(fontSize: 15, color: Color(0xff202020)),)),
        SizedBox(width: 2),
        Expanded(child:Text("목", textAlign: TextAlign.start, style: TextStyle(fontSize: 15, color: Color(0xff202020)),)),
        SizedBox(width: 2),
        Expanded(child:Text("금", textAlign: TextAlign.start, style: TextStyle(fontSize: 15, color: Color(0xff202020)),)),
        SizedBox(width: 2),
        Expanded(child:Text("토", textAlign: TextAlign.start, style: TextStyle(fontSize: 15, color: Color(0xff202020)),)),
        SizedBox(width: 2),
        Expanded(child:Text("일", textAlign: TextAlign.start, style: TextStyle(fontSize: 15, color: Color(0xffE84A5F)),)),
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
      textAlign: TextAlign.center,
      style: TextStyle(
          fontSize: fsize,
          color: const Color(0xff202020)
      ),
    );
  }
}

