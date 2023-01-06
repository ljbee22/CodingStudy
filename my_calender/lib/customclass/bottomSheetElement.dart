import 'package:flutter/material.dart';

class CustomToggle extends StatefulWidget {
  bool isRight;
  CustomToggle(this.isRight, {Key? key}) : super(key: key);

  @override
  State<CustomToggle> createState() => _CustomToggleState();
}

class _CustomToggleState extends State<CustomToggle> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      width: 55,
      height: 30,
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: !widget.isRight? Colors.grey : Colors.green,
      ),
      child: AnimatedAlign(
          alignment: !widget.isRight ? Alignment.centerLeft : Alignment.centerRight,
          duration: const Duration(milliseconds: 200),
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Container(
              width: 25,
              height: 25,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),
          )
      ),
    );
  }
}
