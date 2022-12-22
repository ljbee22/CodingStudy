import 'package:flutter/material.dart';
import 'cursor.dart';
import 'customclass/calender_element.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'customclass/customContainer.dart';
import 'package:provider/provider.dart';

// var now = DateTime.now();
class MonthCal extends StatefulWidget {
  const MonthCal({Key? key}) : super(key: key);

  @override
  State<MonthCal> createState() => _MonthCalState();
}

class _MonthCalState extends State<MonthCal> {
  // List<DateTime> daylist = Provider.of<Cursor>(context).daylist();
  // DateTime isCursor = cursor.selected;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAE3D9),
        elevation: 0,
        title: MyText(
            "${Provider.of<Cursor>(context).selected.month}월 ${Provider.of<Cursor>(context).dayofweek()}주차", 22
        )
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Column(
          children: [
            const DayofWeek(),
            const DivBox(),
            Row(
              children: [
                for(int i = 0; i<7; i++)
                  EveryDay(Provider.of<Cursor>(context).daylist()[i]),
              ],
            ),
            const DivBox(),
            Row(
              children: [
                for(int i = 7; i<14; i++)
                  EveryDay(Provider.of<Cursor>(context).daylist()[i]),
              ],
            ),
            const DivBox(),
            Row(
              children: [
                for(int i = 14; i<21; i++)
                  EveryDay(Provider.of<Cursor>(context).daylist()[i]),
              ],
            ),
            const DivBox(),
            Row(
              children: [
                for(int i = 21; i<28; i++)
                  EveryDay(Provider.of<Cursor>(context).daylist()[i]),
              ],
            ),
            const DivBox(),
            if(Provider.of<Cursor>(context).daylist()[28].day > 8)
            Column(
              children: [
                Row(
                  children: [
                    for(int i = 28; i<35; i++)
                      EveryDay(Provider.of<Cursor>(context).daylist()[i]),
                  ],
                ),
                const DivBox(),
              ],
            ),
            if(Provider.of<Cursor>(context).daylist()[35].day > 8)
            Column(
              children: [
                Row(
                  children: [
                    for(int i = 35; i<42; i++)
                      EveryDay(Provider.of<Cursor>(context).daylist()[i]),
                  ],
                ),
                const Divider(height: 0),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
            Provider.of<Cursor>(context, listen: false).changeCursor(DateTime(2022,5,2));
        },
      ),
    );
  }
}
