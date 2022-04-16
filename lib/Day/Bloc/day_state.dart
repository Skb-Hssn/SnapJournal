part of 'day_bloc.dart';


abstract class DayState {
  List<EventView> eventsList;
  DayState({required this.eventsList});
}


class DayInitial extends DayState {
  DayInitial({required List<EventView> initial}):super(eventsList: initial);
}

class DayDelete extends DayState{
  DayDelete({required List<EventView> deleted}):super(eventsList: deleted);
}
