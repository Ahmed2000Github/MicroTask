import 'package:microtask/enums/state_enum.dart';

class NoteState {
  StateStatus requestState;
  String? errorMessage;

  NoteState({required this.requestState, this.errorMessage});
}
