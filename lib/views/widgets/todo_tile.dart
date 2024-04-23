import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:orderable_todo/models/status.dart';
import 'package:orderable_todo/models/todo_model.dart';
import 'package:orderable_todo/views/pages/todo_view.dart';

class ToDoTile extends StatelessWidget {
  final Box<TodoModel> box;

  final TodoModel? todo;

  const ToDoTile({
    required this.box,
    super.key,
    required this.todo,
  });

  @override
  Widget build(BuildContext context) {
    // final isDark = box.get('isDark');

    return Material(
      child: ValueListenableBuilder(
          valueListenable: Hive.box('settings').listenable(),
          builder: (context, setbox, child) {
            final isDark = setbox.get('isDark', defaultValue: false);
            return InkWell(
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
                  tileColor:
                      isDark ? Colors.deepPurple : Colors.deepPurple.shade100,
                  title: Text(todo!.title.toUpperCase()),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          "Due Date: ${DateFormat('yyyy-MM-dd').format(todo!.dueDate)}"),
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: Text(
                              "Status: ${todo!.status == status.completed.toString() ? "Complete" : todo!.status == status.inProgress.toString() ? "In Progress" : "Uncompleted"}")),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
