import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


final TextStyle titleStyle =
    GoogleFonts.unbounded(
      fontWeight: FontWeight.w800, 
      fontSize: 18,
      color: Colors.white
      ); 
      
class ScreenStyle extends StatelessWidget {
  const ScreenStyle({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  'assets/images/image 1 (1).png'), // Your background image path
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0x99000000), // Transparent Black
                Color(0x66000000), // More Transparent Black
              ],
            ),
          ),
        ),
      ],
    );
  }
}
