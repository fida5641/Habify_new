import 'package:flutter/material.dart';

class SplashViewModel {
  final ValueNotifier<bool> isLoading = ValueNotifier(true);

  void startNavigation(BuildContext context) async {
    await Future.delayed(Duration(seconds: 2));
    isLoading.value = false;
    Navigator.pushReplacementNamed(context, '/login');
  }
}
