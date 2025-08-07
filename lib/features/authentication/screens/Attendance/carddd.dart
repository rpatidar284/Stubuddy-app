import 'package:flutter/material.dart';

class Carddd extends StatelessWidget {
  const Carddd({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0D0D15),

      body: Center(
        child: Container(
          height: 200,
          width: 350,
          padding: const EdgeInsets.all(20), // Padding for the content inside
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A2A), // Inner dark background color
            borderRadius: BorderRadius.circular(20), // Rounded corners
            boxShadow: [
              // Inner "glow" (subtle light blue/pink)
              BoxShadow(
                color: Colors.blue.withOpacity(0.3),
                blurRadius: 5.0,
                spreadRadius: 2.0,
                offset: const Offset(-5, -5),
              ),
              BoxShadow(
                color: Colors.pink.withOpacity(0.3),
                blurRadius: 5.0,
                spreadRadius: 2.0,
                offset: const Offset(5, 5),
              ),
              // Outer "glow" (more intense and wider spread)
              BoxShadow(
                color: Colors.blue.withOpacity(0.15),
                blurRadius: 10.0,
                spreadRadius: 5.0,
                offset: const Offset(-10, -10),
              ),
              BoxShadow(
                color: Colors.pink.withOpacity(0.15),
                blurRadius: 10.0,
                spreadRadius: 5.0,
                offset: const Offset(10, 10),
              ),
            ],
          ),
          // child:
        ),
      ),
    );
  }
}
