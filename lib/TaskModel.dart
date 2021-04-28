import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final String tableName = "todo";
final String Column_id = "id";
final String Column_minuman = "minuman";

class TaskModel {
  final String minuman;
  int id;

  TaskModel({this.minuman, this.id});
  Map<String, dynamic> toMap() {
    return {Column_minuman: this.minuman};
  }
}

class TodoHelper {
  Database db;

  TodoHelper() {
    initDatabase();
  }

  Future<void> initDatabase() async {
    db = await openDatabase(join(await getDatabasesPath(), "mariani.db"),
        onCreate: (db, version) {
      return db.execute(
          "CREATE TABLE $tableName($Column_id INTERGER PRIMARY KEY AUTO INCREMENT , $Column_minuman TEXT)");
    }, version: 1);
  }

  Future<void> insertTask(TaskModel task) async {
    try {
      db.insert(tableName, task.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (_) {
      print(_);
    }
  }

  Future<List<TaskModel>> getAllTask() async {
    final List<Map<String, dynamic>> tasks = await db.query(tableName);

    List.generate(tasks.length, (i) {
      return TaskModel(
          minuman: tasks[i][Column_minuman], id: tasks[i][Column_id]);
    });
  }
}
