// ignore_for_file: no_logic_in_create_state

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:snapjournal/Model/event_image_row.dart';


import '../../Database/database.dart';
import '../Model/photo_model.dart';
import '../Model/text_model.dart';
import 'Bloc/eventview_bloc.dart';

class EventView extends StatefulWidget {

  late int id = 0;

  EventView({Key? key, required this.id}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EventView(id: id);
}

class _EventView extends State<EventView> {

  late List<FileImage?> pictures = [];
  late List<int?> pictureIds = [];
  String eventText = '';
  late int id = 0;

  String curText = '';

  int initialPage = 0;

  bool deleteButtonVis = false;
  bool imageTextVis = false;
  bool editImageTextVis = false;

  _EventView({required this.id});

  @override
  void initState() {
    super.initState();

    refreshState();
  }

  Future refreshState() async {

    var imageIdList = await DB.instance.getImageId(id);
    for(int i in imageIdList) {
      var P = Photo.fromJson(await DB.instance.getImage(i));
      pictures.add(P.image);
      pictureIds.add(P.id);
    }
    eventText = await DB.instance.readText(id);

    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: PageController(initialPage: initialPage),
        scrollDirection: Axis.horizontal,
        itemCount: pictures.length+1,
        itemBuilder: (BuildContext context, int index) {
          if(index >= pictures.length) {
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
                    child:  Image(
                      image: pictures[index]!,
                    )
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

  Future updateText() async {
    await DB.instance.deleteText(id);
    await DB.instance.insertText(EventText.allFields(eventId: id, text: eventText));
  }

  Future deleteImage(int index) async {
    int imageId = pictureIds[index]!;

    pictures.removeAt(index);
    pictureIds.removeAt(index);


    await DB.instance.deleteEventImageRow(EventImageRow.allFields(eventId: id, imageId: imageId));
    await Photo.deleteImage(imageId);

    setState(() {});
  }


  Future addPicture() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    if(image == null) return;

    var P = Photo.allFields(xFileimage: image);
    await P.saveToDatabase();

    var X = Photo.fromJson(await DB.instance.getImage(P.id!));

    pictures.add(X.image);
    pictureIds.add(P.id);

    EventImageRow.allFields(eventId: id, imageId: P.id).saveToDatabase();

    setState(() {
    });
  }

  Widget deleteButton(int index) {
    return Visibility(
      visible: deleteButtonVis,
      child: Positioned(
        right: 20,
        top: 20,
        child: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            deleteImage(index);
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
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(0, 0, 0, 0.7),
              border: Border.all(
                color: Colors.black,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(20))
            ),

            child: SingleChildScrollView(
              child: Text(
                eventText,
                style: const TextStyle(
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
            borderRadius: const BorderRadius.all(Radius.circular(20))),

            child: Column(
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      eventText = curText;
                      curText = '';
                      editImageTextVis = false;
                      imageTextVis = true;
                      updateText();
                    });
                  }, 
                  icon: const Icon(
                      Icons.check,
                      color: Colors.white,
                  ),
                ),
                Form(
                  child: TextFormField(
                    initialValue: eventText,
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