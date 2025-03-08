import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileViewModel {
  final ValueNotifier<String> username = ValueNotifier("Guest");
  final ValueNotifier<String> email = ValueNotifier("Not Set");

  ProfileViewModel() {
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    username.value = prefs.getString("username") ?? "Guest";
    email.value = prefs.getString("email") ?? "Not Set";
  }

  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    Navigator.pushReplacementNamed(context, '/login');
  }

  void dispose() {
    username.dispose();
    email.dispose();
  }
}
