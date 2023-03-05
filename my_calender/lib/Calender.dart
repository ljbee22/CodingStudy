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
String tmpText = "";

class Calender extends StatefulWidget {
  final Box settingBox;
  const Calender({Key? key, required this.settingBox}) : super(key: key);

  @override
  State<Calender> createState() => _CalenderState();
}

class _CalenderState extends State<Calender> {
  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  FocusNode myFocusNode = FocusNode();
  bool flowerIconTapped = false;
  List<Color> colorList = [Pastel.white, Pastel.pink, Pastel.yellow, Pastel.green, Pastel.sky, Pastel.purple];

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    _init();

    // setting box 의 최초 초기화 (어플 설치 후 최초 1회만 실행)
    if(!Path().settingBox.containsKey("defaultSetting")){
      Path().settingBox.put("defaultSetting", SettingClass());
      // 알림 권한 설정을 위한 notification
      NotificationController().showNotification(0, "title");
    }
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
            builder: (context, box, child) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Column(
                      children: [
                        CalenderBanner(settingBox: widget.settingBox),
                        DayOfWeek(settingBox: widget.settingBox),
                        const Divider(height: 0, thickness: 1),
                        AnimatedCrossFade(
                          duration: const Duration(milliseconds: 200),
                          firstChild: MonthColumn(box, widget.settingBox),
                          secondChild: WeekColumn(box, widget.settingBox),
                          crossFadeState: Provider.of<Cursor>(context).isMonth
                              ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                        ),

                        if(!Provider.of<Cursor>(context).isMonth && widget.settingBox.get("defaultSetting").isEmoticon)
                          DailyEmoticon(settingBox: widget.settingBox),
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
                                              onHorizontalDragEnd: (DragEndDetails details) {
                                                //옆으로 drag 해서 삭제 기능(예정)
                                              },
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
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                      children: [
                                                        Container(
                                                          constraints: BoxConstraints(
                                                              maxWidth: double.infinity
                                                          ),
                                                          height: 23,
                                                          child: Text(
                                                            oneSchedule.name,
                                                            overflow: TextOverflow.ellipsis,
                                                            maxLines: 1,
                                                            style: TextStyle(
                                                              color: Pastel.black,
                                                              decoration: oneSchedule.done ? TextDecoration.lineThrough : TextDecoration.none,
                                                              fontStyle: oneSchedule.done ? FontStyle.italic : FontStyle.normal,
                                                              fontSize: 17,
                                                              // fontFamily: "Myfont1",
                                                            ),
                                                          ),
                                                        ),
                                                        if(oneSchedule.btime)
                                                          Container(
                                                            constraints: BoxConstraints(
                                                                maxWidth: double.infinity
                                                            ),
                                                            height: 17,
                                                            child: Text(
                                                              oneSchedule.timeString(),                                                          overflow: TextOverflow.ellipsis,
                                                              maxLines: 1,
                                                              style: TextStyle(
                                                                color: Pastel.blacksoft,
                                                                fontSize: 12,
                                                                // fontFamily: "Myfont1",
                                                              ),
                                                            ),
                                                          ),
                                                      ],
                                                    ),
                                                  ),
                                                  if(oneSchedule.alarm && oneSchedule.date.isAfter(DateTime.now()))
                                                    const Padding(
                                                      padding: EdgeInsets.only(right: 5),
                                                      child: ImageIcon(AssetImage("assets/icon/alarm_clock.png"), size: 20, color: Pastel.black,),
                                                    ),

                                                  const Padding(
                                                    padding: EdgeInsets.only(right: 5),
                                                    child: ImageIcon(AssetImage("assets/icon/edit.png"), size: 20, color: Pastel.black,),
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
                                              tmpText = "";
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
                                            child: const ImageIcon(AssetImage("assets/icon/edit.png"), size: 20, color: Pastel.grey,),
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
        )
      ),
    );
  }
}
