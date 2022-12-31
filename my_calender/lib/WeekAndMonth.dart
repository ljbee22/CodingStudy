import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:my_calender/customclass/OneDay.dart';
import 'package:provider/provider.dart';

import 'cursor.dart';

class WeekColumn extends StatelessWidget {
  final Box box;
  const WeekColumn(this.box, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            for(int i = (Provider.of<Cursor>(context).dayofweek()-1) * 7 ;
            i < Provider.of<Cursor>(context).dayofweek() * 7; i++)
              OneDay(Provider.of<Cursor>(context).daylist()[i], box),
          ],
        ),
        const Divider(height: 0),
      ],
    );
  }
}

class MonthColumn extends StatelessWidget {
  final Box box;
  const MonthColumn(this.box, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            for (int i = 0; i < 7; i++)
              OneDay(
                  Provider.of<Cursor>(context).daylist()[i],
                  box),
          ],
        ),
        const Divider(height: 0),
        Row(
          children: [
            for (int i = 7; i < 14; i++)
              OneDay(
                  Provider.of<Cursor>(context).daylist()[i],
                  box),
          ],
        ),
        const Divider(height: 0),
        Row(
          children: [
            for (int i = 14; i < 21; i++)
              OneDay(
                  Provider.of<Cursor>(context).daylist()[i],
                  box),
          ],
        ),
        const Divider(height: 0),
        Row(
          children: [
            for (int i = 21; i < 28; i++)
              OneDay(
                  Provider.of<Cursor>(context).daylist()[i],
                  box),
          ],
        ),
        const Divider(height: 0),
        if (Provider.of<Cursor>(context).daylist()[28].day > 8)
          Column(
            children: [
              Row(
                children: [
                  for (int i = 28; i < 35; i++)
                    OneDay(
                        Provider.of<Cursor>(context)
                            .daylist()[i],
                        box),
                ],
              ),
              const Divider(height: 0),
            ],
          ),
        if (Provider.of<Cursor>(context).daylist()[35].day > 8)
          Column(
            children: [
              Row(
                children: [
                  for (int i = 35; i < 42; i++)
                    OneDay(
                        Provider.of<Cursor>(context)
                            .daylist()[i],
                        box),
                ],
              ),
              const Divider(height: 0),
            ],
          ),
      ],
    );
  }
}

