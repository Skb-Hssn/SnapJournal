
class TagFields {
  static var  tagName= 'TagName';
  static var eventId = 'EventID';
}

class Tag{
  String ? tagName;
  String ? eventId;


  Tag.allFields({
    this.eventId,
    this.tagName
});


  Map<String, Object?> toJson() => {
    TagFields.tagName: tagName,
    TagFields.eventId: eventId,
  };

  static Tag fromJson(Map<String, Object?> json) => Tag.allFields(
    tagName: json[TagFields.tagName] as String,
    eventId: json[TagFields.eventId] as String,
  );
}
