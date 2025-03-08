import 'package:hive/hive.dart';

part 'habit.g.dart';

@HiveType(typeId: 1)
class Habit extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  bool isCompleted;

  @HiveField(2)
  int target;

  @HiveField(3)
  String status;

  @HiveField(4)
  String image;

  @HiveField(5)
  List<String> days;

  @HiveField(6)
  int segment;

  @HiveField(7)
  int selectedNumber;

  @HiveField(8)
  String selectedOptions;

  @HiveField(9)
  int currentSwipeCount;

  Habit({
    required this.name,
    this.isCompleted = false,
    required this.target,
    required this.status,
    required this.image,
    required this.days,
    this.segment = 0,
    this.selectedNumber = 1,
    this.selectedOptions = 'Hours',
    this.currentSwipeCount = 0,
  });
}
