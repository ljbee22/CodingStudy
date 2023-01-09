import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:my_calender/customclass/bottomSheetElement.dart';
import 'package:my_calender/customclass/boxController.dart';
import 'package:my_calender/customclass/scheduleClass.dart';
import 'package:my_calender/localNotification.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'cursor.dart';
import 'customclass/palette.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

class ScheduleEdit extends StatefulWidget {
  final Box box;
  final int idx;
  final ScheduleClass oneSchedule;
  final bool isNew;

  const ScheduleEdit(this.box, this.idx, this.oneSchedule, this.isNew, {Key? key}) : super(key: key);

  @override
  State<ScheduleEdit> createState() => _ScheduleEditState();
}

class _ScheduleEditState extends State<ScheduleEdit> {

  late String title;
  late String memo;
  bool isDate = false; // 캘린더 표시 여부 확인
  late DateTime tmpDate; // oneSchedule에 넣을 날짜
  late DateTime tmpTime; // oneSchedule에 넣을 시간
  late bool isTimeToggleOn;
  late bool isAlarmToggleOn;

  @override
  void initState(){
    super.initState();
    title = widget.oneSchedule.name;
    memo = widget.oneSchedule.memo;
    tmpDate = widget.oneSchedule.date;
    tmpTime = widget.oneSchedule.date;
    isTimeToggleOn = widget.oneSchedule.btime;
    isAlarmToggleOn = widget.oneSchedule.alarm;
  }


  Widget build(BuildContext context) {
    String scheduleDate = Provider.of<Cursor>(context, listen: false).returnAsString();
    print("@@@@@@@@@@다시 빌드됨@@@@@@@@@@@@");
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Pastel.black),
        backgroundColor: Pastel.purple,
        elevation: 0,
        toolbarHeight: 50,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if(!widget.isNew)
            TextButton(
              child: const Text("삭제", style: TextStyle(fontSize: 20, color: Pastel.redaccent, fontWeight: FontWeight.w500),),
              onPressed: () {
                print("@@@@@@@@@@삭제@@@@@@@@@@@@");
                BoxController().deleteSchedule(widget.box, scheduleDate, widget.idx);
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text("완료", style: TextStyle(fontSize: 20, color: Pastel.black, fontWeight: FontWeight.w500),),
              onPressed: (){
                bool isDateChanged = widget.oneSchedule.isDayChanged(tmpDate);

                print("${tmpDate}@############################@ ${tmpTime}");
                print("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&${isAlarmToggleOn}");

                widget.oneSchedule.changeScheduleElements(
                  title.trim(),
                  memo.trim(),
                  tmpDate,
                  tmpTime,
                  isTimeToggleOn,
                  isAlarmToggleOn,
                );

                if(widget.isNew) { // 새로운 일정을 추가
                  print("@@@@@@@@@@@새로운 일정 추가됨@@@@@@@@@@");
                  BoxController().newSchedule(widget.box, scheduleDate, widget.oneSchedule);
                } else { // 존재하는 일정을 수정
                  if(isDateChanged) { //날짜가 변경됨 -> 삭제, 새로운 일정 삽입
                    print("@@@@@@@@@@날짜 수정됨@@@@@@@@@@@@");
                    BoxController().changeScheduleDate(widget.box, scheduleDate, tmpDate, widget.oneSchedule, widget.idx);
                  } else {// 날짜가 변경되지 않음 -> 수정
                    print("@@@@@@@@@@날짜는 그대로 수정@@@@@@@@@@@@");
                    BoxController().editSchedule(widget.box, scheduleDate, widget.oneSchedule, widget.idx);
                  }
                }
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          title = title.trim();
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Form(
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Pastel.grey, width: 0),
                      color: Pastel.white,
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: TextFormField(
                                controller: TextEditingController(
                                  text: title,
                                ),
                                // maxLines: null,
                                style: TextStyle(fontSize: 15),
                                textAlignVertical: TextAlignVertical.center,
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
                                ),
                                onFieldSubmitted: (text) {
                                  if(text.isEmpty) FocusManager.instance.primaryFocus?.unfocus();
                                },
                                onChanged: (text) {
                                  title = text;
                                  print("@@@@@@@@@@@이름 저장@@@@@@@@@@@@");
                                },
                              ),
                        ),
                        const Divider(height: 0,),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: TextFormField(
                            controller: TextEditingController(
                              text: memo,
                            ),
                            style: TextStyle(fontSize: 15),
                            textAlignVertical: TextAlignVertical.center,
                            cursorColor: Pastel.grey,
                            decoration: InputDecoration(
                              hintText: "메모",
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
                            ),
                            onFieldSubmitted: (text) {
                              if(text.isEmpty) FocusManager.instance.primaryFocus?.unfocus();
                            },
                            onChanged: (text) {
                              memo = text!;
                              print("@@@@@@@@@@@@메모 저장 @@@@@@@@@@@");
                            },
                          ),
                        ),

                      ],
                    ),
                  ),
                  //날짜 설정 -> 캘린더를 띄우기 or 하루 미루기, 일주일 미루기 버튼

                  const SizedBox(height: 10),

                  GestureDetector(
                    onTap: (){
                      setState((){
                      isDate = !isDate;
                      });
                      print(isDate);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Pastel.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      width: 400,
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: Text("일정 변경")
                          ),
                            AnimatedCrossFade(
                                firstChild: SizedBox(
                                  height: 110,
                                  width: 350,
                                  child: CupertinoTheme(
                                    data: CupertinoThemeData(
                                        textTheme: CupertinoTextThemeData(
                                            dateTimePickerTextStyle: TextStyle(
                                              fontSize: 17,
                                            )
                                        )
                                    ),
                                    child: CupertinoDatePicker(
                                      initialDateTime: tmpDate,
                                      onDateTimeChanged: (date){
                                        tmpDate = date;
                                        print(tmpDate);
                                      },
                                      mode: CupertinoDatePickerMode.date,
                                    ),
                                  ),
                                ),
                                secondChild: Container(),
                                crossFadeState: isDate ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                                duration: const Duration(milliseconds: 200)
                            ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Pastel.grey),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    width: 400,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
                          child: Row(
                            children: [
                              Text("시간"),
                              Spacer(),
                              GestureDetector(
                                  child: CustomToggle(isTimeToggleOn),
                                onTap: () {
                                    setState(() {
                                      isTimeToggleOn = !isTimeToggleOn;
                                    });

                                    if(!isTimeToggleOn){ // 토글이 꺼져 있으면 실행
                                      tmpTime = DateTime(1,1,1,9); // 9시로 초기화
                                      isAlarmToggleOn = false;
                                    }
                                },
                              ),
                            ],
                          ),
                        ),
                        AnimatedCrossFade(
                            firstChild: Column(
                              children: [
                                const Divider(height: 0, indent: 8, endIndent: 8,),
                                SizedBox(
                                  height: 110,
                                  width: 350,
                                  child: CupertinoTheme(
                                    data: CupertinoThemeData(
                                        textTheme: CupertinoTextThemeData(
                                            dateTimePickerTextStyle: TextStyle(
                                              fontSize: 17,
                                            )
                                        )
                                    ),
                                    child: CupertinoDatePicker(
                                      initialDateTime: tmpTime,
                                      onDateTimeChanged: (date){
                                        tmpTime = date;
                                      },
                                      mode: CupertinoDatePickerMode.time,
                                    ),
                                  ),
                                ),
                                const Divider(height: 0, indent: 8, endIndent: 8,),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
                                  child: Row(
                                    children: [
                                      Text("알림 설정"),
                                      Spacer(),
                                      GestureDetector(
                                        child: CustomToggle(isAlarmToggleOn),
                                        onTap: () {
                                          print("${isAlarmToggleOn} 누르기전에!!!!!!!!!!!!!!!!");
                                          setState(() {
                                            isAlarmToggleOn = !isAlarmToggleOn;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            secondChild: Container(),
                            crossFadeState: isTimeToggleOn ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                            duration: const Duration(milliseconds: 200)
                        ),
                        FloatingActionButton(onPressed: (){
                          NotificationController().scheduleNotification(1, title, tmpTime);
                          print("${tmpTime} is when alarm goes up@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
                        })
                      ],
                    ),
                  ),

                  Container( // 시간 여부 -> 설정
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
