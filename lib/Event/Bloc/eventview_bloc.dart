import 'dart:io';

import 'package:snapjournal/Event/Bloc/eventview_event.dart';
import 'package:snapjournal/Event/Bloc/eventview_state.dart';
import 'package:bloc/bloc.dart';

class EventViewBloc extends Bloc<EventViewEvent, EventViewState> {
  late List<File> pictures = [];
  late List<String> texts = [];
  late List<String> pictureTimes = [];
  late int id = 0;

  EventViewBloc.all({required this.pictures, required this.texts, required this.pictureTimes, required this.id}): super(EventViewState()) {
    emit(EventViewState());
  }

  EventViewBloc() : super(EventViewState()) {
    emit(EventViewState());
  }
}