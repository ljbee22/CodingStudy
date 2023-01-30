import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:my_calender/customclass/boxController.dart';
import 'package:my_calender/customclass/calenderElement.dart';
import 'package:my_calender/customclass/hiveClass.dart';
import 'package:my_calender/localNotification.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_calender/customclass/cursor.dart';
import 'package:my_calender/Calender.dart' as calender;

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
  late DateTime tmpDate; // oneSchedule 에 넣을 날짜
  late DateTime tmpTime; // oneSchedule 에 넣을 시간
  late bool isTimeToggleOn;
  late bool isAlarmToggleOn;
  bool isError = false;
  late int colorIdx;
  List<Color> colorList = [Pastel.white, Pastel.pink, Pastel.yellow, Pastel.green, Pastel.sky, Pastel.purple];

  @override
  void initState(){
    super.initState();
    title = widget.oneSchedule.name;
    memo = widget.oneSchedule.memo;
    tmpDate = widget.oneSchedule.date;
    tmpTime = widget.oneSchedule.date;
    isTimeToggleOn = widget.oneSchedule.btime;
    isAlarmToggleOn = widget.oneSchedule.alarm;
    colorIdx = widget.oneSchedule.colorIdx;
  }

  Widget colorCircle (int idx) {
    return GestureDetector(
      onTap: () {
        setState(() {
          colorIdx = idx;
        });
      },
      child: Container(
        width: 25,
        height: 25,
        decoration: BoxDecoration(
          color: colorList[idx],
          shape: BoxShape.circle,
          boxShadow: [
            if(idx == colorIdx)
              const BoxShadow(
                color: Pastel.grey,
                blurRadius: 1,
                spreadRadius: 1,
              )
          ],
          border: Border.all(
              color: Pastel.blacksoft,
              width: 1,
          ),
        ),
      ),
    );
}

  @override
  Widget build(BuildContext context) {
    DateTime initDate = Provider.of<Cursor>(context, listen: false).selected;
    String scheduleDate = Provider.of<Cursor>(context, listen: false).returnAsString();
    int uniqueIdx = int.parse("${initDate.year}${initDate.month}${initDate.day}${widget.idx}");
    print("@@@@@@@@@@다시 빌드됨@@@@@@@@@@@@");

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Pastel.black),
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
                NotificationController().notifications.cancel(uniqueIdx);
                BoxController().deleteSchedule(widget.box, scheduleDate, widget.idx);
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text("완료", style: TextStyle(fontSize: 20, color: Pastel.black, fontWeight: FontWeight.w500),),
              onPressed: (){
                bool isDateChanged = widget.oneSchedule.isDayChanged(tmpDate);

                widget.oneSchedule.changeScheduleElements(
                  title.trim(),
                  memo.trim(),
                  tmpDate,
                  tmpTime,
                  isTimeToggleOn,
                  isAlarmToggleOn,
                  colorIdx
                );

                if(widget.oneSchedule.name.isEmpty) {
                  return;
                }

                //알림 추가 시에 알림 울리게 하는 함수
                if(widget.oneSchedule.alarm) { // alarm 이  true 일때만 실행
                  if(widget.oneSchedule.date.isAfter(DateTime.now())){
                    // 시간이 제대로 정해져 있으면 알림 설정
                    NotificationController().scheduleNotification(uniqueIdx, widget.oneSchedule.name, widget.oneSchedule.date);
                    print("this is initdate : $initDate");
                    print("${widget.oneSchedule.date}에 알람이 울립니다");
                  }
                  else{
                    // 시간이 제대로 설정이 안 되어 있으면 아래 경고문 띄워주는 변수(isError 활성화)
                    setState((){isError = true;});
                    return;
                  }
                }

                //알림을 끈 상태면 기존의 알림을 지운다
                if(!widget.oneSchedule.alarm){
                  NotificationController().notifications.cancel(uniqueIdx);
                }

                // 위에서 수정한 일정을 실제로 hivebox 에 적용
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
                calender.myController.clear();
                calender.tmpText='';
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
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      for(int idx = 0; idx < colorList.length; idx++)
                        colorCircle(idx)
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Pastel.grey, width: 0),
                    color: Pastel.white,
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: TextFormField(
                          maxLines: null,
                          initialValue: title,
                          style: const TextStyle(fontSize: 15),
                          textAlignVertical: TextAlignVertical.center,
                          cursorColor: Pastel.grey,
                          decoration: const InputDecoration(
                              hintText: "새 일정",
                              border: InputBorder.none,
                          ),
                          onFieldSubmitted: (text) {
                            if(text.isEmpty) FocusManager.instance.primaryFocus?.unfocus();
                          },
                          onChanged: (text) {
                            title = text;
                          },
                        ),
                      ),
                      const Divider(height: 0,),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: TextFormField(
                          maxLines: null,
                          initialValue: memo,
                          style: const TextStyle(fontSize: 15),
                          textAlignVertical: TextAlignVertical.center,
                          cursorColor: Pastel.grey,
                          decoration: const InputDecoration(
                            hintText: "메모",
                            border: InputBorder.none,
                          ),
                          onFieldSubmitted: (text) {
                            if(text.isEmpty) FocusManager.instance.primaryFocus?.unfocus();
                          },
                          onChanged: (text) {
                            memo = text;
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
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Pastel.grey),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    width: 400,
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: Text("일정 변경")
                        ),
                          AnimatedCrossFade(
                              firstChild: SizedBox(
                                height: 110,
                                width: 350,
                                child: CupertinoTheme(
                                  data: const CupertinoThemeData(
                                      textTheme: CupertinoTextThemeData(
                                          dateTimePickerTextStyle: TextStyle(fontSize: 17)
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
                const SizedBox(height: 10),
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
                            const Text("시간"),
                            const Spacer(),
                            GestureDetector(
                                child: CustomOnOff(isTimeToggleOn),
                              onTap: () {
                                  setState(() {
                                    isTimeToggleOn = !isTimeToggleOn;
                                  });

                                  if(!isTimeToggleOn){ // 토글이 꺼져 있으면 실행
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
                                  data: const CupertinoThemeData(
                                      textTheme: CupertinoTextThemeData(
                                          dateTimePickerTextStyle: TextStyle(fontSize: 17)
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
                                    const Text("알림 설정"),
                                    if(isError)
                                      const Padding(
                                        padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
                                        child: MyText("현재 시간 이후로 설정해주세요!", 10, Pastel.redaccent, FontWeight.w200),
                                      ),
                                    const Spacer(),
                                    GestureDetector(
                                      child: CustomOnOff(isAlarmToggleOn),
                                      onTap: () {
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
    );
  }
}
