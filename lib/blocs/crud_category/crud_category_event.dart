import 'package:microtask/enums/event_state.dart';
import 'package:microtask/models/category_model.dart';

class CrudCategoryEvent {
  CrudEventStatus requestEvent;
  Category? category;
  String? categoryId;

  CrudCategoryEvent(
      {required this.requestEvent, this.category, this.categoryId});
}
