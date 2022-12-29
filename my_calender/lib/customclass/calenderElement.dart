import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_calender/cursor.dart';
import 'package:my_calender/customclass/palette.dart';

class DayofWeek extends StatelessWidget {
  const DayofWeek({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          SizedBox(width: 5),
          Expanded(child:Text("월", textAlign: TextAlign.start, style: TextStyle(fontSize: 15, color: Pastel.black, fontWeight: FontWeight.w100),)),
          SizedBox(width: 5),
          Expanded(child:Text("화", textAlign: TextAlign.start, style: TextStyle(fontSize: 15, color: Pastel.black),)),
          SizedBox(width: 5),
          Expanded(child:Text("수", textAlign: TextAlign.start, style: TextStyle(fontSize: 15, color: Pastel.black),)),
          SizedBox(width: 5),
          Expanded(child:Text("목", textAlign: TextAlign.start, style: TextStyle(fontSize: 15, color: Pastel.black),)),
          SizedBox(width: 5),
          Expanded(child:Text("금", textAlign: TextAlign.start, style: TextStyle(fontSize: 15, color: Pastel.black),)),
          SizedBox(width: 5),
          Expanded(child:Text("토", textAlign: TextAlign.start, style: TextStyle(fontSize: 15, color: Pastel.black),)),
          SizedBox(width: 5),
          Expanded(child:Text("일", textAlign: TextAlign.start, style: TextStyle(fontSize: 15, color: Pastel.redaccent),)),
        ],
      ),
    ); //요일 표시 -> 항상 고정
  }
}

class MyText extends StatelessWidget {
  final String t;
  final double fsize;
  final Color color;
  const MyText(this.t, this.fsize, this.color, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      t,
      textAlign: TextAlign.center,
      style: TextStyle(
          fontSize: fsize,
          color: color,
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
        backgroundColor: Pastel.pink,
        elevation: 0,
        title: MyText(
            "${Provider.of<Cursor>(context).selected.year}년 ${Provider.of<Cursor>(context).selected.month}월", 20, Pastel.black
        ),
        actions: [
          IconButton(
            visualDensity: const VisualDensity(horizontal: -4.0),
            onPressed: () {
              Provider.of<Cursor>(context, listen: false).plusMonth(false);
            }, icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Pastel.blacksoft,),
            splashRadius: 20,
          ),
          IconButton(
              visualDensity: const VisualDensity(horizontal: -4.0),
              onPressed: () {
                Provider.of<Cursor>(context, listen: false).plusMonth(true);
              }, icon: const Icon(Icons.arrow_forward_ios_rounded, color: Pastel.blacksoft)
          ),
          IconButton(
            visualDensity: const VisualDensity(horizontal: -4.0),
            onPressed: () {
              Provider.of<Cursor>(context, listen: false).changeIsMonth();
            }, icon: const Icon(Icons.change_circle_rounded), color: Pastel.blacksoft),
          IconButton(
            visualDensity: const VisualDensity(horizontal: -4.0),
            icon: const Icon(Icons.today, color: Pastel.blacksoft,),
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
        backgroundColor: Pastel.pink,
        elevation: 0,
        title: MyText(
            "${Provider.of<Cursor>(context).selected.year}년 ${Provider.of<Cursor>(context).selected.month}월 "
                "${Provider.of<Cursor>(context).dayofweek()}주차", 20, Pastel.black,
        ),
        actions: [
          IconButton(
            visualDensity: const VisualDensity(horizontal: -4.0),
            onPressed: () {
              Provider.of<Cursor>(context, listen: false).plusWeek(false);
            }, icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Pastel.blacksoft,),
            splashRadius: 20,
          ),
          IconButton(
              visualDensity: const VisualDensity(horizontal: -4.0),
              onPressed: () {
                Provider.of<Cursor>(context, listen: false).plusWeek(true);
              }, icon: const Icon(Icons.arrow_forward_ios_rounded, color: Pastel.blacksoft)
          ),
          IconButton(
            visualDensity: const VisualDensity(horizontal: -4.0),
            onPressed: () {
              Provider.of<Cursor>(context, listen: false).changeIsMonth();
            }, icon: const Icon(Icons.change_circle_rounded), color: Pastel.blacksoft,),
          IconButton(
            visualDensity: const VisualDensity(horizontal: -4.0),
            icon: const Icon(Icons.today, color: Pastel.blacksoft,),
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


