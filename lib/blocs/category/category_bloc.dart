import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:microtask/blocs/category/category_event.dart';
import 'package:microtask/blocs/category/category_state.dart';
import 'package:microtask/enums/event_state.dart';
import 'package:microtask/enums/state_enum.dart';
import 'package:microtask/services/category_services.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryBloc() : super(CategoryState(requestState: StateStatus.NONE));
  CategoryServices get categoryServices => GetIt.I<CategoryServices>();
  @override
  Stream<CategoryState> mapEventToState(CategoryEvent event) async* {
    switch (event.requestEvent) {
      case CrudEventStatus.FETCH:
        try {
          yield CategoryState(requestState: StateStatus.LOADING);

          final result = categoryServices.getCategories();
          yield CategoryState(
              requestState: StateStatus.LOADED, categories: result);
        } catch (e) {
          print(' $e');
          yield CategoryState(
              requestState: StateStatus.ERROR, errormessage: '$e');
        }
        break;
      case CrudEventStatus.RESET:
        yield CategoryState(requestState: StateStatus.NONE);
        break;
      default:
    }
  }
}
