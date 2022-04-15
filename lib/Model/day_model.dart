class DayFields {
  static var dayid = 'dayid';
  static var eventid = 'eventid';
}


class Day {
  String ? dayid;
  int ? eventid;

  Day.allFields({this.dayid, this.eventid});

  Map<String, Object?> toJson() => {
    //UserFields.name: name,
    DayFields.dayid: dayid,
    DayFields.eventid: eventid,
  };

  static int fromJson(Map<String, Object?> json) => (
    json[DayFields.eventid] as int
  );

  static String getDateFormat(DateTime d) {
    String ret = '';
    ret += d.day.toString().padLeft(2, '0');
    ret += d.month.toString().padLeft(2, '0');
    ret += d.year.toString();
    return ret;
  }
}