import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:snapjournal/Model/day_model.dart';

import '../../Event/event_view.dart';

part 'day_event.dart';
part 'day_state.dart';

class DayBloc extends Bloc<DayEvent, DayState> {
  List<EventView> events;

  DayBloc({required this.events}) : super(DayInitial(initial: events)) {
    on<DeletingEvent>((event, emit) {
      print("Bloc --------------------------------debug");
      //print(state.eventsList[event.index]);
      state.eventsList.removeAt(event.index);
     // print(state.eventsList[event.index-1]);

      emit(DayDelete(deleted: state.eventsList));
    });
  }
}
