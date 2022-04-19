// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snapjournal/Day/Bloc/day_bloc.dart';
import 'package:snapjournal/SnapJournal/constants/enums.dart';
import '../Database/database.dart';
import '../Event/Bloc/eventview_bloc.dart';
import '../Event/event_view.dart';
import '../Model/day_model.dart';
import '../Model/text_model.dart';

class TaggedEventView extends StatefulWidget {
  List<String> eventIDs;
  TaggedEventView({Key? key, required this.eventIDs}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TaggedEventView(eventIDs: eventIDs);
}

class _TaggedEventView extends State<StatefulWidget> {

  List<String> eventIDs;

  _TaggedEventView({required this.eventIDs});

  final String initialPageString = 'initialPage';
  final String  dateString = 'date';

  String? date;
  late List<EventView> events = [];
  int initialPage = 0;
  int currentIndex = 0;
  PageController controller = PageController(initialPage: 0);
  Map arguments = {};

  bool init = true;

  bool loading = true;

  @override
  void initState() {
    super.initState();
    loading = true;
    if(!init) {
      refreshState();
    }
  }

  Future refreshState() async {
    if(events.isNotEmpty) return;

    List<int> eventIDlist = [];

    for(var i in eventIDs){
      eventIDlist.add(int.parse(i));
    }

    if(eventIDlist.isEmpty) {
      // await addEvent();
    } else {
      for(var e in eventIDlist) {
        events.add(EventView(id: e));
      }
    }

    if(mounted) {
      setState(() {loading = false;});
    }
  }

  Future fetchArguments(BuildContext context) async {
    arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;

    if(arguments[initialPageString] == null) arguments[initialPageString] = 0;
    if(arguments[dateString] == null) arguments[dateString] = Day.getDateFormat(DateTime.now());

    initialPage = arguments[initialPageString];

    date = arguments[dateString];

    await refreshState();

    if(initialPage == -1) {
      initialPage = events.length + 1;
      await addEvent();
    }

    controller = PageController(initialPage: initialPage);

    if(mounted) {
      setState(() {loading = false;});
    }
  }

  @override
  Widget build(BuildContext context) {

    if(init) {
      fetchArguments(context);
      init = false;
    }

    return loading? Center(child: CircularProgressIndicator())
        :BlocProvider(create: (BuildContext context) => DayBloc(events: events),
      child: BlocBuilder<DayBloc, DayState>(
        builder: (context, state){
          return Scaffold(
            appBar: AppBar(
              title: Text(""),
              backgroundColor: Color(darkVioletOp),
            ),
            body: PageView.builder(
              scrollDirection: Axis.vertical,
              controller: controller,
              itemCount: events.length,//events.length,
              itemBuilder: (BuildContext context, int index) {
                return events[index];
              },
              onPageChanged: (int ind) {
                currentIndex = ind;
              },
            ),
          );
        },),
    );

  }

  Future addEvent() async {
    var nextEventId = await DB.instance.nextEventId();
    await DB.instance.insertDayEvent(Day.allFields(dayid: date, eventid: nextEventId));
    await DB.instance.insertText(EventText.allFields(eventId: nextEventId, text: ''));

    Navigator.pushReplacementNamed(context, '/dayView',
        arguments: {
          'initialPage': events.length+1,
          'date': date,
        }
    );
  }

  Future deleteEvent(int index, BuildContext context) async {
    await DB.instance.deleteDayEvent(Day.allFields(dayid: date, eventid: events[index].id));
    await events[index].ev.deleteEvent();

    Navigator.pushReplacementNamed(this.context, '/dayView',
        arguments: {
          'initialPage': index+1,
          'date': date,
        }
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}