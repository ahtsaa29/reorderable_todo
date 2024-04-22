import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:orderable_todo/models/todo_model.dart';

class HiveDataStore {
  static const boxName = "tasksBox";
  final Box<TodoModel> box = Hive.box<TodoModel>(boxName);

  Future<void> addTodo({required TodoModel todo}) async {
    await box.put(todo.index, todo);
  }

  Future<TodoModel?> getTodo({required String id}) async {
    return box.get(id);
  }

  Future<void> updateTodo({required TodoModel todo}) async {
    final storedTodo = box.get(todo.index);

    if (storedTodo != null) {
      storedTodo.title = todo.title;
      storedTodo.detail = todo.detail;
      storedTodo.dueDate = todo.dueDate;
      storedTodo.status = todo.status;
      await storedTodo.save();
    } else {
      log('Todo not found in the box.');
    }
  }

  Future<void> deleteTodo({required TodoModel todo}) async {
    final storedTodo = box.get(todo.index);
    if (storedTodo != null) {
      await storedTodo.delete();
    } else {
      log('Todo not found in the box.');
    }
  }

  ValueListenable<Box<TodoModel>> listenToTodo() {
    return box.listenable();
  }
}
