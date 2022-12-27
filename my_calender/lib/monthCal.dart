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
        valueListenable: Hive.box<List<ScheduleClass>>('lib').listenable(),
        builder: (context, Box<List<ScheduleClass>> box, child) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: GestureDetector(
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
                            MonthDays(Provider.of<Cursor>(context).daylist()[i]),
                        ],
                      ),
                      const Divider(height: 0),
                      Row(
                        children: [
                          for(int i = 7; i<14; i++)
                            MonthDays(Provider.of<Cursor>(context).daylist()[i]),
                        ],
                      ),
                      const Divider(height: 0),
                      Row(
                        children: [
                          for(int i = 14; i<21; i++)
                            MonthDays(Provider.of<Cursor>(context).daylist()[i]),
                        ],
                      ),
                      const Divider(height: 0),
                      Row(
                        children: [
                          for(int i = 21; i<28; i++)
                            MonthDays(Provider.of<Cursor>(context).daylist()[i]),
                        ],
                      ),
                      const Divider(height: 0),
                      if(Provider.of<Cursor>(context).daylist()[28].day > 8)
                      Column(
                        children: [
                          Row(
                            children: [
                              for(int i = 28; i<35; i++)
                                MonthDays(Provider.of<Cursor>(context).daylist()[i]),
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
                                MonthDays(Provider.of<Cursor>(context).daylist()[i]),
                            ],
                          ),
                          const Divider(height: 0),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                children: [
                  AppBar(
                    elevation: 0,
                    backgroundColor: Pastel.orange,
                    title: MyText("To-do", 15, Pastel.black),
                    centerTitle: true,
                    toolbarHeight: 25,
                  ),
                  ListView.builder(
                      // scrollDirection: Axis.vertical,
                      itemCount: 1, //나중에 hivebox의 list element개수로 바꾸기
                      itemBuilder: (BuildContext context, int idx){
                        return Container(
                          height: 25,
                          color: Pastel.green,
                          child: Text("test $idx"), // hive로 box.get(일자)[idx]
                        );
                      }
                  )
                ],
              ),
              FloatingActionButton(
                onPressed: () async{
                  int i = 0;
                  if(box.containsKey('2022.12.25')) {
                    print("@@@@@@@@@@@@@@@@@");
                    List<ScheduleClass> tmp = box.get("2022.12.25")!;
                    tmp.add(ScheduleClass(name: "t$i", date: DateTime.now()));
                    box.put("2022.12.25", tmp);
                  }
                  else {
                    List<ScheduleClass> tmp = [ScheduleClass(name: "t$i", date: DateTime.now())];
                    box.put("2022.12.25", tmp);
                  }
                  i++;
                  print(box.get("2022.12.25"));
                  // for(int i = 0; i<box.length ; i++)
                  //   print(box.get(i)!.name);
                },
              ),
              FloatingActionButton(onPressed: ()async{await box.clear();})
            ],
          );
        }
      ),
    );
  }
}