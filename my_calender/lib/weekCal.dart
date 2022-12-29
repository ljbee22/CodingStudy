import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_calender/scheduleClass.dart';
import 'package:provider/provider.dart';
import 'package:my_calender/customclass/palette.dart';
import 'cursor.dart';
import 'customclass/CustomAppbar.dart';
import 'customclass/OneDay.dart';
import 'customclass/calenderElement.dart';

class WeekCal extends StatefulWidget {
  const WeekCal({Key? key}) : super(key: key);

  @override
  State<WeekCal> createState() => _WeekCalState();
}

class _WeekCalState extends State<WeekCal> {
  final key = GlobalKey<FormState>();
  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // if (key.currentState!.validate()) {
        //   print("@@@@@@@@@@@@@");
        //   key.currentState!.save();
        // }
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: CustomAppbar(scaffoldKey: scaffoldKey,), //custom appbar
        drawer: CustomDrawer(),
        key: scaffoldKey,
        body: ValueListenableBuilder(
            valueListenable: Hive.box<List>('lib').listenable(),
          builder: (context, Box<List> box, child) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Column(
                children: [
                  const DayofWeek(),
                  const Divider(height: 0),
                  Row(
                    children: [
                      for(int i = (Provider.of<Cursor>(context).dayofweek()-1) * 7 ;
                      i < Provider.of<Cursor>(context).dayofweek() * 7; i++)
                        OneDay(Provider.of<Cursor>(context).daylist()[i], box),
                    ],
                  ),
                  const SizedBox(height: 5),
                  AppBar(
                    elevation: 0,
                    backgroundColor: Pastel.orange,
                    title: MyText("To-do", 15, Pastel.black),
                    centerTitle: true,
                    toolbarHeight: 25,
                  ),
                  Expanded(
                    child: CustomScrollView(
                      slivers: [
                        SliverFixedExtentList(
                          itemExtent: 30,
                          delegate: SliverChildBuilderDelegate((BuildContext context, int idx){
                            return Container(
                              height: 25,
                              color: Pastel.green,
                              child: Text("test ${box.get(Provider.of<Cursor>(context, listen: false).returnAsString())![idx].name}"), // hive로 box.get(일자)[idx]
                            );
                          },
                            childCount: box.get(Provider.of<Cursor>(context, listen: false).returnAsString()) == null ?
                            0 : box.get(Provider.of<Cursor>(context, listen: false).returnAsString())!.length,
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: TextFormField(
                            // autofocus: true,
                            key: key,
                            // autovalidateMode: AutovalidateMode.always,
                            controller: TextEditingController(),
                            // cursorHeight: 20,
                            // textAlignVertical: TextAlignVertical.center,
                            cursorColor: Pastel.grey,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(top: 10),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white
                                ),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.white
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.white
                                ),
                              ),
                              icon: Icon(Icons.circle_outlined, color: Pastel.grey,),
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

                              if(box.containsKey(scheduleDate)) {
                                List tmp = box.get(scheduleDate)!;
                                tmp.add(ScheduleClass(name: text, date: DateTime.now()));
                                box.put(scheduleDate, tmp);
                              }
                              else {
                                List tmp = [ScheduleClass(name: text, date: DateTime.now())];
                                box.put(scheduleDate, tmp);
                              }
                            },
                            onSaved: (text){
                              print("@@@@@@@@@@@@@22222222222222");
                              if(text!.isEmpty) {
                                FocusManager.instance.primaryFocus?.unfocus();
                                return;
                              }
                              String scheduleDate = Provider.of<Cursor>(context, listen: false).returnAsString();

                              if(box.containsKey(scheduleDate)) {
                                List tmp = box.get(scheduleDate)!;
                                tmp.add(ScheduleClass(name: text, date: DateTime.now()));
                                box.put(scheduleDate, tmp);
                              }
                              else {
                                List tmp = [ScheduleClass(name: text, date: DateTime.now())];
                                box.put(scheduleDate, tmp);
                              }
                            },
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
