// ignore_for_file: no_logic_in_create_state

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:snapjournal/Model/Event/Bloc/eventview_state.dart';

import 'Bloc/eventview_bloc.dart';

class EventView extends StatefulWidget {

  late List<File> pictures = [];
  late List<String> texts = [];
  late List<String> pictureTimes = [];
  late int id = 0;

  EventView({Key? key}) : super(key: key);

  EventView.all({Key? key, required this.pictures, required this.texts, required this.pictureTimes, required this.id}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EventView.all(
                                              pictures: pictures, 
                                              texts: texts, 
                                              pictureTimes: pictureTimes,
                                              id: id);
}

class _EventView extends State<EventView> {

  late List<File> pictures = [];
  late List<String> texts = [];
  late List<String> pictureTimes = [];
  late int id = 0;
  int initialPage = 0;

  bool deleteButtonVis = false;
  bool imageTextVis = false;
  bool editImageTextVis = false;

  String curText = '';

  _EventView.all({required this.pictures, required this.texts, required this.pictureTimes, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: PageController(initialPage: initialPage),
        scrollDirection: Axis.horizontal,
        itemCount: pictures.length+1,
        itemBuilder: (BuildContext context, int index) {
          if(index == pictures.length) {
            return Center(
              child: IconButton(
                icon: const Icon(
                  Icons.add_a_photo,
                ),
                onPressed: () {
                  addPicture();
                },
              ),
            );
          } else {
            return Stack (
              children: [
                InkWell(
                  onDoubleTap: () {
                    if(imageTextVis) {
                      setState(() {
                        imageTextVis = false;
                      });
                    } else {
                      setState(() {
                        imageTextVis = true;
                      });
                    }
                  },

                  onTap: () {
                    if(deleteButtonVis) {
                      setState(() {
                        deleteButtonVis = false;
                      });
                    } else {
                      setState(() {
                        deleteButtonVis = true;
                      });
                    }
                  },

                  child: Center(
                    child: Image.file(pictures[index]),
                  ),
                ),

                deleteButton(index),

                imageText(index),

                editImageText(index),
              ],
            );
          }
        },
      ),
    );
  }

  Future addPicture() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    if(image == null) return;

    setState(() {
      pictures.add(File(image.path));
      texts.add("");
      pictureTimes.add(DateFormat.Hms().format(DateTime.now()));
    });
  }

  Widget deleteButton(int index) {
    return Visibility(
      visible: deleteButtonVis,
      child: Positioned(
        right: 20,
        top: 20,
        child: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
          },
        ),
      ),
    );
  }

  Widget imageText(int index) {
    return Visibility(
      visible: imageTextVis,
      child: Center(
        child: InkWell(
          onDoubleTap: () {
            setState(() {
              editImageTextVis ^= true;
            });
          },
          child: Container(
            height: 500,
            width: 300,
            padding: EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: Color.fromRGBO(0, 0, 0, 0.7),
              border: Border.all(
                color: Colors.black,
              ),
              borderRadius: BorderRadius.all(Radius.circular(20))
            ),

            child: SingleChildScrollView(
              child: Text(
                texts[index],
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget editImageText(int index) {
    return Visibility(
      visible: editImageTextVis,
      child: Center(
        child: InkWell(
          child: Container(
            height: 500,
            width: 300,
            decoration: BoxDecoration(
            color: const Color.fromRGBO(0, 0, 0, 1.0),
            border: Border.all(
              color: Colors.black,
            ),
            borderRadius: BorderRadius.all(Radius.circular(20))),

            child: Column(
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      texts[index] = curText;
                      curText = '';
                      editImageTextVis = false;
                      imageTextVis = true;
                    });
                  }, 
                  icon: const Icon(
                      Icons.check,
                      color: Colors.white,
                  ),
                ),
                Form(
                  child: TextFormField(
                    initialValue: texts[index],
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                    onChanged: (String text) {
                      curText = text;
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}