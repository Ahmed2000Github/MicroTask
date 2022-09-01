import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:microtask/models/category_model.dart';
import 'package:microtask/services/category_services.dart';

class CategoryCubit extends Cubit<List<Category>> {
  CategoryCubit() : super([]);
  CategoryServices get categoryServices => GetIt.I<CategoryServices>();

  changeState() {
    final result = categoryServices.getCategories();
    emit(result);
  }
}
