import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:orderable_todo/data_store/hive_store.dart';
import 'package:orderable_todo/models/todo_model.dart';

class DataStore {
  ValueNotifier<List<TodoModel>> itemsNotifier =
      ValueNotifier<List<TodoModel>>([]);
  List<TodoModel> get items => itemsNotifier.value;
  Future<void> getItems() async {
    Box<TodoModel> box = Hive.box<TodoModel>(HiveDataStore.boxName);
    List<TodoModel> newItems = box.values.toList();

    itemsNotifier.value = newItems;
  }

  void addItem(TodoModel item) {
    itemsNotifier.value = [...items, item];
    log(itemsNotifier.value.length.toString());
  }
}
