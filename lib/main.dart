// ignore_for_file: overridden_fields

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:orderable_todo/data_store/data_store.dart';
import 'package:orderable_todo/data_store/hive_store.dart';
import 'package:orderable_todo/models/todo_model.dart';
import 'package:orderable_todo/provider/theme_provider.dart';
import 'package:orderable_todo/provider/todo_provider.dart';
import 'package:orderable_todo/views/pages/main_page.dart';
import 'package:provider/provider.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter<TodoModel>(TodoAdapter());
  await Hive.openBox<TodoModel>(HiveDataStore.boxName);
  await Hive.openBox('settings');
  DataStore().getItems();
  runApp(BaseWidget(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TodoProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: ValueListenableBuilder(
          valueListenable: Hive.box('settings').listenable(),
          builder: (context, box, child) {
            final isDark = box.get('isDark', defaultValue: false);
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Flutter Demo',
              theme: isDark
                  ? ThemeData.dark()
                  : ThemeData(
                      colorScheme:
                          ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                      useMaterial3: true,
                    ),
              home: const MainPage(),
            );
          }),
    );
  }
}

class BaseWidget extends InheritedWidget {
  BaseWidget({super.key, required this.child}) : super(child: child);
  final HiveDataStore dataStore = HiveDataStore();
  @override
  final Widget child;

  static BaseWidget of(BuildContext context) {
    final base = context.dependOnInheritedWidgetOfExactType<BaseWidget>();
    if (base != null) {
      return base;
    } else {
      throw StateError('Could not find ancestor widget of type BaseWidget');
    }
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }
}
