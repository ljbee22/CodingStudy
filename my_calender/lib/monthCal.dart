import 'package:flutter/material.dart';
import 'cursor.dart';
import 'customclass/calenderElement.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'customclass/customContainer.dart';
import 'package:provider/provider.dart';
import 'scheduleClass.dart';
import 'package:my_calender/customclass/palette.dart';

class MonthCal extends StatefulWidget {
  const MonthCal({Key? key}) : super(key: key);

  @override
  State<MonthCal> createState() => _MonthCalState();
}

class _MonthCalState extends State<MonthCal> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MonthAppbar(appbar: AppBar()), //custom appbar
      body: ValueListenableBuilder(
        valueListenable: Hive.box<List>('lib').listenable(),
        builder: (context, Box<List> box, child) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Column(
              children: [
                GestureDetector(
                  onVerticalDragUpdate: (val) {
                    if (val.delta.dy > 10) {Provider.of<Cursor>(context, listen: false).plusMonth(true);}
                    if (val.delta.dy < -10) {Provider.of<Cursor>(context, listen: false).plusMonth(false);}
                  },
                  child: Column(
                    children: [
                      const DayofWeek(),
                      const Divider(height: 0),
                      Row(
                        children: [
                          for(int i = 0; i<7; i++)
                            MonthDays(Provider.of<Cursor>(context).daylist()[i], box),
                        ],
                      ),
                      const Divider(height: 0),
                      Row(
                        children: [
                          for(int i = 7; i<14; i++)
                            MonthDays(Provider.of<Cursor>(context).daylist()[i], box),
                        ],
                      ),
                      const Divider(height: 0),
                      Row(
                        children: [
                          for(int i = 14; i<21; i++)
                            MonthDays(Provider.of<Cursor>(context).daylist()[i], box),
                        ],
                      ),
                      const Divider(height: 0),
                      Row(
                        children: [
                          for(int i = 21; i<28; i++)
                            MonthDays(Provider.of<Cursor>(context).daylist()[i], box),
                        ],
                      ),
                      const Divider(height: 0),
                      if(Provider.of<Cursor>(context).daylist()[28].day > 8)
                      Column(
                        children: [
                          Row(
                            children: [
                              for(int i = 28; i<35; i++)
                                MonthDays(Provider.of<Cursor>(context).daylist()[i], box),
                            ],
                          ),
                          const Divider(height: 0),
                        ],
                      ),
                      if(Provider.of<Cursor>(context).daylist()[35].day > 8)
                      Column(
                        children: [
                          Row(
                            children: [
                              for(int i = 35; i<42; i++)
                                MonthDays(Provider.of<Cursor>(context).daylist()[i], box),
                            ],
                          ),
                          const Divider(height: 0),
                        ],
                      ),
                    ],
                  ),
                ),
                AppBar(
                  elevation: 0,
                  backgroundColor: Pastel.orange,
                  title: const MyText("To-do", 15, Pastel.black),
                  centerTitle: true,
                  toolbarHeight: 25,
                ),

                Row(
                  children: [
                    FloatingActionButton(
                      onPressed: () async{
                        int i = 0;
                        if(box.containsKey(Provider.of<Cursor>(context, listen: false).returnAsString())) {
                          print("@@@@@@@@@@@@@@@@@");
                          // box.get("2022.12.25")!.add(ScheduleClass(name: "t$i", date: DateTime.now()));
                          var tmp = box.get(Provider.of<Cursor>(context, listen: false).returnAsString())!;
                          tmp.add(ScheduleClass(name: "t$i", date: DateTime.now()));
                          box.put(Provider.of<Cursor>(context, listen: false).returnAsString(), tmp);
                        }
                        else {
                          box.put(Provider.of<Cursor>(context, listen: false).returnAsString(), [ScheduleClass(name: "t$i", date: DateTime.now())]);
                        }
                        i++;
                        print("will be print get");
                        // for(int i = 0; i<box.length ; i++)
                        //   print(box.get(i)!.name);
                      },
                    ),
                    FloatingActionButton(onPressed: ()async{await box.clear();})
                  ],
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
                          validator: (text){
                            if(text!.isEmpty){
                              return;
                            }
                            return null;
                          },

                          onSaved: (text){
                            String scheduleDate = Provider.of<Cursor>(context, listen: false).returnAsString();

                            if(box.containsKey(scheduleDate)) {
                              List tmp = box.get(scheduleDate)!;
                              tmp.add(ScheduleClass(name: text!, date: DateTime.now()));
                              box.put(scheduleDate, tmp);
                              print("more than second @@@@@@@@@@@@@@@@@@@@@");
                            }
                            else {
                              List tmp = [ScheduleClass(name: text!, date: DateTime.now())];
                              box.put(scheduleDate, tmp);
                              print("first time @@@@@@@@@@@@@@@@@@@@@");
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
    );
  }
}