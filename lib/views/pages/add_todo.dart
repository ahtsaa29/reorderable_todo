// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:orderable_todo/data_store/data_store.dart';
import 'package:orderable_todo/models/status.dart';
import 'package:orderable_todo/models/todo_model.dart';
import 'package:xid/xid.dart';

// ignore: must_be_immutable
class AddToDo extends StatefulWidget {
  final TodoModel? todo;
  const AddToDo({
    super.key,
    this.todo,
  });

  @override
  State<AddToDo> createState() => _AddToDoState();
}

class _AddToDoState extends State<AddToDo> {
  TextEditingController? titleController = TextEditingController();

  TextEditingController? detailController = TextEditingController();
  DateTime? selectedDate;

  @override
  void initState() {
    // selectedDate = widget.todo ?? DateTime.now();
    if (widget.todo != null) {
      selectedDate = widget.todo!.dueDate;
    } else {
      selectedDate = DateTime.now();
    }
    super.initState();
  }

  String showDate(DateTime? date) {
    if (widget.todo?.createdAt == null) {
      if (date == null) {
        return DateFormat.yMMMEd().format(DateTime.now()).toString();
      } else {
        return DateFormat.yMMMEd().format(date).toString();
      }
    } else {
      return DateFormat.yMMMEd().format(widget.todo!.createdAt).toString();
    }
  }

  String showTime(DateTime? time) {
    if (widget.todo?.createdAt == null) {
      if (time == null) {
        return DateFormat('hh:mm a').format(DateTime.now()).toString();
      } else {
        return DateFormat('hh:mm a').format(time).toString();
      }
    } else {
      return DateFormat('hh:mm a').format(widget.todo!.createdAt).toString();
    }
  }

  /// Show Selected Time As DateTime Format
  DateTime showTimeAsDateTime(DateTime? time) {
    if (widget.todo?.createdAt == null) {
      if (time == null) {
        return DateTime.now();
      } else {
        return time;
      }
    } else {
      return widget.todo!.createdAt;
    }
  }

  // Show Selected Date As DateTime Format
  DateTime showDateAsDateTime(DateTime? date) {
    if (widget.todo?.createdAt == null) {
      if (date == null) {
        return DateTime.now();
      } else {
        return date;
      }
    } else {
      return widget.todo!.createdAt;
    }
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    String? title;
    String? subtitle;
    DateTime? date;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple.shade300,
        title: const Text(
          "Add To DO",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: ListTile(
                title: TextFormField(
                  controller: titleController,
                  maxLines: 3,
                  cursorHeight: 20,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: "Title",
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  onFieldSubmitted: (value) {
                    title = value;
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  onChanged: (value) {
                    title = value;
                  },
                ),
              ),
            ),

            const SizedBox(
              height: 10,
            ),

            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: ListTile(
                title: TextFormField(
                  controller: detailController,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    counter: Container(),
                    hintText: "Add Note",
                  ),
                  onFieldSubmitted: (value) {
                    subtitle = value;
                  },
                  onChanged: (value) {
                    subtitle = value;
                  },
                ),
              ),
            ),

            /// Time Picker
            GestureDetector(
              onTap: () async {
                selectedDate = await showDatePicker(
                  initialDate: selectedDate,
                  context: context,
                  firstDate: DateTime(2024),
                  lastDate: DateTime(2025),
                );
                setState(() {
                  date = selectedDate;
                });
              },
              child: Container(
                margin: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                width: double.infinity,
                height: 55,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300, width: 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        "Due Date",
                        style: textTheme.bodyMedium,
                      ),
                    ),
                    Expanded(child: Container()),
                    Container(
                      margin: const EdgeInsets.only(right: 10),
                      width: 150,
                      height: 35,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey.shade100),
                      child: Center(
                        child: Text(
                          showDate(selectedDate),
                          style: textTheme.titleSmall,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  DataStore().addItem(
                    TodoModel(
                      index: DataStore().items.length + 1,
                      title: titleController!.text,
                      detail: detailController!.text,
                      dueDate: selectedDate!,
                      createdAt: DateTime.now(),
                      status: status.inProgress.toString(),
                      key: Key(Xid().toString()),
                    ),
                  );
                  // log(DataStore().items.length.toString());
                },
                child: const Text("Save"))
          ],
        ),
      ),
    );
  }
}
