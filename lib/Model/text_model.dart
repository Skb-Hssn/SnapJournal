import '../Database/database.dart';

class EventTextFields {
  static var eventId = 'eventId';
  static var text = 'text';
}

class EventText {
  int? eventId;
  String? text;

  EventText.allFields({
    this.eventId,
    this.text,
  });

  Map<String, Object?> toJson() => {
    EventTextFields.eventId: eventId,
    EventTextFields.text: text
  };

  static String fromJson(Map<String, Object?> json) => json[EventTextFields.text] as String;

  Future saveToDatabase() async {
    DB.instance.insertText(this);
  }
}