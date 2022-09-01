import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:microtask/models/note_model.dart';
import 'package:microtask/services/note_services.dart';

class NoteDateCubit extends Cubit<List<Map<String, dynamic>>> {
  NoteDateCubit() : super([]);
  Noteservices get noteservices => GetIt.I<Noteservices>();

  changeState(DateTime date) {
    final result = noteservices.getNotesByDate(date);
    emit(result);
  }
}
