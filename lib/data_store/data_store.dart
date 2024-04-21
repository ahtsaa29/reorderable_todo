import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:orderable_todo/models/status.dart';
import 'package:orderable_todo/models/todo_model.dart';
import 'package:xid/xid.dart';

class DataStore {
  List<TodoModel> items = [
    // for (int i = 0; i < 10; i++)
    TodoModel(
      index: 1,
      title: "title 1",
      dueDate: DateTime.now(),
      createdAt: DateTime.now(),
      status: status.inProgress.toString(),
      detail: "absdfjdfkdfdfdfdf",
      key: Key(Xid().toString()),
    ),
    TodoModel(
      index: 2,
      title: "title 2",
      dueDate: DateTime.now(),
      createdAt: DateTime.now(),
      detail: "absdfjdfkdfdfdfdf",
      status: "uncompleted",
      key: Key(Xid().toString()),
    )
  ];

  addItem(TodoModel item) {
    items.add(item);
    log(items.length.toString());
  }
}
