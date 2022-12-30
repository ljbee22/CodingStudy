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

class CalenderBanner extends StatelessWidget {
  const CalenderBanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      color: Pastel.pink,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(onPressed: () {
            Provider.of<Cursor>(context, listen: false).isMonth
                ? Provider.of<Cursor>(context, listen: false).plusMonth(false)
                : Provider.of<Cursor>(context, listen: false).plusWeek(false);
          },
            icon: Icon(Icons.arrow_back_rounded, size: 16,), color: Pastel.blacksoft,
          ),
          Provider.of<Cursor>(context, listen: false).isMonth
              ? MyText("${Provider.of<Cursor>(context).selected.year}년 ${Provider.of<Cursor>(context).selected.month}월", 17, Pastel.black)
              : MyText("${Provider.of<Cursor>(context).selected.year}년 ${Provider.of<Cursor>(context).selected.month}월 "
              "${Provider.of<Cursor>(context).dayofweek()}주차", 17, Pastel.black),
          IconButton(onPressed: () {
            Provider.of<Cursor>(context, listen: false).isMonth
                ? Provider.of<Cursor>(context, listen: false).plusMonth(true)
                : Provider.of<Cursor>(context, listen: false).plusWeek(true);
          },
            icon: Icon(Icons.arrow_forward_rounded, size: 16,), color: Pastel.blacksoft,
          ),
        ],
      ),
    );
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

class TodoBanner extends StatelessWidget {
  const TodoBanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // borderRadius: BorderRadius.only(topRight: Radius.circular(5), topLeft: Radius.circular(5)),
        border: Border(
            left: BorderSide(width: 1, style: BorderStyle.solid, color: Pastel.black),
            top: BorderSide(width: 1, style: BorderStyle.solid, color: Pastel.black),
            right: BorderSide(width: 1, style: BorderStyle.solid, color: Pastel.black),
        ),
      ),
      child: Text("할 일"),
    );
  }
}

