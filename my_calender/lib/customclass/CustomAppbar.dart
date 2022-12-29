import 'package:flutter/material.dart';
import 'package:my_calender/customclass/calenderElement.dart';
import 'package:provider/provider.dart';
import '../cursor.dart';
import 'palette.dart';

class CustomAppbar extends StatelessWidget implements PreferredSize{
  final GlobalKey<ScaffoldState> scaffoldKey;
  const CustomAppbar({Key? key, required this.scaffoldKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Stack(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(onPressed: () {
                    print('@@@@@@@@@@@');
                    scaffoldKey.currentState?.openDrawer();
                  },
                    icon: Icon(Icons.linear_scale, color: Pastel.blacksoft),
                ),
              ),
              Positioned(
                right: 30,
                child: IconButton(
                  alignment: Alignment.centerRight,
                    visualDensity: const VisualDensity(horizontal: -4.0),
                    onPressed: () {
                      Provider.of<Cursor>(context, listen: false).changeIsMonth();
                    }, icon: const Icon(Icons.change_circle_rounded), color: Pastel.blacksoft),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  alignment: Alignment.centerRight,
                  visualDensity: const VisualDensity(horizontal: -4.0),
                  icon: const Icon(Icons.today, color: Pastel.blacksoft,),
                  onPressed: () {
                    Provider.of<Cursor>(context, listen: false).changeCursor(DateTime.now());
                  },
                ),
              ),
            ],
          ),
          Container(
            color: Pastel.pink,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(onPressed: () {
                  Provider.of<Cursor>(context, listen: false).plusMonth(false);
                }, icon: Icon(Icons.arrow_back_rounded, size: 16,), color: Pastel.blacksoft,),
                Provider.of<Cursor>(context, listen: false).isMonth
                ? MyText("${Provider.of<Cursor>(context).selected.year}년 ${Provider.of<Cursor>(context).selected.month}월", 17, Pastel.black)
                : MyText("${Provider.of<Cursor>(context).selected.year}년 ${Provider.of<Cursor>(context).selected.month}월 "
                    "${Provider.of<Cursor>(context).dayofweek()}주차", 17, Pastel.black),
                IconButton(onPressed: () {
                  Provider.of<Cursor>(context, listen: false).plusMonth(true);
                }, icon: Icon(Icons.arrow_forward_rounded, size: 16,), color: Pastel.blacksoft,),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);

  @override
  // TODO: implement child : 몰라서 임시로 Container() 넣음
  Widget get child => Container();
}

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Pastel.orange,
      child: Text('Hello'),
    );
  }
}
