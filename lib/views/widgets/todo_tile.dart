import 'package:flutter/material.dart';
import 'package:orderable_todo/models/status.dart';
import 'package:orderable_todo/models/todo_model.dart';
import 'package:orderable_todo/views/pages/todo_view.dart';

class ToDoTile extends StatelessWidget {
  final TodoModel? todo;

  const ToDoTile({
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
                    todo: TodoModel(
                        key: key!,
                        dueDate: todo!.dueDate,
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
                    "Due Date: ${todo!.dueDate.year}-${todo!.dueDate.month}-${todo!.dueDate.day}"),
                SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: Text(
                        // ignore: unrelated_type_equality_checks
                        "Status: ${todo!.status == status.completed ? "Complete" : todo!.status == status.inProgress ? "In Progress" : "uncompleted"}")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
