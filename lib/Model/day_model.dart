class DayFields {
  static var dayid = 'dayid';
  static var eventid = 'eventid';
}


class Day {
  String ? dayid;
  int ? eventid;

  static const List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ]; 


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

  static String getDateFormatWithMonthName(String d) {
    String ret = '';
    ret += d.substring(0, 2) + ' ';
    int month = int.parse(d.substring(2, 4));
    ret += months[month];
    ret += ', ';
    ret += d.substring(4);
    return ret;
  }
}