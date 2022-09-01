import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:microtask/models/note_model.dart';
import 'package:microtask/services/note_services.dart';

class OneNoteCubit extends Cubit<Map<String, dynamic>> {
  OneNoteCubit() : super({});
  Noteservices get noteservices => GetIt.I<Noteservices>();

  changeState(String noteId) {
    final result = noteservices.getNoteById(noteId);
    emit(result);
  }
}
