import 'package:microtask/enums/event_state.dart';
import 'package:microtask/models/note_model.dart';

class NoteEvent {
  CrudEventStatus eventState;
  Note? note;
  String? noteId;

  NoteEvent({required this.eventState, this.note, this.noteId});
}
