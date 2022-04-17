// ignore_for_file: no_logic_in_create_state

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:snapjournal/Model/event_image_row.dart';


import '../../Database/database.dart';
import '../Model/photo_model.dart';
import '../Model/tag_model.dart';
import '../Model/text_model.dart';
import 'Bloc/eventview_bloc.dart';

class EventView extends StatefulWidget {

  late int id = 0;
  bool isEmpty = false;

  late _EventView ev;

  EventView({Key? key, required this.id}) : super(key: key);

  @override
  State<StatefulWidget> createState() { 
    ev = _EventView(id: id);
    return ev;
  }
}


class _EventView extends State<EventView> {

  late List<FileImage?> pictures = [];
  late List<int?> pictureIds = [];
  String eventText = '';
  late int id = 0;

  late List<Item> tagsItemList = [];
  final GlobalKey<TagsState> _globalKey = GlobalKey<TagsState>();

  String curText = '';

  int initialPage = 0;

  bool deleteButtonVis = false;
  bool imageTextVis = false;
  bool editImageTextVis = false;
  bool tagFieldVis = false;

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
    await readTag();
    if(mounted) {
      setState(() {});
    }
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
            // if(pictures.isNotEmpty || checkEmpty()) {
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
                      if(mounted) {
                        setState(() {
                        imageTextVis = false;
                      });
                      }
                    } else {
                      if(mounted) {
                      setState(() {
                        imageTextVis = true;
                      });
                      }
                    }
                  },

                  onTap: () {
                    if(mounted) {
                      setState(() {

                        tagFieldVis = !tagFieldVis;
                      });
                    }

                    if(deleteButtonVis) {
                      if(mounted) {
                      setState(() {
                        deleteButtonVis = false;
                      });
                      }
                    } else {
                      if(mounted) {
                      setState(() {
                        deleteButtonVis = true;
                      });
                      }
                    }
                  },

                  child: Center(
                    child:  Image(
                      image: pictures[index]!,
                    )
                  ),
                ),

                deleteButton(index),

                imageText(),

                editImageText(),
                
                tagsview(),
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

    checkEmpty();

    if(mounted) {
      setState(() {});
    }
  }


  Future addPicture() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 25);
    if(image == null) return;

    var P = Photo.allFields(xFileimage: image);
    await P.saveToDatabase();

    var X = Photo.fromJson(await DB.instance.getImage(P.id!));

    pictures.add(X.image);
    pictureIds.add(P.id);

    EventImageRow.allFields(eventId: id, imageId: P.id).saveToDatabase();

    if(mounted) {
    setState(() {
    });
    }
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
            //readTag();
          },
        ),
      ),
    );
  }

  Widget imageText() {
    return Visibility(
      visible: imageTextVis,
      child: Center(
        child: InkWell(
          onDoubleTap: () {
            if(mounted) {
            setState(() {
              editImageTextVis ^= true;
              imageTextVis = false;
            });
            }
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

  Widget editImageText() {
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
                Row( 
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [ 
                    IconButton(
                      onPressed: () {
                        if(mounted) {
                          setState(() {
                          eventText = curText;
                          editImageTextVis = false;
                          imageTextVis = true;
                          updateText();
                        });
                      }
                      }, 
                      icon: const Icon(
                        Icons.check,
                        color: Colors.white,
                      ),
                    ),

                    IconButton(
                      onPressed: () {
                        if(mounted) {
                          setState(() {
                          editImageTextVis = false;
                          imageTextVis = true;
                        });
                      }
                      }, 
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                    ),
                  ]
                ),
                Form(
                  child: Container(
                    padding: const EdgeInsets.all(40),
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget tagsview(){
    return Visibility(
      visible: tagFieldVis,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Tags(
          key: _globalKey,
          itemCount: tagsItemList.length,
          columns: 6,
          textField: TagsTextField(
              textStyle: TextStyle(fontSize: 14),
              onSubmitted: (string){
                if(mounted) {
                setState(() {
                  addTag(string);
                });
                }
              }
          ),
          itemBuilder: (index){
            final Item currentitem = tagsItemList[index];
            return ItemTags(
              index: index,
              title: currentitem.title,
              customData: currentitem.customData,
              combine: ItemTagsCombine.withTextBefore,
              onPressed: (i)=>print(i),
              onLongPressed: (i)=>print(i),
              removeButton: ItemTagsRemoveButton(
                  onRemoved: (){
                    if(mounted) {
                    setState(() {
                      removeTag(currentitem.title);
                      tagsItemList.removeAt(index);
                    });
                    }
                    return true;
                  }
              ),
            );
          },
        ),
      ),
    );
  }

  Future addTag(String tag) async {

    var T = Tag.allFields(eventId: id.toString(), tagName: tag);
    await DB.instance.insertTag(T);
    tagsItemList.add(Item(title: tag));

  }

  Future readTag() async{

    List<Tag> t = await DB.instance.retrieveTag();

    int len = t.length;
    if(mounted) {
    setState(() {

      for(int i = 0; i < len; i++) {
        tagsItemList.add(Item(title: t[i].tagName));
      }

    });
    }

  }

  Future removeTag(String tag) async{
    Tag t = Tag.allFields(eventId: id.toString(),tagName: tag);
    DB.instance.deleteTag(t);
  }


  Future deleteEvent() async{

    for(var i in tagsItemList){
      removeTag(i.title);
    }

    DB.instance.deleteText(id); //delete text

    var len = pictures.length;
    for(int i = 0; i < len; i++){// delete images
      deleteImage(i);
    }

  }

  bool checkEmpty() {
    var isEmpty = pictures.isEmpty;

    super.widget.isEmpty = isEmpty;

    if(isEmpty) {
      for (var i in tagsItemList) {
        removeTag(i.title);
      }
    }

    if(eventText != '' && pictures.isEmpty && !editImageTextVis) {
      imageTextVis = true;
    }

    return isEmpty;
  }
}