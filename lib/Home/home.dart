import 'package:flutter/material.dart';
import 'package:path/path.dart';

import '../SnapJournal/constants/enums.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(VioletAccent).withOpacity(0.55),
        title: Text("Home"),
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Color(VioletAccent).withOpacity(0.9),
                  Color(VioletAccent).withOpacity(0.6)
                ],
                begin: FractionalOffset(0.0, 0.4),
                end: Alignment.topRight
            )
        ),
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.3,
              child:Center(
                child: Text(
                  "Snapjounal",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 50,
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
                    )
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 15),
                      Padding(
                        padding: EdgeInsets.all(15.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(420, 60),// fromHeight use double.infinity as width and 40 is the height
                          ),
                          onPressed: () {},
                          child: Text('Button 1'),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(15.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(420, 60),// fromHeight use double.infinity as width and 40 is the height
                          ),
                          onPressed: () {},
                          child: Text('Button 1'),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(15.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(420, 60),// fromHeight use double.infinity as width and 40 is the height
                          ),
                          onPressed: () {},
                          child: Text('Button 1'),
                        ),
                      ),

                      Row(
                        children:  [
                          Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Text(
                              "Tag",
                              style: TextStyle(
                                fontSize: 35,
                                fontWeight: FontWeight.bold,
                                color: Colors.black
                              ),
                            ),
                          ),
                          Align(
                            child: Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Icon(
                                Icons.search
                              )
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                )
            )
          ],
        ),
      ),
    );
  }
}