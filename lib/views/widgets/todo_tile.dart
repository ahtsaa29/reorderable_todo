import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:orderable_todo/models/status.dart';
import 'package:orderable_todo/models/todo_model.dart';
import 'package:orderable_todo/views/pages/todo_view.dart';

// ignore: must_be_immutable
class ToDoTile extends StatelessWidget {
  Box<TodoModel> box;

  final TodoModel? todo;

  ToDoTile({
    required this.box,
    super.key,
    required this.todo,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        key: Key(key!.toString()),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => TodoView(
                    box: box,
                    todo: TodoModel(
                        key: key.toString(),
                        dueDate: todo!.dueDate,
                        detail: todo!.detail,
                        title: todo!.title,
                        status: todo!.status,
                        createdAt: todo!.createdAt,
                        index: todo!.index),
                  )));
        },
        child: Container(
          padding: const EdgeInsets.all(4.0),
          width: MediaQuery.of(context).size.width,
          child: ListTile(
            tileColor: Colors.deepPurple.shade100,
            title: Text(todo!.title.toUpperCase()),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    "Due Date: ${DateFormat('yyyy-MM-dd').format(todo!.dueDate)}"),
                SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: Text(
                        // ignore: unrelated_type_equality_checks
                        "Status: ${todo!.status == status.completed.toString() ? "Complete" : todo!.status == status.inProgress.toString() ? "In Progress" : "Uncompleted"}")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
