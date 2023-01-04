import 'package:flutter/material.dart';

class CustomToggle extends StatefulWidget {
  bool isLeft;
  CustomToggle(this.isLeft, {Key? key}) : super(key: key);

  @override
  State<CustomToggle> createState() => _CustomToggleState();
}

class _CustomToggleState extends State<CustomToggle> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: (){
        widget.isLeft = !widget.isLeft;
        setState(() {});
      },
      child: AnimatedContainer(
        width: 90,
        height: 44,
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(70),
          color: widget.isLeft? Colors.grey : Colors.green,
        ),
        child: AnimatedAlign(
            alignment: widget.isLeft ? Alignment.centerLeft : Alignment.centerRight,
            duration: const Duration(milliseconds: 200),
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
            )
        ),
      ),
    );
  }
}
