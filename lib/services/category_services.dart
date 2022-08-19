import 'package:hive_flutter/hive_flutter.dart';
import 'package:microtask/enums/task_enum.dart';
import 'package:microtask/models/category_model.dart';
import 'package:microtask/models/task_model.dart';
import 'package:uuid/uuid.dart';

class CategoryServices {
  late final Box categoryBox;
  late final Box taskBox;
  CategoryServices() {
    categoryBox = Hive.box('categoriesBox');
    taskBox = Hive.box('tasksBox');
  }

  Category? createCategoryService(Category category) {
    category.id = Uuid().v1();
    categoryBox.put(category.id, category);
    return category;
  }

  Category? updateCategoryService(Category category) {
    categoryBox.put(category.id as String, category);
    return category;
  }

  void deleteCategoryService(String id) {
    Task? task;
    for (var i = 0; i < taskBox.length; i++) {
      task = (taskBox.getAt(i) as Task);
      if (task.categoryId == id) taskBox.delete(task.id);
    }
    categoryBox.delete(id);
  }

  List<Category> getCategories() {
    List<Category> categories = [];
    int taskCounter = 0;
    int taskDoneCounter = 0;

    for (var i = 0; i < categoryBox.length; i++) {
      Category category = categoryBox.getAt(i);
      Task? task;
      for (var i = 0; i < taskBox.length; i++) {
        task = (taskBox.getAt(i) as Task);
        if (task.categoryId == category.id) {
          taskCounter++;
          if (task.status == TaskStatus.DONE) taskDoneCounter++;
        }
      }
      category.numberTask = taskCounter;
      category.numberTaskDone = taskDoneCounter;
      categories.add(category);
      taskCounter = 0;
      taskDoneCounter = 0;
    }
    return categories;
  }

  Category getCategoryByIdService(String? categoryId) {
    return categoryBox.get(categoryId);
  }
}
