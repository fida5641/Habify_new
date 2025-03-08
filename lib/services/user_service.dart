import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class UserService {
  final ValueNotifier<List<User>> users = ValueNotifier([]);

  UserService() {
    loadUsers();
  }

  Future<void> addUser(User user) async {
    final box = Hive.box<User>('users');
    await box.add(user);
    loadUsers(); // Refresh UI
  }

  void loadUsers() {
    final box = Hive.box<User>('users');
    users.value = box.values.toList();
  }

  Future<void> updateUser(User user) async {
    await user.save();
    loadUsers(); // Refresh UI
  }

  Future<void> deleteUser(String id) async {
    final box = Hive.box<User>('users');
    await box.delete(id);
    loadUsers(); // Refresh UI
  }

  Future<void> saveLoggedInUserName(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('loggedInUserName', username);
  }

  Future<String?> getLoggedInUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('loggedInUserName');
  }
}
