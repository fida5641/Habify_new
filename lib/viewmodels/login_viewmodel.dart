import 'package:flutter/material.dart';
import 'package:habify/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive/hive.dart';

class LoginViewmodel {
  final ValueNotifier<bool> isLoading = ValueNotifier(false);
  final ValueNotifier<String?> errorMessage = ValueNotifier(null);

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<void> checkLoginStatus(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      final username = prefs.getString('username') ?? 'Guest';
      Navigator.pushReplacementNamed(context, '/bottom_nav', arguments: {
  'username': username,
});
    }
  }

  Future<void> loginUser(BuildContext context) async {
    if (!formKey.currentState!.validate()) {
      errorMessage.value = 'Please enter valid details';
      return;
    }

    isLoading.value = true;
    final String name = nameController.text;
    final String email = emailController.text;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('username', name);
    await prefs.setString('email', email);

    final user = User(username: name, email: email);
    final box = Hive.box<User>('userBox');
    await box.put('loggedInUser', user);

    isLoading.value = false;

   Navigator.pushReplacementNamed(context, '/bottom_nav', arguments: {
  'username': name,
});
  }

  void dispose() {
    nameController.dispose();
    emailController.dispose();
    isLoading.dispose();
    errorMessage.dispose();
  }
}
