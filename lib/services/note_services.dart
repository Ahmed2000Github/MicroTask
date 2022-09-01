import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:microtask/models/note_model.dart';
import 'package:microtask/models/task_model.dart';
import 'package:uuid/uuid.dart';

class Noteservices {
  Box? noteBox;
  Box? taskBox;
  Noteservices() {
    noteBox = Hive.box('noteBox');
    taskBox = Hive.box('tasksBox');
  }

  List<Note> getNotes() {
    List<Note> list = [];

    noteBox?.values.forEach((element) {
      list.add(element as Note);
    });
    return list;
  }

  void addNote(Note? note) {
    noteBox?.put(note?.id, note);
  }

  void deleteNote(Note note) {
    if (note.taskId != null) {
      var task = taskBox?.get(note.taskId) as Task;
      task.noteId = null;
      taskBox?.put(task.id, task);
    }
    noteBox?.delete(note.id);
  }

  void editNote(Note? note) {
    noteBox?.put(note?.id, note);
  }

  List<Map<String, dynamic>> getNotesByDate(DateTime date) {
    List<Task> _firstResult = [];
    taskBox?.values
        .where((element) =>
            DateFormat("yyyy-MM-dd").format((element as Task).startDateTime!) ==
                DateFormat("yyyy-MM-dd").format(date) &&
            (element as Task).noteId != null)
        .forEach((element) {
      _firstResult.add(element as Task);
    });
    Note note;
    List<Map<String, dynamic>> result = [];
    if (!_firstResult.isEmpty) {
      for (var task in _firstResult) {
        var data = noteBox?.values.where((element) {
          return (element as Note).id == task.noteId;
        });
        if (data != null && data.isNotEmpty) {
          note = data.first as Note;
          print("hhhhhhhhhhh  ${note.description}");
          print("note   sss  ${note.id}");
          result.add({
            'task': task,
            'note': note,
          });
        }
      }
    }

    return result;
  }

  Map<String, dynamic> getNoteById(String noteId) {
    var note = noteBox?.get(noteId) as Note;
    var task = null;
    if (note.taskId != null) {
      task = taskBox?.get(note.taskId);
    }
    return {
      'task': task,
      'note': note,
    };
  }
}
