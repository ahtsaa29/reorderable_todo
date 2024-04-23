import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:orderable_todo/models/status.dart';
import 'package:orderable_todo/models/todo_model.dart';

class TodoProvider with ChangeNotifier {
  final List<TodoModel> _todos = [];

  UnmodifiableListView<TodoModel> get allTasks => UnmodifiableListView(_todos);

  void addToDo(
      int index, String taskTitle, String taskDetail, DateTime dueDate) {
    _todos.add(TodoModel.create(
      index: index,
      title: taskTitle,
      detail: taskDetail,
      status: status.inProgress.toString(), // Convert enum to string
      createdAt: DateTime.now(),
      dueDate: dueDate,
    ));
    notifyListeners();
  }

  void toggleTaskCompletion(TodoModel task) {
    final taskIndex = _todos.indexOf(task);
    switch (task.status) {
      case 'inProgress':
        _todos[taskIndex].status = status.completed.toString().split('.').last;
        break;
      case 'completed':
        _todos[taskIndex].status =
            status.uncompleted.toString().split('.').last;
        break;
      case 'uncompleted':
        _todos[taskIndex].status = status.inProgress.toString().split('.').last;
        break;
    }
    notifyListeners();
  }

  void deleteTask(TodoModel todo) {
    _todos.remove(todo);
    notifyListeners();
  }
}
