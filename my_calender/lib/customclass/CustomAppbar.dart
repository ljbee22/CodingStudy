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
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      title: Stack(
        children: [
          // Align(
          //   alignment: Alignment.centerLeft,
          //   child: IconButton(onPressed: () {
          //       print('@@@@@@@@@@@');
          //       scaffoldKey.currentState?.openDrawer();
          //     },
          //       icon: Icon(Icons.linear_scale, color: Pastel.blacksoft),
          //   ),
          // ),
          Positioned(
            right: 30,
            child: IconButton(
              alignment: Alignment.centerRight,
              visualDensity: const VisualDensity(horizontal: -4.0),
              onPressed: () {
                Provider.of<Cursor>(context, listen: false).changeIsMonth();
              },
              icon: const Icon(Icons.change_circle_rounded), color: Pastel.blacksoft),
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
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(40);

  @override
  // TODO: implement child : 몰라서 임시로 Container() 넣음
  Widget get child => Container();
}

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Drawer(
      backgroundColor: Pastel.orange,
      child: Text('Hello'),
    );
  }
}
