import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:snapjournal/Model/day_model.dart';

import '../../Event/event_view.dart';

part 'day_event.dart';
part 'day_state.dart';

class DayBloc extends Bloc<DayEvent, DayState> {
  List<EventView> events;

  DayBloc({required this.events}) : super(DayInitial(initial: events, initialPage: 0)) {
    on<DeletingEvent>((event, emit) {
     List<EventView> L = state.eventsList;

     bool haveEmptyInMiddle = false;

     for(int i = 0; i < state.eventsList.length - 1; i++) {
       if(state.eventsList.isEmpty) {
         haveEmptyInMiddle = true;
       }
     }

     if(haveEmptyInMiddle) {
       L.clear();
       for(var e in state.eventsList) {
         if(!e.isEmpty) {
           L.add(e);
         }
       }
     }

      emit(DayDelete(deleted: L, initialPage: event.index));
    });
  }
}
