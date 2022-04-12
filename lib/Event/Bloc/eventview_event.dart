abstract class EventViewEvent {
}

class EventViewEventAdd extends EventViewEvent {
  int? index;
  EventViewEventAdd({required this.index});
}

class EventViewEventDelete extends EventViewEvent {
  int? index;
  EventViewEventDelete({required this.index});
}

class EventViewEventUpdate extends EventViewEvent {
  int? index;
  EventViewEventUpdate({required this.index});
}
