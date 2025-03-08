import 'package:hive/hive.dart';

part 'user.g.dart'; 

@HiveType(typeId: 0) // Assign a unique typeId
class User extends HiveObject {
  @HiveField(0) // Field index must be unique
  final String username;

  @HiveField(1)
  final String email;

  User({required this.username, required this.email});
}
