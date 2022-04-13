import '../Database/database.dart';

class EventImageRowFields {
  static var eventId = 'eventId';
  static var imageId = 'imageId';
}

class EventImageRow {
  int? eventId;
  int? imageId;

  EventImageRow.allFields({
    this.eventId,
    this.imageId,
  });

  Map<String, Object?> toJson() => {
    EventImageRowFields.eventId: eventId,
    EventImageRowFields.imageId:imageId 
  };

  static int fromJson(Map<String, Object?> json) => json[EventImageRowFields.imageId] as int;

  Future saveToDatabase() async {
    DB.instance.insertEventImageRow(this);
  }
}