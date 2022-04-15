// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Database/database.dart';
import '../Event/Bloc/eventview_bloc.dart';
import '../Event/event_view.dart';
import '../Model/day_model.dart';
import '../Model/text_model.dart';

class DayView extends StatefulWidget {
  late String date;
  DayView({Key? key, required this.date}) : super(key: key);


  @override
  State<StatefulWidget> createState() => _DayView(date: date);  
}

class _DayView extends State<StatefulWidget> {

  late String date;
  late List<EventView> events = [];
  int initialPage = 0;
  int currentIndex = 0;
  PageController controller = PageController(initialPage: 2);

  _DayView({required this.date});

  @override
  void initState() {
    super.initState();
    refreshState();
  }

  Future refreshState() async {
    var eventIdList = await DB.instance.fetchDay(date);

    if(eventIdList.isEmpty) {
      addEvent();
    } else {
      for(var e in eventIdList) {
        events.add(EventView(id: e));
      }
    }

    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(DateTime.now().year.toString()),
        actions: [
          IconButton(
            onPressed: () {
              deleteEvent(currentIndex);
            }, 
            icon: Icon(
              Icons.delete,
            ),
          ),
          IconButton(
            onPressed: () {
              addEvent();
            },
            icon: Icon(
              Icons.add
            )
          )
        ],
      ),
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        controller: controller,
        itemCount: events.length,
        itemBuilder: (BuildContext context, int index) {
          currentIndex = index;
          return events[index];
        },
      ),
    );
  }

  Future addEvent() async {
    var nextEventId = await DB.instance.nextEventId();
    events.add(EventView(id: nextEventId));
    await DB.instance.insertDayEvent(Day.allFields(dayid: date, eventid: nextEventId));
    await DB.instance.insertText(EventText.allFields(eventId: nextEventId, text: ''));
    controller = PageController(initialPage: events.length-1);

    setState(() {
    });
  }

  Future deleteEvent(int index) async {
    // events[index].evs.deleteEvent();
    print('Index: $index');
    events.removeAt(index);
    setState(() {
    });
  }
}