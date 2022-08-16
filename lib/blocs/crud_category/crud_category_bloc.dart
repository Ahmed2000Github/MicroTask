import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:microtask/blocs/crud_category/crud_category_event.dart';
import 'package:microtask/blocs/crud_category/crud_category_state.dart';
import 'package:microtask/enums/event_state.dart';
import 'package:microtask/enums/state_enum.dart';
import 'package:microtask/models/category_model.dart';
import 'package:microtask/services/category_services.dart';

class CrudCategoryBloc extends Bloc<CrudCategoryEvent, CrudCategoryState> {
  CrudCategoryBloc() : super(CrudCategoryState(requestState: StateStatus.NONE));
  CategoryServices get categoryServices => GetIt.I<CategoryServices>();
  @override
  Stream<CrudCategoryState> mapEventToState(CrudCategoryEvent event) async* {
    switch (event.requestEvent) {
      case CrudEventStatus.ADD:
        try {
          yield CrudCategoryState(requestState: StateStatus.LOADING);
          final result = categoryServices
              .createCategoryService(event.category as Category);
          yield CrudCategoryState(
              requestState: StateStatus.LOADED, category: result);
        } catch (e) {
          yield CrudCategoryState(
              requestState: StateStatus.ERROR, errormessage: '$e');
        }
        break;
      case CrudEventStatus.EDIT:
        try {
          yield CrudCategoryState(requestState: StateStatus.LOADING);
          final result = categoryServices
              .updateCategoryService(event.category as Category);
          yield CrudCategoryState(
              requestState: StateStatus.LOADED, category: result);
        } catch (e) {
          yield CrudCategoryState(
              requestState: StateStatus.ERROR, errormessage: '$e');
        }
        break;
      case CrudEventStatus.DELETE:
        try {
          yield CrudCategoryState(requestState: StateStatus.LOADING);
          categoryServices
              .deleteCategoryService((event.category as Category).id!);
          yield CrudCategoryState(requestState: StateStatus.NONE);
        } catch (e) {
          yield CrudCategoryState(
              requestState: StateStatus.ERROR, errormessage: '$e');
        }
        break;
      case CrudEventStatus.FETCH:
        try {
          yield CrudCategoryState(requestState: StateStatus.LOADING);
          Category category =
              categoryServices.getCategoryByIdService(event.categoryId);
          yield CrudCategoryState(
              requestState: StateStatus.LOADED, category: category);
        } catch (e) {
          yield CrudCategoryState(
              requestState: StateStatus.ERROR, errormessage: '$e');
        }
        break;
      case CrudEventStatus.RESET:
        yield CrudCategoryState(requestState: StateStatus.NONE);
        break;
      default:
    }
  }
}
