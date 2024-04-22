import 'package:hive/hive.dart';
import 'package:xid/xid.dart';

part 'todo_extended.dart';

@HiveType(typeId: 0)
class TodoModel extends HiveObject {
  @override
  @HiveField(0)
  String key;
  @HiveField(1)
  int index;
  @HiveField(2)
  String title;
  @HiveField(3)
  String detail;
  @HiveField(4)
  DateTime dueDate;
  @HiveField(5)
  DateTime createdAt;
  @HiveField(6)
  String status;

  TodoModel({
    required this.index,
    required this.title,
    required this.dueDate,
    required this.createdAt,
    required this.status,
    required this.key,
    required this.detail,
  });
  factory TodoModel.create({
    required int index,
    required String title,
    required String detail,
    required String? status,
    DateTime? createdAt,
    DateTime? dueDate,
  }) {
    // final int index = _currentIndex++;
    return TodoModel(
      index: index,
      title: title,
      detail: detail,
      createdAt: createdAt ?? DateTime.now(),
      status: status ?? "",
      dueDate: dueDate ?? DateTime.now(),
      key: Xid().toString(),
    );
  }
}
