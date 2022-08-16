import 'package:flutter/cupertino.dart';
import 'package:microtask/models/task_model.dart';

class DragData {
  Key originColumnKey;
  Task data;

  DragData({required this.originColumnKey, required this.data});
}
