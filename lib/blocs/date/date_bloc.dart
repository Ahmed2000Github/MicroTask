import 'package:bloc/bloc.dart';

class DateBloc extends Bloc<DateEvent, DateState> {
  DateBloc()
      : super(DateState(
            date: DateTime(DateTime.now().year, DateTime.now().month,
                DateTime.now().day)));
  @override
  Stream<DateState> mapEventToState(DateEvent event) async* {
    yield DateState(date: event.date);
  }
}

class DateEvent {
  DateTime date;
  DateEvent({required this.date});
}

class DateState {
  DateTime date;
  DateState({required this.date});
}
