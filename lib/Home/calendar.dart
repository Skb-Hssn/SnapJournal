import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:snapjournal/SnapJournal/constants/enums.dart';
import 'package:table_calendar/table_calendar.dart';

import '../Model/day_model.dart';

class CalendarView extends StatefulWidget {

  @override
  createState() => _CalenderView();
}

class _CalenderView extends State<CalendarView> {

  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(darkViolet),
        title: const Text('Calendar'),
      ),
      body: TableCalendar(
        firstDay: DateTime.utc(2000, 1, 1),
        lastDay: DateTime.utc(DateTime.now().year,
                              DateTime.now().month,
                              DateTime.now().day),
        focusedDay: focusedDay,
        calendarFormat: format,
        onFormatChanged: (CalendarFormat _format) {
          setState(() {
            format = _format;
          });
        },
        onDaySelected: (DateTime selectedDay, DateTime focusDay) {
          setState(() {
            Navigator.pushNamed(
              context, 
              '/dayView',
              arguments: {
                'initialPage': 0,
                'date': Day.getDateFormat(focusDay),
              }
            );
          });
        },
      ),
    );
  }
}