import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:my_calender/customclass/bottomSheetElement.dart';
import 'package:my_calender/customclass/scheduleClass.dart';
import 'package:provider/provider.dart';

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
  bool isLeft = true;

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
                  key.currentState!.save();
                }

                List totalList;
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
                                  print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
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
                              print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
                            },
                          ),
                        ),

                      ],
                    ),
                  ),
                  //날짜 설정 -> 캘린더를 띄우기 or 하루 미루기, 일주일 미루기 버튼
                  Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Container(
                      height: 80,
                      child: Row(
                        children: [
                          // 연도
                          Expanded(
                            child: ListWheelScrollView.useDelegate(
                              physics: FixedExtentScrollPhysics(),
                              diameterRatio: 10,
                              controller: FixedExtentScrollController(initialItem: 100),
                              onSelectedItemChanged: (int idx) {
                                widget.oneSchedule.newYear(widget.oneSchedule.date.year+idx-100);
                                print(widget.oneSchedule.date);
                              },
                              childDelegate: ListWheelChildListDelegate(
                                  children: [
                                    for(int i = widget.oneSchedule.date.year - 100; i<widget.oneSchedule.date.year + 100; i++) Text(i.toString()),
                                  ]
                              ),
                                itemExtent: 30,

                            ),
                          ),
                          // 월
                          Expanded(
                            child: ListWheelScrollView(
                                itemExtent: 30,
                                children: [
                                  for(int i = 0; i<100; i++) Text(i.toString()),
                                ]
                            ),
                          ),
                          // 일
                          Expanded(
                            child: ListWheelScrollView(
                                itemExtent: 30,
                                children: [
                                  for(int i = 0; i<100; i++) Text(i.toString()),
                                ]
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                            onPressed: (){
                            },
                            style: ButtonStyle(

                            ),
                            child: const Text("내일로")
                        ),
                      ),
                      Expanded(
                        child: ElevatedButton(
                            onPressed: (){

                            },
                            child: const Text("다음주로")
                        ),
                      ),
                      Expanded(
                        child: ElevatedButton(
                            onPressed: (){

                            },
                            child: const Text("날짜 수정")
                        ),
                      )
                    ],
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
