import 'package:flutter/material.dart';
import 'package:habify/viewmodels/splash_viewmodel.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final SplashViewModel _viewModel = SplashViewModel(); // ✅ Fixed class name

  @override
  void initState() {
    super.initState();
    _viewModel.startNavigation(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Stack(
          children: [
            // Background Image
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/image 1 (1).png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Centered Content
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min, // Keeps Column compact
                children: [
                  // Splash Image
                  Container(
                    width: 350,
                    height: 350,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/splash.png'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20), // Adds spacing
                  // Loading Indicator
                  ValueListenableBuilder<bool>(
                    valueListenable: _viewModel.isLoading,
                    builder: (context, isLoading, _) {
                      return isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
