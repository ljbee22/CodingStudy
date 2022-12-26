import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Column(
              children: [
                const DayofWeek(),
                const Divider(height: 0),
                Row(
                  children: [
                    for(int i = (Provider.of<Cursor>(context).dayofweek()-1) * 7 ;
                    i < Provider.of<Cursor>(context).dayofweek() * 7; i++)
                      WeekDays(Provider.of<Cursor>(context).daylist()[i]),
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
