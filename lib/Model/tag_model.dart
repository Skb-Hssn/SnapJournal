
class TagFields {
  static var  tagName= 'TagName';
  static var eventId = 'EventID';
}

class Tag{
  String tagName;
  String ? eventId;



  Tag.search({required this.tagName});

  Tag.allFields({
    required this.eventId,
    required this.tagName
});


  Map<String, Object?> toJson() => {
    TagFields.tagName: tagName,
    TagFields.eventId: eventId,
  };

  static Tag fromJson(Map<String, Object?> json) => Tag.allFields(
    tagName: json[TagFields.tagName] as String,
    eventId: json[TagFields.eventId] as String,
  );

  List<Tag> getTag(){
    return [
      Tag.allFields(eventId: "eventid", tagName: "name"),
      Tag.allFields(eventId: "eventid2", tagName: "name"),
      Tag.allFields(eventId: "eventid2", tagName: "name"),

    ];
  }
}
