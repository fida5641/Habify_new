import 'package:habify/models/habit.dart';
import 'package:habify/models/note.dart';
import 'package:habify/models/user.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DatabaseService {
  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(UserAdapter());
    Hive.registerAdapter(HabitAdapter());
    Hive.registerAdapter(CustomNoteAdapter());
    await Hive.openBox<User>('userBox');
    await Hive.openBox<Habit>('habits');
    await Hive.openBox<CustomNote>('notes');
  }
}
