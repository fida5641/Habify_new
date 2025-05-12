import 'package:flutter/material.dart';

class GreetingHeader extends StatelessWidget {
  final String username;

  const GreetingHeader({
    super.key,
    required this.username,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: const DecorationImage(
                  image: AssetImage('assets/images/image 1 (1).png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              top: 20,
              left: 20,
              child: Text(
                'Hello, \n$username',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Positioned(
              top: 20,
              right: 20,
              child: Image.asset('assets/images/calender.png',
                  width: 100, height: 100),
            ),
          ],
        ),
      ),
    );
  }
}