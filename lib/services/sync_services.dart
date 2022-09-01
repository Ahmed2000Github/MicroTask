import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import 'package:microtask/blocs/synchronization/synch_bloc.dart';
import 'package:microtask/models/category_model.dart';
import 'package:microtask/models/note_model.dart';
import 'package:microtask/models/task_model.dart';

class SyncServices {
  User? user = FirebaseAuth.instance.currentUser!;
  late CollectionReference<Map<String, dynamic>> userRef;
  late CollectionReference<Map<String, dynamic>> taskRef;
  late CollectionReference<Map<String, dynamic>> categoryRef;
  late CollectionReference<Map<String, dynamic>> noteRef;

  late final Box categoryBox;
  late final Box taskBox;
  late final Box noteBox;

  SyncServices() {
    userRef = FirebaseFirestore.instance.collection("users");
    taskRef = FirebaseFirestore.instance.collection("tasks");
    categoryRef = FirebaseFirestore.instance.collection("Categories");
    noteRef = FirebaseFirestore.instance.collection("notes");
    categoryBox = Hive.box('categoriesBox');
    taskBox = Hive.box('tasksBox');
    noteBox = Hive.box('noteBox');
  }

  synchronizeFromDevise() async {
    if (user != null) {
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
      (await noteRef.where("userId", isEqualTo: docRef.id).get())
          .docs
          .forEach((task) async {
        await task.reference.delete();
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
      for (var i = 0; i < noteBox.length; i++) {
        var note = noteBox.getAt(i) as Note;
        note.userId = docRef.id;
        await noteRef.add(note.toJson());
      }
    }
  }

  synchronizeFromCloud() async {
    if (user != null) {
      categoryBox.clear();
      taskBox.clear();
      noteBox.clear();
      QuerySnapshot querySnap =
          await userRef.where('email', isEqualTo: user?.email).get();
      QueryDocumentSnapshot doc = querySnap.docs[0];
      DocumentReference docRef = doc.reference;

      (await categoryRef.where("userId", isEqualTo: docRef.id).get())
          .docs
          .forEach((_category) async {
        final category = Category.fromJson(_category.data());
        categoryBox.put(category.id, category);
        (await taskRef.where("categoryId", isEqualTo: category.id).get())
            .docs
            .forEach((_task) {
          final task = Task.fromJson(_task.data());
          taskBox.put(task.id, task);
        });
      });
      (await noteRef.where("userId", isEqualTo: docRef.id).get())
          .docs
          .forEach((_note) async {
        final note = Note.fromJson(_note.data());
        noteBox.put(note.id, note);
      });
      // var data = await categoryRef.get();
    }
  }

  Future<void> clear() async {
    categoryBox.clear();
    taskBox.clear();
    noteBox.clear();
    await Hive.box('showCaseBox').clear();
    await Hive.box('showCaseBox').put('isloged', false);
    Hive.box('profileBox').clear();
    SyncBloc().add(SyncEvent.NONE);

    // Hive.box('configurationsBox').clear();
    await FirebaseAuth.instance.signOut();
  }
}
