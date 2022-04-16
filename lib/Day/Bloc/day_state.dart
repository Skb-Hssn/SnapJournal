part of 'day_bloc.dart';


abstract class DayState {
  List<EventView> eventsList;
  int initialPage;
  DayState({required this.eventsList, required this.initialPage});
}


class DayInitial extends DayState {
  DayInitial({required List<EventView> initial, required int initialPage}):super(eventsList: initial, initialPage: initialPage);
}

class DayDelete extends DayState{
  DayDelete({required List<EventView> deleted, required int initialPage}):super(eventsList: deleted, initialPage: initialPage);
}
