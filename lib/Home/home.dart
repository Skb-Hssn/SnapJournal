// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:snapjournal/TagSearch/tagsearch.dart';

import '../Model/day_model.dart';
import '../SnapJournal/constants/enums.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _Home();
}

class _Home extends State<Home> {

  bool loggedIn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Color(darkViolet).withOpacity(1.0),
                  Color(darkViolet).withOpacity(1.0),
                  Color(VioletAccent).withOpacity(0.9)
                ],
                begin: FractionalOffset(0.0, 0.4),
                end: Alignment.topRight
            )
        ),
        child: Column(
          children: [
            SizedBox(height: 20,),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 20,
              alignment: Alignment.topRight,
              child: loggedIn ? IconButton(
                icon: Icon(Icons.logout),
                color: Colors.white,
                onPressed: () {},
              ) : IconButton(
                icon: Icon(Icons.password),
                color: Colors.white,
                onPressed: () {},
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.35,
              child:Center(
                child: Text(
                  "Snapjounal",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 50,
                    fontFamily: 'OpenSansBold',
                  ),
                ),
              )
            ),
            Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(70),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      )
                    ],
                  ),
                  child: GridView.count(
                    padding: EdgeInsets.all(30),
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    children: [
                      Card(
                        color: Color(PasteAccent),
                        child: InkWell(
                          onTap: () => viewTadaysDay(context),
                          child: Center(
                            child: Icon(
                              Icons.preview,
                              size: 50,
                            ),
                          )
                        ),
                      ),
                      Card(
                        color: Color(SkyBlueAccent),
                        child: InkWell(
                          onTap: () => addToTodaysDay(context),
                          child: Center(
                            child: Icon(
                              Icons.add,
                              size: 50,
                            ),
                          )

                        ),
                      ),
                      Card(
                        color: Color(LightViolet),
                        child: InkWell(
                          onTap: () => goToCalenderView(context),
                          child: Center(
                            child: Icon(
                              Icons.calendar_month,
                              size: 50,
                            ),
                          )
                        ),
                      ),
                      Card(
                        color: Color(Orangish),
                        child: InkWell(
                          child: Center(
                            child: Icon(
                              Icons.search,
                              size: 50,
                            ),
                          )

                        ),
                      ),
                    ],
                  ),
                )
            )
          ],
        ),
      ),
    );
  }

  void viewTadaysDay(BuildContext context) {
    Navigator.pushNamed(context, '/dayView',
      arguments: {
        'initialPage': 0,
        'date': Day.getDateFormat(DateTime.now()),
      }
    );
  }

  void addToTodaysDay(BuildContext context) {
    Navigator.pushNamed(context, '/dayView',
      arguments: {
        'initialPage': -1,
        'date': Day.getDateFormat(DateTime.now()),
      }
    );
  }

  void goToCalenderView(BuildContext context) {
    Navigator.pushNamed(context, '/calendarView');
  }
}