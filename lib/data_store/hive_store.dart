import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:orderable_todo/models/todo_model.dart';

class HiveDataStore {
  static const boxName = "tasksBox";
  final Box<TodoModel> box = Hive.box<TodoModel>(boxName);

  Future<void> addTask({required TodoModel todo}) async {
    await box.put(todo.index, todo);
  }

  Future<TodoModel?> getTask({required String id}) async {
    return box.get(id);
  }

  Future<void> updateTask({required TodoModel todo}) async {
    await todo.save();
  }

  Future<void> dalateTask({required TodoModel todo}) async {
    await todo.delete();
  }

  ValueListenable<Box<TodoModel>> listenToTask() {
    return box.listenable();
  }
}
