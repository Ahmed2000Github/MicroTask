import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:microtask/models/note_model.dart';
import 'package:microtask/services/note_services.dart';

class NoteCubit extends Cubit<List<Note>> {
  NoteCubit() : super([]);
  Noteservices get noteservices => GetIt.I<Noteservices>();

  changeState() {
    final result = noteservices.getNotes();
    emit(result);
  }
}
