import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_calender/customclass/cursor.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

///************* main calender element **************///

//월화수목금 표시해주는 widget
class DayOfWeek extends StatelessWidget {
  const DayOfWeek({Key? key}) : super(key: key);

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

// isMonth 에 따라 N년 N월 N주차 를 표시해주는 widget
class CalenderBanner extends StatelessWidget {
  const CalenderBanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      decoration: const BoxDecoration(
        color: Pastel.pink,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(onPressed: () {
            Provider.of<Cursor>(context, listen: false).isMonth
                ? Provider.of<Cursor>(context, listen: false).plusMonth(false)
                : Provider.of<Cursor>(context, listen: false).plusWeek(false);
          },
            icon: const Icon(Icons.arrow_back_rounded, size: 16,), color: Pastel.blacksoft,
          ),
          Provider.of<Cursor>(context, listen: false).isMonth
              ? MyText(
              "${Provider.of<Cursor>(context).selected.year}년 ${Provider.of<Cursor>(context).selected.month}월",
              17,
              Pastel.black,
              FontWeight.w300
          )
              : MyText("${Provider.of<Cursor>(context).selected.year}년 ${Provider.of<Cursor>(context).selected.month}월 "
              "${Provider.of<Cursor>(context).dayOfWeek()}주차", 17, Pastel.black, FontWeight.w300),
          IconButton(onPressed: () {
            Provider.of<Cursor>(context, listen: false).isMonth
                ? Provider.of<Cursor>(context, listen: false).plusMonth(true)
                : Provider.of<Cursor>(context, listen: false).plusWeek(true);
          },
            icon: const Icon(Icons.arrow_forward_rounded, size: 16,), color: Pastel.blacksoft,
          ),
        ],
      ),
    );
  }
}

//Custom Text widget
class MyText extends StatelessWidget {
  final String t;
  final double fSize;
  final Color color;
  final FontWeight fontWeight;
  const MyText(this.t, this.fSize, this.color, this.fontWeight, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      t,
      textAlign: TextAlign.center,
      style: TextStyle(
          fontSize: fSize,
          color: color,
          fontWeight: fontWeight,
      ),
    );
  }
}

//아래 부분 "할 일" 텍스트를 띄우는 widget
class TodoBanner extends StatelessWidget {
  const TodoBanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MyText("할 일", 15, Pastel.black, FontWeight.w500);
  }
}

// 일자 "하나"를 표시해주는 widget (1일 단위)
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
          (widget.oneDay.month == Provider.of<Cursor>(context).selected.month) || !(Provider.of<Cursor>(context).isMonth)
              ? HitTestBehavior.translucent
              : null,
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
                border: Border.all(color: Pastel.grey, width: 0),
                color: Pastel.white,
              )
                  : null,
              padding: const EdgeInsets.fromLTRB(0, 4, 0, 10),
              height: 60,
              child:
              (widget.oneDay.month != Provider.of<Cursor>(context).selected.month) &&
                  (Provider.of<Cursor>(context, listen: false).isMonth)
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
                            : Pastel.black,
                        FontWeight.w300
                    ),
                  ),
                  if (widget.box.containsKey(DateFormat('yyyy.MM.dd').format(widget.oneDay)))
                    Positioned(
                      top: 5,
                      left: 28,
                      child: Container(
                        height: 13,
                        width: 13,
                        decoration: BoxDecoration(
                          color: Pastel.red,
                          borderRadius: BorderRadius.all(Radius.circular(3)),
                        ),
                        child: MyText(
                            widget.box.get(DateFormat('yyyy.MM.dd').format(widget.oneDay)).length.toString(),
                            10, Pastel.black, FontWeight.w500),
                      ),
                    ),
                ],
              )
          ),
        )
    );
  }
}

//주간 화면에서 일자 띄워주는 widget
class WeekColumn extends StatelessWidget {
  final Box box;
  const WeekColumn(this.box, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            for(int i = (Provider.of<Cursor>(context).dayOfWeek()-1) * 7 ;
            i < Provider.of<Cursor>(context).dayOfWeek() * 7; i++)
              OneDay(Provider.of<Cursor>(context).dayList()[i], box),
          ],
        ),
        const Divider(height: 0),
      ],
    );
  }
}

//월간 화면에서 일자 띄워주는 widget
class MonthColumn extends StatelessWidget {
  final Box box;
  const MonthColumn(this.box, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            for (int i = 0; i < 7; i++)
              OneDay(
                  Provider.of<Cursor>(context).dayList()[i],
                  box),
          ],
        ),
        const Divider(height: 0),
        Row(
          children: [
            for (int i = 7; i < 14; i++)
              OneDay(
                  Provider.of<Cursor>(context).dayList()[i],
                  box),
          ],
        ),
        const Divider(height: 0),
        Row(
          children: [
            for (int i = 14; i < 21; i++)
              OneDay(
                  Provider.of<Cursor>(context).dayList()[i],
                  box),
          ],
        ),
        const Divider(height: 0),
        Row(
          children: [
            for (int i = 21; i < 28; i++)
              OneDay(
                  Provider.of<Cursor>(context).dayList()[i],
                  box),
          ],
        ),
        const Divider(height: 0),
        if (Provider.of<Cursor>(context).dayList()[28].day > 8)
          Column(
            children: [
              Row(
                children: [
                  for (int i = 28; i < 35; i++)
                    OneDay(
                        Provider.of<Cursor>(context)
                            .dayList()[i],
                        box),
                ],
              ),
              const Divider(height: 0),
            ],
          ),
        if (Provider.of<Cursor>(context).dayList()[35].day > 8)
          Column(
            children: [
              Row(
                children: [
                  for (int i = 35; i < 42; i++)
                    OneDay(
                        Provider.of<Cursor>(context)
                            .dayList()[i],
                        box),
                ],
              ),
              const Divider(height: 0),
            ],
          ),
      ],
    );
  }
}

///************* appbar element **************///

//주간, 월간 화면에 모두 표시되는 최상위 appbar
class CustomAppbar extends StatelessWidget implements PreferredSize{
  final GlobalKey<ScaffoldState> scaffoldKey;
  const CustomAppbar({Key? key, required this.scaffoldKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      leading: IconButton(onPressed: () {
        scaffoldKey.currentState?.openDrawer();
      },
        icon: Icon(Icons.linear_scale, color: Pastel.blacksoft),
      ),
      title: Stack(
        children: [
          Positioned(
            right: 30,
            child: IconButton(
                alignment: Alignment.centerRight,
                visualDensity: const VisualDensity(horizontal: -4.0),
                onPressed: () {
                  Provider.of<Cursor>(context, listen: false).changeIsMonth();
                },
                icon: const Icon(Icons.change_circle_rounded), color: Pastel.blacksoft),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              alignment: Alignment.centerRight,
              visualDensity: const VisualDensity(horizontal: -4.0),
              icon: const Icon(Icons.today, color: Pastel.blacksoft,),
              onPressed: () {
                Provider.of<Cursor>(context, listen: false).changeCursor(DateTime.now());
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(40);

  @override
  // TODO: implement child : 몰라서 임시로 Container() 넣음
  Widget get child => Container();
}

// 최상위 appbar 와 같이 표시되는 drawer
class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Drawer(
      //TODO drawer 에 넣을 거 고민
      backgroundColor: Pastel.orange,
      child: Text('Hello'),
    );
  }
}

///*************bottom sheet element**************///

//bottomSheet 의 토글 버튼
class CustomToggle extends StatefulWidget {
  final bool isRight;
  const CustomToggle(this.isRight, {Key? key}) : super(key: key);

  @override
  State<CustomToggle> createState() => _CustomToggleState();
}
class _CustomToggleState extends State<CustomToggle> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      width: 55,
      height: 30,
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: !widget.isRight? Colors.grey : Colors.green,
      ),
      child: AnimatedAlign(
          alignment: !widget.isRight ? Alignment.centerLeft : Alignment.centerRight,
          duration: const Duration(milliseconds: 200),
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Container(
              width: 25,
              height: 25,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),
          )
      ),
    );
  }
}

///************* color palette **************///

class Pastel {
  static const Color black = Color(0xff373640);
  static const Color red = Color(0xffFFB6B9);
  static const Color pinkaccent = Color(0xffFCCEE2);
  static const Color pink = Color(0xffFAE3D9);
  static const Color bluegreen = Color(0xffBBDED6);
  static const Color sky = Color(0xff88d4ff);
  static const Color purple = Color(0xffBFCFFF);
  static const Color yellow = Color(0xffFFFFC2);
  static const Color orange = Color(0xffFECEA8);
  static const Color redaccent = Color(0xffE84A5F);
  static const Color grey = Color(0xff7E97A6);
  static const Color blacksoft = Color(0xff63686E);
  static const Color yellowsoft = Color(0xfffffbe7);
  static const Color green = Color(0xffd5dc92);
  static const Color white = Color(0xfff4efeb);
  static const Color test = Color(0xffd5dc92);
}