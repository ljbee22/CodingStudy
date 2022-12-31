import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:my_calender/scheduleClass.dart';
import 'package:provider/provider.dart';

import 'cursor.dart';
import 'customclass/palette.dart';

class ScheduleEdit extends StatefulWidget {
  final Box box;
  final int idx;

  const ScheduleEdit(this.box, this.idx, {Key? key}) : super(key: key);

  @override
  State<ScheduleEdit> createState() => _ScheduleEditState();
}

class _ScheduleEditState extends State<ScheduleEdit> {
  @override
  Widget build(BuildContext context) {
    String scheduleDate = Provider.of<Cursor>(context, listen: false).returnAsString();
    List totalList = widget.box.get(scheduleDate);
    ScheduleClass oneList;
    if(totalList.length == widget.idx) {
      oneList = ScheduleClass(name: "", date: Provider.of<Cursor>(context, listen: false).selected);
    } else {
      oneList = totalList[widget.idx];
    }
    TextEditingController controller = TextEditingController(
      text: oneList.name,
    );
    controller.selection = TextSelection.fromPosition(TextPosition(offset: controller.text.length));
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 50,
        title: Stack(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                child: Text("완료", style: TextStyle(fontSize: 20, color: Pastel.white, fontWeight: FontWeight.w500),),
                onPressed: (){
                },
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Container(
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Pastel.grey, width: 0),
                color: Pastel.white,
              ),
              child: TextFormField(
                //TODO: 여기에 info 버튼을 추가하고, widget.box.get(Provider.of<Cursor>(context, listen: false).returnAsString())!.length를 idx로 전달
                // autofocus: true,
                // key: key,
                // autovalidateMode: AutovalidateMode.always,
                // initialValue: ,
                controller: controller,
                // cursorHeight: 20,
                // textAlignVertical: TextAlignVertical.center,
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
                validator: (text) {
                  if(text!.isEmpty) {
                    return "null";
                  }
                  return null;
                },
                onFieldSubmitted: (text) {
                  if(text.isEmpty) {
                    FocusManager.instance.primaryFocus?.unfocus();
                    return;
                  }
                  String scheduleDate = Provider.of<Cursor>(context, listen: false).returnAsString();

                  if(widget.box.containsKey(scheduleDate)) {
                    List tmp = widget.box.get(scheduleDate)!;
                    tmp.add(ScheduleClass(name: text, date: Provider.of<Cursor>(context, listen: false).selected));
                    widget.box.put(scheduleDate, tmp);
                  }
                  else {
                    List tmp = [ScheduleClass(name: text, date: Provider.of<Cursor>(context, listen: false).selected)];
                    widget.box.put(scheduleDate, tmp);
                  }
                },
                onSaved: (text){
                  print("@@@@@@@@@@@@@22222222222222");
                  if(text!.isEmpty) {
                    FocusManager.instance.primaryFocus?.unfocus();
                    return;
                  }
                  String scheduleDate = Provider.of<Cursor>(context, listen: false).returnAsString();

                  if(widget.box.containsKey(scheduleDate)) {
                    List tmp = widget.box.get(scheduleDate)!;
                    tmp.add(ScheduleClass(name: text, date: DateTime.now()));
                    widget.box.put(scheduleDate, tmp);
                  }
                  else {
                    List tmp = [ScheduleClass(name: text, date: DateTime.now())];
                    widget.box.put(scheduleDate, tmp);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
