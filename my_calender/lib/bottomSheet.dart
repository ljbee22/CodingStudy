import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Stack(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(Icons.check_circle_outline),
                onPressed: (){
                  print(widget.idx);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
