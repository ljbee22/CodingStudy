import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_calender/bottomSheet.dart';
import 'package:my_calender/customclass/boxController.dart';
import 'package:my_calender/customclass/hiveClass.dart';
import 'package:my_calender/customclass/cursor.dart';
import 'package:my_calender/customclass/calenderElement.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:my_calender/localNotification.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final myController = TextEditingController();

class Calender extends StatefulWidget {
  const Calender({Key? key}) : super(key: key);

  @override
  State<Calender> createState() => _CalenderState();
}

class _CalenderState extends State<Calender> {
  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  FocusNode myFocusNode = FocusNode();
  String tmpText = "";
  bool flowerIconTapped = false;
  List<Color> colorList = [Pastel.white, Pastel.pink, Pastel.yellow, Pastel.green, Pastel.sky, Pastel.purple];

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    _init();
  }

  @override
  void didChangeDependencies() {
    // setState 가 실행될 때마다 실행되는 함수. 사실 누구의 setState 인지는 의문
    //정황상 cursor 를 listen 하는 것 같음(isMonth, selected)
    super.didChangeDependencies();
    FocusManager.instance.primaryFocus?.unfocus();
    myController.clear();
  }

  //notification initialize
  Future<void> _init() async{
    await configureLocalTimeZone();
    await NotificationController().initNotification();
  }

  //notification initialize -> timezone init
  Future<void> configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timeZoneName = DateTime.now().timeZoneName;

    try{
      tz.setLocalLocation(tz.getLocation(timeZoneName));
    }
    catch(e){
      tz.setLocalLocation(tz.getLocation("Asia/Seoul"));
    }
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
        drawer: const CustomDrawer(),
        body: ValueListenableBuilder(
            valueListenable: Hive.box<List>('Box').listenable(),
            builder: (context, Box<List> box, child) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Column(
                  children: [
                    const CalenderBanner(),
                    const DayOfWeek(),
                    const Divider(height: 0, thickness: 1),
                    AnimatedCrossFade(
                      duration: const Duration(milliseconds: 200),
                      firstChild: MonthColumn(box),
                      secondChild: WeekColumn(box),
                      crossFadeState: Provider.of<Cursor>(context).isMonth
                          ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                    ),

                    const SizedBox(height: 7),
                    const TodoBanner(),
                    Expanded(
                      child: CustomScrollView(
                        slivers: [
                          SliverReorderableList(
                              itemCount: box.get(scheduleDate) == null ? 0 : box.get(scheduleDate)!.length,
                              onReorder: (int oldIndex, int newIndex) {
                                List tmpList = box.get(scheduleDate)!;
                                if (oldIndex < newIndex) {
                                  newIndex -= 1;
                                }
                                final ScheduleClass item = tmpList.removeAt(oldIndex);
                                tmpList.insert(newIndex, item);
                                box.put(scheduleDate, tmpList);
                              },
                              itemBuilder: (BuildContext context, int idx){
                                ScheduleClass oneSchedule = box.get(scheduleDate)![idx];
                                return ReorderableDelayedDragStartListener(
                                  index: idx,
                                  key: Key("$idx"),
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Container(
                                        height: oneSchedule.btime ? 45 : 35,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          border: Border.all(color: Pastel.grey, width: 0),
                                          color: colorList[oneSchedule.colorIdx],
                                        ),
                                        child: GestureDetector(
                                          behavior: HitTestBehavior.translucent,
                                          onTap: (){
                                            showModalBottomSheet<void>(
                                                context: context,
                                                builder: (BuildContext context){
                                                  return ScheduleEdit(box, idx, oneSchedule, false);
                                                }
                                            );
                                            FocusManager.instance.primaryFocus?.unfocus();
                                          },
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.fromLTRB(5, 0, 10, 0),
                                                child: GestureDetector(
                                                  onTap: (){
                                                    oneSchedule.done = !oneSchedule.done;
                                                    BoxController().editSchedule(box, scheduleDate, oneSchedule, idx);
                                                  },
                                                  child: oneSchedule.done
                                                      ? const ImageIcon(AssetImage("assets/icon/check_checked.png"), size: 20, color: Pastel.black,)
                                                      : const ImageIcon(AssetImage("assets/icon/check_unchecked.png"), size: 20, color: Pastel.black,)
                                                ),
                                              ),
                                              Container(
                                                  alignment: Alignment.centerLeft,
                                                  child: RichText(
                                                    maxLines: oneSchedule.btime ? 2 : 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text: "${oneSchedule.name}\n",
                                                          style: TextStyle(
                                                            color: Pastel.black,
                                                            decoration: oneSchedule.done ? TextDecoration.lineThrough : TextDecoration.none,
                                                            fontStyle: oneSchedule.done ? FontStyle.italic : FontStyle.normal,
                                                            fontSize: 17,
                                                            fontFamily: "Myfont",
                                                          ),
                                                        ),
                                                        if(oneSchedule.btime)
                                                          TextSpan(
                                                            text: oneSchedule.timeString(),
                                                            style: const TextStyle(
                                                              color: Pastel.blacksoft,
                                                              fontSize: 12,
                                                              fontFamily: "Myfont",
                                                            ),
                                                          ),
                                                      ],
                                                    ),
                                                  )
                                              ),
                                              const Spacer(),
                                              if(oneSchedule.alarm && oneSchedule.date.isAfter(DateTime.now()))
                                                const Padding(
                                                  padding: EdgeInsets.only(right: 5),
                                                  child: ImageIcon(AssetImage("assets/icon/alarm_clock.png"), size: 20, color: Pastel.black,),
                                                ),

                                              const Padding(
                                                padding: EdgeInsets.only(right: 5),
                                                child: Icon(Icons.edit, size: 20, color: Pastel.black,),
                                              ),
                                            ],
                                          ),
                                        )
                                    ),
                                  ),
                                );
                              }
                          ),
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Container(
                                height: 35,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: Pastel.grey, width: 0),
                                  color: Pastel.white,
                                ),
                                child: Row(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.fromLTRB(5, 0, 10, 0),
                                      child: ImageIcon(AssetImage("assets/icon/check_notwork.png"), size: 20, color: Pastel.grey,),
                                    ),
                                    Expanded(
                                      child: Provider.of<Cursor>(context).isMonth
                                      ? GestureDetector(
                                        onTap: () {
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
                                          FocusManager.instance.primaryFocus?.unfocus();
                                        },
                                        child: const Text("새 일정",
                                          style: TextStyle(
                                            color: Pastel.grey,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w300
                                          ),
                                        ),
                                      )
                                      : TextFormField(
                                        textAlignVertical: TextAlignVertical.center,
                                        style: const TextStyle(fontSize: 15),
                                        controller: myController,
                                        focusNode: myFocusNode,
                                        cursorColor: Pastel.grey,
                                        decoration: const InputDecoration.collapsed(
                                            hintText: "새 일정",
                                            border: InputBorder.none
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

                                        onChanged: (text){tmpText = text;},
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 5),
                                      child: GestureDetector(
                                        onTap: () {
                                          showModalBottomSheet<void>(
                                              context: context,
                                              builder: (BuildContext context){
                                                if(!box.containsKey(scheduleDate)) {
                                                  // 일정이 없는 날에 새 일정 추가
                                                  return ScheduleEdit(box, 0, ScheduleClass(name: tmpText, date: DateTime(dateTime.year, dateTime.month, dateTime.day, 9)), true);
                                                }
                                                //일정이 있는 날에 새 일정 추가
                                                return ScheduleEdit(box, box.get(scheduleDate)!.length, ScheduleClass(name: tmpText, date: DateTime(dateTime.year, dateTime.month, dateTime.day, 9)), true);
                                              }
                                          );
                                          FocusManager.instance.primaryFocus?.unfocus();
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
                    if(!Provider.of<Cursor>(context).isMonth)
                    GestureDetector(
                      onTap: (){
                        print("object");
                        setState(() {flowerIconTapped = true;});
                        Future.delayed(const Duration(milliseconds: 500)).then((value){
                          flowerIconTapped = false;
                          setState(() {});
                        });
                      },
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: flowerIconTapped ? AssetImage('assets/background/flower_demo.gif') : AssetImage('assets/background/flower_demo_stop.png') ,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10)
                  ],
                ),
              );
            }
        ),
      ),
    );
  }
}
