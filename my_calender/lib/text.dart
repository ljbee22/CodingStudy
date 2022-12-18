import 'package:flutter/material.dart';

class MyText extends StatelessWidget {
  String t;
  double fsize;
  MyText(this.t, this.fsize, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      t,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: fsize,
        color: const Color(0xff202020)
      ),
    );
  }
}
