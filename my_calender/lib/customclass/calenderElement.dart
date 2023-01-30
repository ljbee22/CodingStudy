import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_calender/customclass/cursor.dart';
import 'package:my_calender/customclass/hiveClass.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Path {
  final settingBox = Hive.box('setting');
  final libBox = Hive.box<List>('Box');
}

///****************** default sizes ********************///

class MyForm {
  final List<String> weekList = ['일', '월', '화', '수', '목', '금', '토', '일'];
  final double appBarIconSize = 30;
  final double calenderTextSize = 15;
}

///************* main calender element **************///

//월화수목금 표시해주는 widget
class DayOfWeek extends StatelessWidget {
  final Box settingBox;
  const DayOfWeek({Key? key, required this.settingBox}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int tmp = settingBox.get('defaultSetting').isSunday ? 0 : 1;
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for(int i = tmp; i < MyForm().weekList.length - 1 + tmp; i++)
          Expanded(
              child:Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Text(
                MyForm().weekList[i],
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontSize: MyForm().calenderTextSize,
                    color: i == 0 || i == 7 ? Pastel.redaccent : Pastel.black,
                    fontWeight: FontWeight.w100
                ),
              ),
          )),
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
            icon: const ImageIcon(AssetImage('assets/icon/left_arrow.png'), size: 16,), color: Pastel.blacksoft,
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
            icon: const ImageIcon(AssetImage('assets/icon/right_arrow.png'), size: 16,), color: Pastel.blacksoft,
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
          child: Padding(
            padding: const EdgeInsets.only(right: 1.0),
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
                padding: const EdgeInsets.fromLTRB(0, 4, 0, 5),
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
                              decoration: const BoxDecoration(
                                color: Pastel.red,
                                borderRadius: BorderRadius.all(Radius.circular(3)),
                              ),
                              child: MyText(
                                  widget.box.get(DateFormat('yyyy.MM.dd').format(widget.oneDay)).length.toString(),
                                  10, Pastel.black, FontWeight.w500),
                            ),
                        ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: 30,
                          height: 30,
                          // color: Pastel.red,
                          child: Image.asset('assets/icon/sprout.png'),
                        ),
                      )
                  ],
                )
            ),
          ),
        )
    );
  }
}

//주간 화면에서 일자 띄워주는 widget
class WeekColumn extends StatelessWidget {
  final Box box;
  final Box settingbox;
  const WeekColumn(this.box, this.settingbox, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List tmpList = Provider.of<Cursor>(context).dayList(settingbox.get('defaultSetting'));
    return Column(
      children: [
        Row(
          children: [
            for(int i = (Provider.of<Cursor>(context).dayOfWeek()-1) * 7 ;
            i < Provider.of<Cursor>(context).dayOfWeek() * 7; i++)
              OneDay(tmpList[i], box),
          ],
        ),
        const Divider(height: 1, thickness: 1),
      ],
    );
  }
}

//월간 화면에서 일자 띄워주는 widget
class MonthColumn extends StatelessWidget {
  final Box box;
  final Box settingBox;
  const MonthColumn(this.box, this.settingBox, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List tmpList = Provider.of<Cursor>(context).dayList(settingBox.get('defaultSetting')); // TODO 수정
    return Column(
      children: [
        if(tmpList[6].month == Provider.of<Cursor>(context).selected.month)
        Row(
          children: [
            for (int i = 0; i < 7; i++)
              OneDay(tmpList[i], box),
          ],
        ),
        const Divider(height: 0),
        Row(
          children: [
            for (int i = 7; i < 14; i++)
              OneDay(tmpList[i], box),
          ],
        ),
        const Divider(height: 0),
        Row(
          children: [
            for (int i = 14; i < 21; i++)
              OneDay(tmpList[i], box),
          ],
        ),
        const Divider(height: 0),
        Row(
          children: [
            for (int i = 21; i < 28; i++)
              OneDay(tmpList[i], box),
          ],
        ),
        const Divider(height: 0),
        if (tmpList[28].day > 8)
          Column(
            children: [
              Row(
                children: [
                  for (int i = 28; i < 35; i++)
                    OneDay(tmpList[i], box),
                ],
              ),
              const Divider(height: 0),
            ],
          ),
        if (tmpList[35].day > 8)
          Column(
            children: [
              Row(
                children: [
                  for (int i = 35; i < 42; i++)
                    OneDay(tmpList[i], box),
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
      leading: IconButton(
        padding: const EdgeInsets.only(left: 15),
        onPressed: () {
        scaffoldKey.currentState?.openDrawer();
        },
        icon: ImageIcon(AssetImage("assets/icon/drawer.png"), color: Pastel.blacksoft, size: MyForm().appBarIconSize),
      ),
      title: Stack(
        children: [
          Positioned(
            right: 40,
            child: IconButton(
                onPressed: () {
                  Provider.of<Cursor>(context, listen: false).changeIsMonth();
                },
                icon: ImageIcon(AssetImage("assets/icon/move.png"), color: Pastel.blacksoft, size: MyForm().appBarIconSize)
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              alignment: Alignment.centerRight,
              icon: ImageIcon(AssetImage("assets/icon/Home.png"), color: Pastel.blacksoft, size: MyForm().appBarIconSize),
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
  Size get preferredSize => const Size.fromHeight(50);

  @override
  // TODO: implement child : 몰라서 임시로 Container() 넣음
  Widget get child => Container();
}

// 최상위 appbar 와 같이 표시되는 drawer
class CustomDrawer extends StatefulWidget {
  const CustomDrawer({Key? key}) : super(key: key);
  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Pastel.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 100,
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: Pastel.yellow,
              ),
                child: Text('설정')
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
            height: 40,
            child: Row(
              children: [
                SizedBox(width: 15,),
                const Text("시작 요일 설정"),
                const Spacer(),
                CustomToggle(Path().settingBox),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
            height: 40,
            child: Row(
              children: [
                SizedBox(width: 15,),
                const Text("컬러 테마"),
                const Spacer(),
                CustomToggle(Path().settingBox),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
            height: 40,
            child: Row(
              children: [
                SizedBox(width: 15,),
                const Text("폰트 변경"),
                const Spacer(),
                CustomToggle(Path().settingBox),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1),
        ],
      ),
    );
  }
}

// Drawer 의 토글버튼
class CustomToggle extends StatefulWidget {
  final Box settingBox;
  const CustomToggle(this.settingBox, {Key? key}) : super(key: key);

  @override
  State<CustomToggle> createState() => _CustomToggleState();
}

class _CustomToggleState extends State<CustomToggle> {
  late List<bool> sundayMonday;

  @override
  void initState() {
    sundayMonday = [!widget.settingBox.get('defaultSetting').isSunday, widget.settingBox.get('defaultSetting').isSunday];
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            SettingClass temp = Path().settingBox.get('defaultSetting');
            print(temp.isSunday);
              setState(() {
                sundayMonday[0] = true;
                sundayMonday[1] = false;
                Path().settingBox.put('defaultSetting', temp.sunday(false));
              });
            },
          child: Container(
            padding: EdgeInsets.all(5),
            child: Text('월요일'),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Pastel.black, width: 0),
              color: sundayMonday[0] ? Pastel.purple : Pastel.white,
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            SettingClass temp = Path().settingBox.get('defaultSetting');
            print(temp.isSunday);
            setState(() {
              sundayMonday[0] = false;
              sundayMonday[1] = true;
              Path().settingBox.put('defaultSetting', temp.sunday(true));
            });
          },
          child: Container(
            padding: EdgeInsets.all(5),
            child: Text('일요일'),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Pastel.black, width: 0),
              color: sundayMonday[1] ? Pastel.purple : Pastel.white,
            ),
          ),
        ),
      ],
    );
  }
}


///*************bottom sheet element**************///

//bottomSheet 의 온오프 버튼
class CustomOnOff extends StatefulWidget {
  final bool isRight;
  const CustomOnOff(this.isRight, {Key? key}) : super(key: key);

  @override
  State<CustomOnOff> createState() => _CustomOnOffState();
}
class _CustomOnOffState extends State<CustomOnOff> {
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
  static const Color sky = Color(0xffD5F7FF);
  static const Color purple = Color(0xffBFCFFF);
  static const Color yellow = Color(0xffFFF1BC);
  static const Color orange = Color(0xffFECEA8);
  static const Color redaccent = Color(0xffE84A5F);
  static const Color grey = Color(0xff7E97A6);
  static const Color blacksoft = Color(0xff63686E);
  static const Color yellowsoft = Color(0xfffffbe7);
  static const Color green = Color(0xffd5dc92);
  static const Color white = Color(0xfff4efeb);
  static const Color test = Color(0xffd5dc92);
}

///*************** font list *****************///

List fontList = ["Myfont"];