import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:my_calender/customclass/bottomSheetElement.dart';
import 'package:my_calender/customclass/scheduleClass.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';

import 'cursor.dart';
import 'customclass/palette.dart';

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
  final key = GlobalKey<FormState>();
  bool isLeft = true; // 토글 버튼
  late DateTime tmpDate;
  bool isDate = false; // 캘린더 표시 여부 확인

  @override
  Widget build(BuildContext context) {
    String scheduleDate = Provider.of<Cursor>(context, listen: false).returnAsString();

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
                List totalList = widget.box.get(scheduleDate);
                totalList.removeAt(widget.idx);
                if(totalList.length == 0){
                  widget.box.delete(scheduleDate);}
                else {widget.box.put(scheduleDate, totalList);}
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text("완료", style: TextStyle(fontSize: 20, color: Pastel.black, fontWeight: FontWeight.w500),),
              onPressed: (){
                if(key.currentState!.validate()){
                  key.currentState!.save(); // 이름과 메모 저장
                }

                List totalList;
                widget.oneSchedule.newDate(tmpDate); // 날짜 저장

                if(widget.isNew) {
                  if(widget.box.containsKey(scheduleDate)) {
                    totalList = widget.box.get(scheduleDate);
                    totalList.add(widget.oneSchedule);
                  } else {
                    totalList = [widget.oneSchedule];
                  }
                } else {
                  totalList = widget.box.get(scheduleDate);
                  totalList[widget.idx] = widget.oneSchedule;
                }
                widget.box.put(scheduleDate, totalList);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          if(key.currentState!.validate()){
            key.currentState!.save();
          }

          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Form(
              key: key,
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
                                  text: widget.oneSchedule.name,
                                ),
                                // keyboardType: TextInputType.multiline,
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
                                  text = text.trim();
                                  if(text.isEmpty) FocusManager.instance.primaryFocus?.unfocus();
                                  widget.oneSchedule.name = text;
                                },
                                validator: (text){
                                  return null;
                                },
                                onSaved: (text) {
                                  text = text!.trim();
                                  widget.oneSchedule.name = text;
                                  print("@@@@@@@@@@@이름 저장@@@@@@@@@@@@");
                                },
                              ),
                        ),
                        const Divider(height: 0,),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: TextFormField(
                            controller: TextEditingController(
                              text: widget.oneSchedule.memo,
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
                              text = text.trim();
                              if(text.isEmpty) FocusManager.instance.primaryFocus?.unfocus();
                              widget.oneSchedule.memo = text;
                            },
                            validator: (text){
                              return null;
                            },
                            onSaved: (text) {
                              text = text!.trim();
                              widget.oneSchedule.memo = text;
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
                    child: AnimatedContainer(
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Pastel.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      duration: const Duration(milliseconds: 0),
                      height: isDate ? 30+115 : 30,
                      width: 400,
                      child: Column(
                        children: [
                          Text("일정 변경"),

                          if(isDate)
                            Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Container(
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
                                  initialDateTime: widget.oneSchedule.date,
                                  onDateTimeChanged: (date){
                                    tmpDate = date;
                                    print(tmpDate);
                                  },
                                  mode: CupertinoDatePickerMode.date,
                                ),
                              ),
                            ),
                          ),

                        ],
                      ),
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
