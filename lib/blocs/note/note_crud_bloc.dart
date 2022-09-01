import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:microtask/blocs/note/note_event.dart';
import 'package:microtask/blocs/note/note_state.dart';
import 'package:microtask/enums/event_state.dart';
import 'package:microtask/enums/state_enum.dart';
import 'package:microtask/services/note_services.dart';

class CrudNoteBloc extends Bloc<NoteEvent, NoteState> {
  CrudNoteBloc() : super(NoteState(requestState: StateStatus.NONE));

  Noteservices get noteservices => GetIt.I<Noteservices>();
  @override
  Stream<NoteState> mapEventToState(NoteEvent event) async* {
    switch (event.eventState) {
      case CrudEventStatus.ADD:
        try {
          yield NoteState(requestState: StateStatus.LOADING);
          noteservices.addNote(event.note);
          yield NoteState(requestState: StateStatus.LOADED);
        } catch (e) {
          yield NoteState(
              requestState: StateStatus.ERROR, errorMessage: e.toString());
        }

        break;
      case CrudEventStatus.EDIT:
        try {
          yield NoteState(requestState: StateStatus.LOADING);
          noteservices.editNote(event.note);
          yield NoteState(requestState: StateStatus.LOADED);
        } catch (e) {
          yield NoteState(
              requestState: StateStatus.ERROR, errorMessage: e.toString());
        }
        break;
      case CrudEventStatus.DELETE:
        try {
          yield NoteState(requestState: StateStatus.LOADING);
          noteservices.deleteNote(event.note!);
          yield NoteState(requestState: StateStatus.LOADED);
        } catch (e) {
          yield NoteState(
              requestState: StateStatus.ERROR, errorMessage: e.toString());
        }
        break;
      case CrudEventStatus.RESET:
        yield NoteState(requestState: StateStatus.NONE);
        break;
      default:
    }
  }
}
