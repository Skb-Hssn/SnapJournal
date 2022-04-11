// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snapjournal/Model/Event/Bloc/eventview_bloc.dart';
import '../Event/event_view.dart';

class DayView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DayView();  
}

class _DayView extends State<StatefulWidget> {

  late List<EventView> L = [EventView(), EventView()];
  late List<BlocProvider> B = [BlocProvider(create: (BuildContext context) => EventViewBloc(),
                                            child: EventView())];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(DateTime.now().toIso8601String()),
      ),
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: L.length,
        itemBuilder: (BuildContext context, int index) {
          return L[index];
        },
      ),
    );

    /*
    return Scaffold(
      appBar: AppBar(
        title: Text('ABC'),
      ),
      body: Stack(
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          Center(
            child: Image(
              image: AssetImage('assets/images/im9.jpeg'),
            ),
          ),
          Positioned(
            right: 20,
            child: Container(
              height: 0,
              width: 0,
              color: Colors.blue,
            ),
          ),

          Center(
            child: InkWell (
              onDoubleTap: () {
                print('Double');
              },
              splashColor: Colors.grey,
              child: Container(
                height: 400,
                width: 300,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(0, 0, 0, 0.7),
                  border: Border.all(
                    color: Colors.black,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(20))
                ),
                child: Column (
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    TextButton(
                      onPressed: () {}, 
                      child: Text('X') ,
                    ),

                    SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Text('''
                      AB CD
                      EF GH
                      IJ KL
                      MN OP
                      QE DS
                      LL AA
                      WW WE
                    ''',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    ),
                    ),
                  ]
                ),
              ),
            ),
          ),
        ],
      ),
    ); */
  }
}