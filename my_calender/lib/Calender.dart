import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_calender/WeekAndMonth.dart';
import 'package:my_calender/bottomSheet.dart';
import 'package:my_calender/scheduleClass.dart';
import 'package:provider/provider.dart';
import 'package:my_calender/customclass/palette.dart';
import 'cursor.dart';
import 'customclass/CustomAppbar.dart';
import 'package:flutter/services.dart';
import 'customclass/calenderElement.dart';

class Calender extends StatefulWidget {
  const Calender({Key? key}) : super(key: key);

  @override
  State<Calender> createState() => _CalenderState();
}

class _CalenderState extends State<Calender> {
  final key = GlobalKey<FormState>();
  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  FocusNode myFocusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // if (key.currentState!.validate()) {
        //   print("@@@@@@@@@@@@@");
        //   key.currentState!.save();
        // }
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: CustomAppbar(scaffoldKey: scaffoldKey,), //custom appbar
        // drawer: CustomDrawer(),
        key: scaffoldKey,
        drawer: CustomDrawer(),
        body: ValueListenableBuilder(
            valueListenable: Hive.box<List>('lib').listenable(),
          builder: (context, Box<List> box, child) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Column(
                children: [
                  CalenderBanner(),
                  const DayofWeek(),
                  const Divider(height: 0),
                  AnimatedCrossFade(
                    duration: Duration(milliseconds: 200),
                    firstChild: MonthColumn(box),
                    secondChild: WeekColumn(box),
                    crossFadeState: Provider.of<Cursor>(context).isMonth
                      ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                  ),

                  const SizedBox(height: 5),
                  TodoBanner(),
                  Expanded(
                    child: CustomScrollView(
                      slivers: [
                        SliverFixedExtentList(
                          itemExtent: 35,
                          delegate: SliverChildBuilderDelegate((BuildContext context, int idx){
                            return Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: Pastel.grey, width: 0),
                                  color: Pastel.white,
                                ),
                                child: GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: (){
                                    showModalBottomSheet<void>(
                                        context: context,
                                        builder: (BuildContext context){
                                          return ScheduleEdit(box, idx);
                                        }
                                    );
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(5, 0, 10, 0),
                                        child: GestureDetector(
                                          onTap: (){
                                            print("icons tapped@@@@@@@@@@@@@@@");
                                          },
                                          child: ImageIcon(AssetImage("assets/icon/check_unchecked.png"), size: 20, color: Pastel.black,),
                                        ),
                                        ),
                                      Container(
                                          width: MediaQuery.of(context).size.width-100,
                                          alignment: Alignment.centerLeft,
                                          child: RichText(
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            text: TextSpan(
                                                text: "${box.get(Provider.of<Cursor>(context, listen: false).returnAsString())![idx].name}",
                                                style: TextStyle(
                                                  color: Pastel.black,
                                                  fontSize: 15,
                                                  fontFamily: "Myfont",
                                                )
                                            ),
                                          )
                                      ),
                                      const Spacer(),
                                      Padding(
                                        padding: EdgeInsets.only(right: 5),
                                        child: const Icon(Icons.edit, size: 20, color: Pastel.black,),
                                      ),
                                    ],
                                  ),
                                )
                              ),
                            );
                          },
                            childCount: box.get(Provider.of<Cursor>(context, listen: false).returnAsString()) == null ?
                            0 : box.get(Provider.of<Cursor>(context, listen: false).returnAsString())!.length,
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Container(
                              height: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: Pastel.grey, width: 0),
                                color: Pastel.white,
                              ),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(5, 0, 10, 0),
                                    child: ImageIcon(AssetImage("assets/icon/check_notwork.png"), size: 20, color: Pastel.grey,),
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      // autofocus: true,
                                      key: key,
                                      // autovalidateMode: AutovalidateMode.always,
                                      textAlignVertical: TextAlignVertical.center,
                                      style: TextStyle(fontSize: 15),
                                      controller: TextEditingController(),
                                      focusNode: myFocusNode,
                                      cursorColor: Pastel.grey,
                                      decoration: InputDecoration(
                                        hintText: "새 일정",
                                        border: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.transparent
                                          ),
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.transparent
                                          ),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.transparent
                                          ),
                                        ),
                                        isCollapsed: true
                                      ),
                                      validator: (text) {
                                        if(text!.isEmpty) {
                                          return "null";
                                        }
                                        return null;
                                      },
                                      onFieldSubmitted: (text) {
                                        if(text.isEmpty) {
                                          FocusManager.instance.primaryFocus?.unfocus();
                                          return;
                                        }
                                        String scheduleDate = Provider.of<Cursor>(context, listen: false).returnAsString();

                                        if(box.containsKey(scheduleDate)) {
                                          List tmp = box.get(scheduleDate)!;
                                          tmp.add(ScheduleClass(name: text, date: Provider.of<Cursor>(context, listen: false).selected));
                                          box.put(scheduleDate, tmp);
                                        }
                                        else {
                                          List tmp = [ScheduleClass(name: text, date: Provider.of<Cursor>(context, listen: false).selected)];
                                          box.put(scheduleDate, tmp);
                                        }
                                        myFocusNode.requestFocus();
                                      },
                                      onSaved: (text){
                                        if(text!.isEmpty) {
                                          FocusManager.instance.primaryFocus?.unfocus();
                                          return;
                                        }
                                        String scheduleDate = Provider.of<Cursor>(context, listen: false).returnAsString();

                                        if(box.containsKey(scheduleDate)) {
                                          List tmp = box.get(scheduleDate)!;
                                          tmp.add(ScheduleClass(name: text, date: DateTime.now()));
                                          box.put(scheduleDate, tmp);
                                        }
                                        else {
                                          List tmp = [ScheduleClass(name: text, date: DateTime.now())];
                                          box.put(scheduleDate, tmp);
                                        }
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(right: 5),
                                    child: GestureDetector(
                                      onTap: () {
                                        String scheduleDate = Provider.of<Cursor>(context, listen: false).returnAsString();
                                        showModalBottomSheet<void>(
                                            context: context,
                                            builder: (BuildContext context){
                                              if(!box.containsKey(scheduleDate)) {
                                                return ScheduleEdit(box, 0);
                                              }
                                              return ScheduleEdit(box, box.get(scheduleDate)!.length);
                                            }
                                        );
                                      },
                                      child: const Icon(Icons.edit, size: 20, color: Pastel.grey,),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        ),
      ),
    );
  }
}