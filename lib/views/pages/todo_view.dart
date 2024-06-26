// ignore_for_file: unrelated_type_equality_checks, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:orderable_todo/main.dart';
import 'package:orderable_todo/models/status.dart';
import 'package:orderable_todo/models/todo_model.dart';
import 'package:orderable_todo/views/pages/add_todo.dart';

class TodoView extends StatelessWidget {
  final Box<TodoModel> box;

  final TodoModel todo;
  const TodoView({super.key, required this.box, required this.todo});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: ValueListenableBuilder(
            valueListenable: Hive.box('settings').listenable(),
            builder: (context, setbox, child) {
              final isDark = setbox.get('isDark', defaultValue: false);
              return Scaffold(
                appBar: AppBar(
                  iconTheme: const IconThemeData(color: Colors.white),
                  backgroundColor:
                      isDark ? Colors.deepPurple : Colors.deepPurple.shade300,
                  title: Text(
                    todo.title.toUpperCase(),
                    style: const TextStyle(color: Colors.white),
                  ),
                  actions: [
                    IconButton(
                        onPressed: () async {
                          await BaseWidget.of(context)
                              .dataStore
                              .deleteTodo(todo: todo);
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Todo Deleted Successfully")));
                        },
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
                                  "Due Date: ${DateFormat('yyyy-MM-dd').format(todo.dueDate)}"),
                              Container(
                                  decoration: BoxDecoration(
                                      color: isDark
                                          ? Colors.deepPurple
                                          : Colors.grey[400],
                                      borderRadius: BorderRadius.circular(8)),
                                  padding: const EdgeInsets.all(4),
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  child: Center(
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
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pushReplacement(MaterialPageRoute(
                                            builder: (context) => AddToDo(
                                                  box: box,
                                                  todo: todo,
                                                )));
                                  },
                                  icon: Icon(
                                    Icons.edit,
                                    color: Colors.deepPurple.shade300,
                                  ))
                            ],
                          ),
                        ),
                        Text(todo.detail),
                      ],
                    ),
                  ),
                ),
              );
            }));
  }
}
