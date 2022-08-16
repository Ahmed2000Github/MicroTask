import 'package:microtask/enums/state_enum.dart';
import 'package:microtask/models/category_model.dart';

class CrudCategoryState {
  StateStatus requestState;
  Category? category;
  String? errormessage;
  CrudCategoryState(
      {required this.requestState, this.category, this.errormessage});
}
