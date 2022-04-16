part of 'day_bloc.dart';


abstract class DayEvent {}

class AddingEvent extends DayEvent{
  String date;
  AddingEvent({required this.date});
}

class DeletingEvent extends DayEvent{
  int index;
  DeletingEvent({required this.index});
}
