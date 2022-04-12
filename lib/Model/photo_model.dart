import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:image_picker/image_picker.dart';

class PhotoFields {
  static var id = 'rowid';
  static var image = 'image';
}

class Photo {
  int ? id;
  XFile ? xFileimage;
  Image ? image;

  Photo.allFields({
    this.id,
    this.image,
    this.xFileimage,
  });

  
  Map<String, Object?> toJson() => {
    PhotoFields.image: imgToString()
  };

  static Photo fromJson(Map<String, Object?> json) => Photo.allFields(
    id: json[PhotoFields.id] as int,
    image: stringToImage(json[PhotoFields.image] as String)
  );


  String imgToString(){
    final bytes = File(xFileimage!.path).readAsBytesSync();
    String base64Image =  base64Encode(bytes);
    print(base64Image);
    return base64Image;
  }

  static Image stringToImage(String stringImage) {
    var image = Image.memory(base64Decode(stringImage));
    return image;
  }



}