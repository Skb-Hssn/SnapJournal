import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../Database/database.dart';

class PhotoFields {
  static var id = 'rowid';
  static var image = 'imagePath';
}

class Photo {
  int? id;
  XFile? xFileimage;
  FileImage? image;
  String? path;

  Photo.allFields({
    this.id,
    this.image,
    this.xFileimage,
  });

  Map<String, Object?> toJson() => {
    PhotoFields.image: path 
  };

  static Photo fromJson(Map<String, Object?> json) => Photo.allFields(
    id: json[PhotoFields.id] as int,
    image: FileImage(File(json[PhotoFields.image] as String)),
  );


  Future saveToDatabase() async {
    path = (await getApplicationDocumentsDirectory()).path;
    var time = DateTime.now();
    path = path! + time.toString();

    await File(xFileimage!.path).copy(path!);

    DB.instance.insertImage(toJson());
  }
}