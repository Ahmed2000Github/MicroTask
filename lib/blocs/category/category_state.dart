import 'package:microtask/enums/state_enum.dart';
import 'package:microtask/models/category_model.dart';

class CategoryState {
  StateStatus requestState;
  List<Category>? categories;
  String? errormessage;
  CategoryState(
      {required this.requestState, this.categories, this.errormessage});
}
