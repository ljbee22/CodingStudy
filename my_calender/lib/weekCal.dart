import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_calender/scheduleClass.dart';
import 'package:provider/provider.dart';
import 'package:my_calender/customclass/palette.dart';
import 'cursor.dart';
import 'customclass/calenderElement.dart';
import 'customclass/customContainer.dart';

class WeekCal extends StatefulWidget {
  const WeekCal({Key? key}) : super(key: key);

  @override
  State<WeekCal> createState() => _WeekCalState();
}

class _WeekCalState extends State<WeekCal> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WeekAppbar(appbar: AppBar()), //custom appbar
      body: ValueListenableBuilder(
          valueListenable: Hive.box<List>('lib').listenable(),
        builder: (context, Box<List> box, child) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Column(
              children: [
                const SizedBox(height: 5,),
                const DayofWeek(),
                const SizedBox(height: 5,),
                const Divider(height: 0),
                Row(
                  children: [
                    for(int i = (Provider.of<Cursor>(context).dayofweek()-1) * 7 ;
                    i < Provider.of<Cursor>(context).dayofweek() * 7; i++)
                      WeekDays(Provider.of<Cursor>(context).daylist()[i], box),
                  ],
                ),
                const Divider(height: 0),
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
