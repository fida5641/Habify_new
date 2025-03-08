import 'package:hive/hive.dart';

part 'note.g.dart';

@HiveType(typeId: 2)
class CustomNote extends HiveObject {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String content;

  CustomNote({
    required this.title,
    required this.content,
  });
}
