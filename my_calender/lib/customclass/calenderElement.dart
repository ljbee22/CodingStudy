import 'dart:math';
import 'package:flutter/cupertino.dart';
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
  final List<String> weekList = [' 일', ' 월', ' 화', ' 수', ' 목', ' 금', ' 토', ' 일'];
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
  final Box settingBox;
  const CalenderBanner({Key? key, required this.settingBox}) : super(key: key);

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
              "${Provider.of<Cursor>(context).dayOfWeek(settingBox.get('defaultSetting'))}주차", 17, Pastel.black, FontWeight.w300),
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
  final Box settingBox;
  final bool isSchedule = false; //일정 존재여부 관련 변수
  const OneDay(this.oneDay, this.box, this.settingBox, {Key? key}) : super(key: key);

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
                padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
                height: 70,
                child:
                (widget.oneDay.month != Provider.of<Cursor>(context).selected.month) &&
                    (Provider.of<Cursor>(context, listen: false).isMonth)
                    ? null
                    : Stack(
                  children: [
                    Positioned(
                      top: 1,
                      height: 20,
                      width: 25,
                      left: 3,
                      child: MyText(
                          widget.oneDay.day.toString(),
                          14,
                          widget.oneDay.weekday == 7
                              ? Pastel.redaccent
                              : Pastel.black,
                          FontWeight.w300
                      ),
                    ),
                    if (widget.box.containsKey(DateFormat('yyyy.MM.dd').format(widget.oneDay)))
                      Positioned(
                        top: 3,
                        left: 29,
                        child: Container(
                          height: 13,
                          width: 13,
                          alignment: Alignment.center,
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
                        width: 45,
                        height: 45,
                        child: Image.asset(widget.settingBox.get(DateFormat('yyyy.MM.dd').format(widget.oneDay)) ?? Emoticon.transparent),
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
  final Box settingBox;
  const WeekColumn(this.box, this.settingBox, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List tmpList = Provider.of<Cursor>(context).dayList(settingBox.get('defaultSetting'));
    return Column(
      children: [
        Row(
          children: [
            for(int i = (Provider.of<Cursor>(context).dayOfWeek(settingBox.get('defaultSetting'))-1) * 7 ;
            i < Provider.of<Cursor>(context).dayOfWeek(settingBox.get('defaultSetting')) * 7; i++)
              OneDay(tmpList[i], box, settingBox),
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
                OneDay(tmpList[i], box, settingBox),
            ],
          ),
        const Divider(height: 0),
        Row(
          children: [
            for (int i = 7; i < 14; i++)
              OneDay(tmpList[i], box, settingBox),
          ],
        ),
        const Divider(height: 0),
        Row(
          children: [
            for (int i = 14; i < 21; i++)
              OneDay(tmpList[i], box, settingBox),
          ],
        ),
        const Divider(height: 0),
        Row(
          children: [
            for (int i = 21; i < 28; i++)
              OneDay(tmpList[i], box, settingBox),
          ],
        ),
        const Divider(height: 0),
        if (tmpList[28].day > 8)
          Column(
            children: [
              Row(
                children: [
                  for (int i = 28; i < 35; i++)
                    OneDay(tmpList[i], box, settingBox),
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
                    OneDay(tmpList[i], box, settingBox),
                ],
              ),
              const Divider(height: 0),
            ],
          ),
      ],
    );
  }
}

///************* Emoticon Add element *****************///

class DailyEmoticon extends StatelessWidget {
  final Box settingBox;
  const DailyEmoticon({required this.settingBox, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String scheduleDate = Provider.of<Cursor>(context).returnAsString();
    return Column(
      children: [
        const SizedBox(height: 7),
        Row(
          children: [
            const SizedBox(width: 20), // 좌측 padding
            GestureDetector(
              onTap: () {
                showDialog(
                    barrierColor: Colors.transparent,
                    context: context,
                    barrierDismissible: true,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        elevation: 1,
                        contentPadding: const EdgeInsets.fromLTRB(10,10,10,10),
                        backgroundColor: Pastel.white,
                        insetPadding: const EdgeInsets.fromLTRB(30,60,30,100),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(color: Pastel.grey)
                        ),
                        content: SizedBox(
                          height: 130,
                          child: CupertinoScrollbar(
                            thickness: 3.0,
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Column(
                                children: [
                                  for(int i = 0; i < (Emoticon().emoticonList().length ~/ 4) + 1; i++)
                                    Row(
                                      children: [
                                        for(int j = i * 4; j < min(i*4+4, Emoticon().emoticonList().length); j++)
                                          GestureDetector(
                                            onTap: (){
                                              if(Emoticon().emoticonList()[j] == Emoticon.blank){
                                                settingBox.delete(scheduleDate);
                                              }
                                              else{
                                                settingBox.put(scheduleDate, Emoticon().emoticonList()[j]);
                                              }
                                              Navigator.pop(context);
                                            },
                                            child: Container(
                                              height: 70,
                                              padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                                              child: Image.asset(Emoticon().emoticonList()[j]),
                                            ),
                                          ),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                );
              },
              child: SizedBox(
                height: 80,
                child: Image.asset(settingBox.get(scheduleDate) ?? Emoticon.plus),
              ),
            ),
            const SizedBox(width: 25),
            Container(
              width: 220,
              height: 70,
              decoration: const BoxDecoration(
                  border: Border(
                    left: BorderSide(color: Pastel.grey, width: 0.5),
                  )
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(25, 0, 5, 0),
                child: TextButton(
                  onPressed: () {
                    showDialog(
                        barrierColor: Colors.transparent,
                        context: context,
                        barrierDismissible: true,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            elevation: 1,
                            contentPadding: const EdgeInsets.fromLTRB(10,10,10,10),
                            backgroundColor: Pastel.yellowsoft,
                            insetPadding: const EdgeInsets.fromLTRB(40,260,40,90),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: const BorderSide(color: Pastel.grey)
                            ),
                            content: SizedBox(
                              height: 70,
                              width: 200,
                              child: TextFormField(
                                autofocus: true,
                                maxLines: 3,
                                maxLength: 30,
                                initialValue: settingBox.get('$scheduleDate-1') ?? '',
                                style: const TextStyle(fontSize: 15),
                                textAlignVertical: TextAlignVertical.center,
                                cursorColor: Pastel.grey,
                                decoration: const InputDecoration(
                                  hintText: "오늘의 하루",
                                  border: InputBorder.none,
                                ),
                                onChanged: (text) {
                                  settingBox.put('$scheduleDate-1', text);
                                },
                              ),
                            ),
                          );
                        }
                    );
                  },
                  child: Text(
                    settingBox.get('$scheduleDate-1')==null || settingBox.get('$scheduleDate-1')==""
                        ? '"오늘의 하루"': settingBox.get('$scheduleDate-1'),
                    style: const TextStyle(color: Pastel.blacksoft),),
                ),

              ),
            ),

          ],
        ),
        const Divider(color: Pastel.grey),
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
        icon: Image.asset('assets/icon/settings.png'), //ImageIcon(AssetImage("assets/icon/drawer.png"), color: Pastel.blacksoft, size: MyForm().appBarIconSize),
      ),
      title: Stack(
        children: [
          Positioned(
            right: 40,
            child: IconButton(
              onPressed: () {
                Provider.of<Cursor>(context, listen: false).changeIsMonth();
              },
              icon: Image.asset('assets/icon/move.png'), //ImageIcon(AssetImage("assets/icon/move.png"), color: Pastel.blacksoft, size: MyForm().appBarIconSize)
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              alignment: Alignment.centerRight,
              icon: Image.asset('assets/icon/home2.png'), //ImageIcon(AssetImage("assets/icon/Home.png"), color: Pastel.blacksoft, size: MyForm().appBarIconSize),
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
          const SizedBox(
            height: 120,
            child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Pastel.yellow,
                ),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: MyText('설정', 17, Pastel.black, FontWeight.w300)
                )
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 5, 20, 5),
            height: 40,
            child: Row(
              children: [
                const SizedBox(width: 15,),
                const Text("시작 요일 설정"),
                const Spacer(),
                CustomToggle(
                    whenSelect: Path().settingBox.get("defaultSetting").sunday,
                    boxBoolValue: Path().settingBox.get("defaultSetting").isSunday,
                    toggleA: "월요일",
                    toggleB: "일요일"
                )
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 5, 20, 5),
            height: 40,
            child: Row(
              children: [
                const SizedBox(width: 15,),
                const Text("폰트 변경"),
                const Spacer(),
                DropdownButton(
                  items: fontList.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  onChanged: (value){
                    SettingClass temp = Path().settingBox.get('defaultSetting');
                    setState(() {
                      Path().settingBox.put('defaultSetting', temp.fontChange(fontList.indexOf(value)));
                    });
                  },
                  value: fontList[Path().settingBox.get("defaultSetting").fontIdx ?? 0],
                )
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 5, 20, 5),
            height: 40,
            child: Row(
              children: [
                const SizedBox(width: 15,),
                const Text("이모티콘 보기"),
                const Spacer(),
                CustomToggle(
                    whenSelect: Path().settingBox.get("defaultSetting").emoticonOn, //function
                    boxBoolValue: Path().settingBox.get("defaultSetting").isEmoticon,
                    toggleA: "Off",
                    toggleB: "On"
                )
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 5, 20, 5),
            height: 40,
            child: Row(
              children: const [
                SizedBox(width: 15),
                Text("개발자 이메일"),
                Spacer(),
                Text("htjb00@gmail.com"),
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
  final Function whenSelect;
  final bool boxBoolValue;
  final String toggleA;
  final String toggleB;
  const CustomToggle({
    required this.whenSelect,
    required this.boxBoolValue,
    required this.toggleA,
    required this.toggleB,
    Key? key}) : super(key: key);

  @override
  State<CustomToggle> createState() => _CustomToggleState();
}

class _CustomToggleState extends State<CustomToggle> {
  late List<bool> boolList;

  @override
  void initState() {
    boolList = [!widget.boxBoolValue, widget.boxBoolValue];
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              boolList[0] = !boolList[0];
              boolList[1] = !boolList[1];
              Path().settingBox.put('defaultSetting', widget.whenSelect(false));
            });
          },
          child: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Pastel.black, width: 0),
              color: boolList[0] ? Pastel.bluegreen : Pastel.white,
            ),
            child: Text(widget.toggleA),
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              boolList[0] = !boolList[0];
              boolList[1] = !boolList[1];
              Path().settingBox.put('defaultSetting', widget.whenSelect(true));
            });
          },
          child: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Pastel.black, width: 0),
              color: boolList[1] ? Pastel.bluegreen : Pastel.white,
            ),
            child: Text(widget.toggleB),
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

List fontList = ["MaruBuri", "GangwonEdu"];

///*************** Emoticon List ******************////

class Emoticon {
  static const String blank = 'assets/emoticon/blank.png';
  static const String transparent = 'assets/emoticon/transparent.png';
  static const String plus = 'assets/emoticon/plus.png';
  static const String rain = 'assets/emoticon/rain.png';
  static const String homework = 'assets/emoticon/homework.png';
  static const String sick = 'assets/emoticon/sick.png';
  static const String basketball = 'assets/emoticon/basketball.png';
  static const String trip = 'assets/emoticon/trip.png';
  static const String sun = 'assets/emoticon/sun.png';
  static const String per100 = 'assets/emoticon/100.png';



  List<String> emoticonList() {
    return [blank, sun, rain, homework, sick, basketball, trip];
  }
}