// ignore_for_file: unrelated_type_equality_checks, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:orderable_todo/models/status.dart';
import 'package:orderable_todo/models/todo_model.dart';

class TodoView extends StatelessWidget {
  final TodoModel todo;
  const TodoView({super.key, required this.todo});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.deepPurple[300],
        title: Text(
          todo.title.toUpperCase(),
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.delete,
                color: Colors.white,
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          height: 400,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.deepPurple[400]!,
              )),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        "Due Date: ${todo.dueDate.year}-${todo.dueDate.month}-${todo.dueDate.day}"),
                    Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.all(4),
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: Center(
                          // ignore: unrelated_type_equality_checks
                          child: Text((todo.status == status.completed
                                  ? "Complete"
                                  : todo.status == status.inProgress
                                      ? "In Progress"
                                      : "uncompleted")
                              .toUpperCase()),
                        )),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      todo.title.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.edit,
                          color: Colors.deepPurple.shade300,
                        ))
                  ],
                ),
              ),
              if (todo.detail != null) Text(todo.detail!),
            ],
          ),
        ),
      ),
    ));
  }
}
