import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import 'package:microtask/models/category_model.dart';
import 'package:microtask/models/task_model.dart';

class SyncServices {
  User? user = FirebaseAuth.instance.currentUser!;
  late CollectionReference<Map<String, dynamic>> userRef;
  late CollectionReference<Map<String, dynamic>> taskRef;
  late CollectionReference<Map<String, dynamic>> categoryRef;

  late final Box categoryBox;
  late final Box taskBox;
  SyncServices() {
    userRef = FirebaseFirestore.instance.collection("users");
    taskRef = FirebaseFirestore.instance.collection("tasks");
    categoryRef = FirebaseFirestore.instance.collection("Categories");
    categoryBox = Hive.box('categoriesBox');
    taskBox = Hive.box('tasksBox');
  }

  synchronizeFromDevise() async {
    if (user != null) {
      print('mmmmmmmmmmmmmmmmmmmmmmmmmm');
      QuerySnapshot querySnap =
          await userRef.where('email', isEqualTo: user?.email).get();
      QueryDocumentSnapshot doc = querySnap.docs[0];
      DocumentReference docRef = doc.reference;
      (await categoryRef.where("userId", isEqualTo: docRef.id).get())
          .docs
          .forEach((category) async {
        (await taskRef
                .where("categoryId", isEqualTo: category.data()['id'])
                .get())
            .docs
            .forEach((task) async {
          await task.reference.delete();
        });
        await category.reference.delete();
      });
      for (var i = 0; i < categoryBox.length; i++) {
        var category = categoryBox.getAt(i) as Category;
        category.userId = docRef.id;
        final doc = await categoryRef.add(category.toJson());
        for (var i = 0; i < taskBox.length; i++) {
          var task = (taskBox.getAt(i) as Task);
          if (category.id == task.categoryId) {
            await taskRef.add(task.toJson());
          }
        }
      }
    }
  }

  synchronizeFromCloud() async {
    if (user != null) {
      categoryBox.clear();
      taskBox.clear();
      QuerySnapshot querySnap =
          await userRef.where('email', isEqualTo: user?.email).get();
      QueryDocumentSnapshot doc = querySnap.docs[0];
      DocumentReference docRef = doc.reference;

      (await categoryRef.get()).docs.forEach((_category) async {
        final category = Category.fromJson(_category.data());
        categoryBox.put(category.id, category);
        (await taskRef.get()).docs.forEach((_task) {
          final task = Task.fromJson(_task.data());
          taskBox.put(task.id, task);
        });
      });
      var data = await categoryRef.get();
      print('vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv  ' +
          categoryBox.length.toString());
    }
  }

  Future<void> clear() async {
    categoryBox.clear();
    taskBox.clear();
    Hive.box('showCaseBox').clear();
    Hive.box('showCaseBox').put('isloged', false);
    Hive.box('profileBox').clear();
    await FirebaseAuth.instance.signOut();
  }
}
