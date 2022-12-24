import 'package:flutter/material.dart';
import 'cursor.dart';
import 'customclass/calenderElement.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'customclass/customContainer.dart';
import 'package:provider/provider.dart';
import 'scheduleClass.dart';

// var now = DateTime.now();
class MonthCal extends StatefulWidget {
  const MonthCal({Key? key}) : super(key: key);

  @override
  State<MonthCal> createState() => _MonthCalState();
}

class _MonthCalState extends State<MonthCal> {
  var box = HiveBox().openHive();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MonthAppbar(appbar: AppBar()), //custom appbar
      body: Column(
        children: [
          Container(
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
              Container(
                color: Color(0xFFFFB6B9),
                child: Text('할 일'),
              ),
              Container(
                child: Text(box.get('일정 1')),
              )
            ],
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          await box.then((value) {
            value.put('일정 1', '밥먹기');
          });
        },
      ),
    );
  }
}
