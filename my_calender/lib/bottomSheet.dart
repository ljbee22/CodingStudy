import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
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
              child: Text("삭제", style: TextStyle(fontSize: 20, color: Pastel.redaccent, fontWeight: FontWeight.w500),),
              onPressed: () {
                List totalList = widget.box.get(scheduleDate);
                totalList.removeAt(widget.idx);
                widget.box.put(scheduleDate, totalList);
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text("완료", style: TextStyle(fontSize: 20, color: Pastel.black, fontWeight: FontWeight.w500),),
              onPressed: (){
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
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Pastel.grey, width: 0),
                    color: Pastel.white,
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: TextFormField(
                      key: key,
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
                      onSaved: (text) {
                        text = text!.trim();
                        if(text.isEmpty) FocusManager.instance.primaryFocus?.unfocus();
                        widget.oneSchedule.name = text;
                      },
                    ),
                  ),
                ),

                Container(
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Pastel.grey, width: 0),
                    color: Pastel.white,
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: TextFormField(
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
                    ),
                  )
                ),
                Container( //알림 여부
                ),
                Container( // 시간 설정
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
