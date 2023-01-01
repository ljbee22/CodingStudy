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

  const ScheduleEdit(this.box, this.idx, {Key? key}) : super(key: key);

  @override
  State<ScheduleEdit> createState() => _ScheduleEditState();
}

class _ScheduleEditState extends State<ScheduleEdit> {
  final TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    _controller.text = ;
  }
  @override
  Widget build(BuildContext context) {
    print("widget is rebuilt@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
    String scheduleDate = Provider.of<Cursor>(context).returnAsString();
    List totalList;
    if(widget.box.containsKey(scheduleDate)) {
      totalList = widget.box.get(scheduleDate);
    } else {
      totalList = [];
    }
    ScheduleClass oneList;
    if(totalList.length == widget.idx) {
      oneList = ScheduleClass(name: "", date: Provider.of<Cursor>(context, listen: false).selected);
    } else {
      oneList = totalList[widget.idx];
    }

    _controller.selection = TextSelection.fromPosition(TextPosition(offset: _controller.text.length));
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Pastel.black),
        backgroundColor: Pastel.purple,
        elevation: 0,
        toolbarHeight: 50,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              child: Text("삭제", style: TextStyle(fontSize: 20, color: Pastel.redaccent, fontWeight: FontWeight.w500),),
              onPressed: () {},
            ),
            TextButton(
              child: Text("완료", style: TextStyle(fontSize: 20, color: Pastel.black, fontWeight: FontWeight.w500),),
              onPressed: (){
              },
            ),
          ],
        ),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width - 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Pastel.grey, width: 0),
                  color: Pastel.white,
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: TextFormField(
                    controller: _controller,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
