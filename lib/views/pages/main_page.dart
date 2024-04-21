import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:animated_reorderable_list/animated_reorderable_list.dart';
import 'package:orderable_todo/data_store/data_store.dart';
import 'package:orderable_todo/models/todo_model.dart';
import 'package:orderable_todo/views/pages/add_todo.dart';
import 'package:orderable_todo/views/widgets/todo_tile.dart';
import 'package:xid/xid.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  List<TodoModel> items = DataStore().items;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => const AddToDo()));
          },
          child: const Icon(Icons.add),
        ),
        appBar: AppBar(
          backgroundColor: Colors.deepPurple.shade300,
          title: const Text(
            "My To DO",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 18.0, 8.0, 4.0),
          child: AnimatedReorderableListView(
            key: Key(Xid().toString()),
            itemBuilder: (BuildContext context, int index) {
              final TodoModel item = items[index];
              return AnimatedBuilder(
                key: Key(index.toString()),
                animation: AnimationController(
                  vsync: this,
                  duration: const Duration(milliseconds: 300),
                ),
                builder: (BuildContext context, Widget? child) {
                  final double animValue = Curves.easeInOut.transform(1.0);
                  final double scale = lerpDouble(1, 1.02, animValue)!;
                  return Transform.scale(
                    scale: scale,
                    child: child,
                  );
                },
                child: ToDoTile(
                  todo: item,
                  key: ValueKey<int>(item.index),
                  // index: item.index.toString(),
                ),
              );
            },
            items: items,
            enterTransition: [FlipInX(), ScaleIn()],
            exitTransition: [SlideInLeft()],
            insertDuration: const Duration(milliseconds: 300),
            removeDuration: const Duration(milliseconds: 300),
            onReorder: (int oldIndex, int newIndex) {
              setState(() {
                final TodoModel item = items.removeAt(oldIndex);
                items.insert(newIndex, item);
              });
            },
          ),
        ),
      ),
    );
  }
}
