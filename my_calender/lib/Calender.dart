import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_calender/WeekAndMonth.dart';
import 'package:my_calender/bottomSheet.dart';
import 'package:my_calender/customclass/boxController.dart';
import 'package:my_calender/customclass/scheduleClass.dart';
import 'package:provider/provider.dart';
import 'package:my_calender/customclass/palette.dart';
import 'cursor.dart';
import 'customclass/CustomAppbar.dart';
import 'package:flutter/services.dart';
import 'customclass/calenderElement.dart';
import 'package:my_calender/localNotification.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;


class Calender extends StatefulWidget {
  const Calender({Key? key}) : super(key: key);

  @override
  State<Calender> createState() => _CalenderState();
}

class _CalenderState extends State<Calender> {
  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  final myController = TextEditingController();
  FocusNode myFocusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    _init();
  }

  Future<void> _init() async{
    await configureLocalTimeZone();
    await NotificationController().initNotification();
  }

  Future<void> configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timeZoneName = DateTime.now().timeZoneName;
    tz.setLocalLocation(tz.getLocation(timeZoneName!));
  }

  @override
  Widget build(BuildContext context) {
    String scheduleDate = Provider.of<Cursor>(context).returnAsString();
    DateTime dateTime = Provider.of<Cursor>(context).selected;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: CustomAppbar(scaffoldKey: scaffoldKey,), //custom appbar
        key: scaffoldKey,
        drawer: CustomDrawer(),
        body: ValueListenableBuilder(
            valueListenable: Hive.box<List>('Box').listenable(),
          builder: (context, Box<List> box, child) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Column(
                children: [
                  CalenderBanner(),
                  const DayofWeek(),
                  const Divider(height: 0),
                  AnimatedCrossFade(
                    duration: Duration(milliseconds: 200),
                    firstChild: MonthColumn(box),
                    secondChild: WeekColumn(box),
                    crossFadeState: Provider.of<Cursor>(context).isMonth
                      ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                  ),

                  const SizedBox(height: 5),
                  TodoBanner(),
                  Expanded(
                    child: CustomScrollView(
                      slivers: [
                        SliverFixedExtentList(
                          itemExtent: 40,
                          delegate: SliverChildBuilderDelegate((BuildContext context, int idx){
                            return Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: Pastel.grey, width: 0),
                                  color: Pastel.white,
                                ),
                                child: GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onLongPress: () {

                                  },
                                  onTap: (){
                                    //TODO 눌렀을때 키보드 focus out 되게. 전체 구현성공하면 무시
                                    showModalBottomSheet<void>(
                                        context: context,
                                        builder: (BuildContext context){
                                          return ScheduleEdit(box, idx, box.get(scheduleDate)![idx], false);
                                        }
                                    );
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(5, 0, 10, 0),
                                        child: GestureDetector(
                                          onTap: (){
                                            print("icons tapped@@@@@@@@@@@@@@@");
                                          },
                                          child: ImageIcon(AssetImage("assets/icon/check_unchecked.png"), size: 20, color: Pastel.black,),
                                        ),
                                        ),
                                      Container(
                                          width: MediaQuery.of(context).size.width-100,
                                          alignment: Alignment.centerLeft,
                                          child: RichText(
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            text: TextSpan(
                                                text: "${box.get(scheduleDate)![idx].name}",
                                                style: TextStyle(
                                                  color: Pastel.black,
                                                  fontSize: 15,
                                                  fontFamily: "Myfont",
                                                ),
                                              // children: [
                                              //   TextSpan(text: "!!!!"),
                                              // ]
                                            ),
                                          )
                                      ),
                                      const Spacer(),
                                      Padding(
                                        padding: EdgeInsets.only(right: 5),
                                        child: const Icon(Icons.edit, size: 20, color: Pastel.black,),
                                      ),
                                    ],
                                  ),
                                )
                              ),
                            );
                          },
                            childCount: box.get(scheduleDate) == null ?
                            0 : box.get(scheduleDate)!.length,
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Container(
                              height: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: Pastel.grey, width: 0),
                                color: Pastel.white,
                              ),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(5, 0, 10, 0),
                                    child: ImageIcon(AssetImage("assets/icon/check_notwork.png"), size: 20, color: Pastel.grey,),
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      // autofocus: true,
                                      // autovalidateMode: AutovalidateMode.always,
                                      textAlignVertical: TextAlignVertical.center,
                                      style: TextStyle(fontSize: 15),
                                      controller: myController,
                                      focusNode: myFocusNode,
                                      cursorColor: Pastel.grey,
                                      decoration: InputDecoration(
                                        hintText: "새 일정",
                                        border: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.transparent
                                          ),
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.transparent
                                          ),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.transparent
                                          ),
                                        ),
                                        isCollapsed: true
                                      ),

                                      onFieldSubmitted: (text) {
                                        //filtering
                                        text = text.trim();

                                        if(text.isEmpty) {
                                          FocusManager.instance.primaryFocus?.unfocus();
                                          myController.clear();
                                          return;
                                        }

                                        BoxController().newSchedule(
                                            box, scheduleDate,
                                            ScheduleClass(name: text, date: DateTime(dateTime.year, dateTime.month, dateTime.day, 9)
                                        ));
                                        myFocusNode.requestFocus();
                                        myController.clear();
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(right: 5),
                                    child: GestureDetector(
                                      onTap: () {
                                        //TODO 눌렀을때 키보드 focus out 되게. 전체 구현성공하면 무시
                                        showModalBottomSheet<void>(
                                            context: context,
                                            builder: (BuildContext context){
                                              if(!box.containsKey(scheduleDate)) {
                                                // 일정이 없는 날에 새 일정 추가
                                                return ScheduleEdit(box, 0, ScheduleClass(name: "", date: DateTime(dateTime.year, dateTime.month, dateTime.day, 9)), true);
                                              }
                                              //일정이 있는 날에 새 일정 추가
                                              return ScheduleEdit(box, box.get(scheduleDate)!.length, ScheduleClass(name: "", date: DateTime(dateTime.year, dateTime.month, dateTime.day, 9)), true);
                                            }
                                        );
                                      },
                                      child: const Icon(Icons.edit, size: 20, color: Pastel.grey,),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        ),
      ),
    );
  }
}
