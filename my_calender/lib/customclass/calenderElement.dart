import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_calender/cursor.dart';

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

class MyText extends StatelessWidget {
  final String t;
  final double fsize;
  const MyText(this.t, this.fsize, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      t,
      textAlign: TextAlign.center,
      style: TextStyle(
          fontSize: fsize,
          color: const Color(0xff202020),
        fontWeight: FontWeight.w300
      ),
    );
  }
}



class MonthAppbar extends StatelessWidget implements PreferredSizeWidget{
  final AppBar appbar;

  const MonthAppbar({Key? key, required this.appbar}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
        backgroundColor: const Color(0xFFFAE3D9),
        elevation: 0,
        title: MyText(
            "${Provider.of<Cursor>(context).selected.year}년 ${Provider.of<Cursor>(context).selected.month}월", 20
        ),
        actions: [
          IconButton(
            visualDensity: const VisualDensity(horizontal: -4.0),
            onPressed: () {
              Provider.of<Cursor>(context, listen: false).plusMonth(false);
            }, icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black54,),
            splashRadius: 20,
          ),
          IconButton(
              visualDensity: const VisualDensity(horizontal: -4.0),
              onPressed: () {
                Provider.of<Cursor>(context, listen: false).plusMonth(true);
              }, icon: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.black54)
          ),
          IconButton(
            visualDensity: const VisualDensity(horizontal: -4.0),
            onPressed: () {
              Provider.of<IsMonth>(context, listen: false).changeIsMonth();
            }, icon: const Icon(Icons.change_circle_rounded), color: Colors.black54,),
          IconButton(
            visualDensity: const VisualDensity(horizontal: -4.0),
            icon: const Icon(Icons.today, color: Colors.black54,),
            onPressed: () {
              Provider.of<Cursor>(context, listen: false).changeCursor(DateTime.now());
            },
          ),
        ]
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appbar.preferredSize.height);
}


class WeekAppbar extends StatelessWidget implements PreferredSizeWidget{
  final AppBar appbar;

  const WeekAppbar({Key? key, required this.appbar}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
        backgroundColor: const Color(0xFFFAE3D9),
        elevation: 0,
        title: MyText(
            "${Provider.of<Cursor>(context).selected.year}년 ${Provider.of<Cursor>(context).selected.month}월 "
                "${Provider.of<Cursor>(context).dayofweek()}주차", 20
        ),
        actions: [
          IconButton(
            visualDensity: const VisualDensity(horizontal: -4.0),
            onPressed: () {
              Provider.of<Cursor>(context, listen: false).plusWeek(false);
            }, icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black54,),
            splashRadius: 20,
          ),
          IconButton(
              visualDensity: const VisualDensity(horizontal: -4.0),
              onPressed: () {
                Provider.of<Cursor>(context, listen: false).plusWeek(true);
              }, icon: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.black54)
          ),
          IconButton(
            visualDensity: const VisualDensity(horizontal: -4.0),
            onPressed: () {
              Provider.of<IsMonth>(context, listen: false).changeIsMonth();
            }, icon: const Icon(Icons.change_circle_rounded), color: Colors.black54,),
          IconButton(
            visualDensity: const VisualDensity(horizontal: -4.0),
            icon: const Icon(Icons.today, color: Colors.black54,),
            onPressed: () {
              Provider.of<Cursor>(context, listen: false).changeCursor(DateTime.now());
            },
          ),
        ]
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appbar.preferredSize.height);
}


