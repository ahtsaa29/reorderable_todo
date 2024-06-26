import 'package:flutter/material.dart';
import 'package:animated_reorderable_list/animated_reorderable_list.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:orderable_todo/data_store/data_store.dart';
import 'package:orderable_todo/main.dart';
import 'package:orderable_todo/models/todo_model.dart';
import 'package:orderable_todo/provider/theme_provider.dart';
import 'package:orderable_todo/views/pages/add_todo.dart';
import 'package:orderable_todo/views/widgets/todo_tile.dart';
import 'package:provider/provider.dart';
import 'package:xid/xid.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  List<TodoModel> items = [];
  bool isDark = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    await DataStore().getItems();
    setState(() {
      items = DataStore().items;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ThemeProvider>(context);

    @override
    List<TodoModel> sort(List<TodoModel> tosort) {
      tosort.sort((a, b) => a.dueDate.compareTo(b.dueDate));

      tosort.sort((b, a) => a.status.compareTo(b.status));
      List<TodoModel> sorted = tosort;
      return sorted;
    }

    return Builder(builder: (context) {
      return ValueListenableBuilder(
        valueListenable: BaseWidget.of(context).dataStore.listenToTodo(),
        builder: (ctx, Box<TodoModel> box, Widget? child) {
          var todos = box.values.toList();
          sort(todos);
          // todos.sort((a, b) => a.dueDate.compareTo(b.dueDate));

          return SafeArea(
            child: ValueListenableBuilder(
                valueListenable: Hive.box('settings').listenable(),
                builder: (context, setbox, child) {
                  final isDark = setbox.get('isDark', defaultValue: false);

                  return Scaffold(
                    floatingActionButton: FloatingActionButton(
                      backgroundColor: isDark
                          ? Colors.deepPurple
                          : Colors.deepPurple.shade300,
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => AddToDo(box: box),
                        ));
                      },
                      child: const Icon(Icons.add),
                    ),
                    appBar: AppBar(
                      backgroundColor: isDark
                          ? Colors.deepPurple
                          : Colors.deepPurple.shade300,
                      title: const Text(
                        "My To DO",
                        style: TextStyle(color: Colors.white),
                      ),
                      actions: [
                        IconButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return ValueListenableBuilder(
                                        valueListenable:
                                            Hive.box('settings').listenable(),
                                        builder: (context, box, child) {
                                          final isDark = box.get('isDark',
                                              defaultValue: false);
                                          return AlertDialog(
                                            title: const Text("Theme"),
                                            content: SizedBox(
                                              height: 100,
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Radio(
                                                          value: true,
                                                          groupValue: isDark,
                                                          onChanged: (val) {
                                                            setState(() {
                                                              box.put('isDark',
                                                                  val);
                                                              provider
                                                                  .toggleTheme();
                                                            });
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          }),
                                                      Text(
                                                        "Dark Theme",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: isDark
                                                              ? Colors.white
                                                              : Colors.black,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Radio(
                                                          value: false,
                                                          groupValue: isDark,
                                                          onChanged: (val) {
                                                            setState(() {
                                                              box.put('isDark',
                                                                  val);
                                                              provider
                                                                  .toggleTheme();
                                                            });
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          }),
                                                      Text(
                                                        "Light Theme",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: isDark
                                                              ? Colors.white
                                                              : Colors.black,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        });
                                  });
                            },
                            icon: const Icon(
                              Icons.settings,
                              color: Colors.white,
                            ))
                      ],
                    ),
                    body: Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 18.0, 8.0, 4.0),
                      child: todos.isEmpty
                          ? Center(
                              child: LottieBuilder.asset('assets/empty.json'),
                            )
                          : AnimatedReorderableListView(
                              key: Key(Xid().toString()),
                              itemBuilder: (BuildContext context, int index) {
                                final TodoModel item = todos[index];
                                return ToDoTile(
                                  box: box,
                                  todo: item,
                                  key: ValueKey<int>(item.index),
                                );
                              },
                              items: todos,
                              enterTransition: [FlipInX(), ScaleIn()],
                              exitTransition: [SlideInLeft()],
                              insertDuration: const Duration(milliseconds: 300),
                              removeDuration: const Duration(milliseconds: 300),
                              onReorder: (oldIndex, newIndex) {
                                List<TodoModel> ranges;
                                TodoModel item;
                                if (newIndex < oldIndex) {
                                  item = todos[oldIndex];
                                  ranges = todos
                                      .getRange(newIndex, oldIndex)
                                      .toList();
                                  todos.removeRange(newIndex, oldIndex);
                                  todos.add(item);
                                  todos.replaceRange(
                                      newIndex + 1, items.length, ranges);
                                } else {
                                  item = todos[newIndex];

                                  ranges = todos
                                      .getRange(oldIndex, newIndex)
                                      .toList();
                                  todos.removeRange(oldIndex, newIndex);
                                  todos.replaceRange(
                                      newIndex, items.length, ranges);
                                  todos.add(item);
                                }
                              },
                            ),
                    ),
                  );
                }),
          );
        },
      );
    });
  }
}
