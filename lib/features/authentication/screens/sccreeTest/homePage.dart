import 'package:flutter/material.dart';

class BackgroundPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Set Scaffold's background to transparent as the Column will fill the screen
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Column(
            children: [
              // Top dark blue section with wave pattern
              Expanded(
                // flex: 35 means this section takes approx 35% of the screen height
                flex: 19,
                child: Container(
                  color: const Color(
                    0xFF2C2D6D,
                  ), // Dominant dark blue color (approximated from image)
                  child: CustomPaint(
                    painter: WavePatternPainter(),
                    // You can place widgets like "Hi, Ramdan!" and "Total Balance" here
                    // For this request, we are only building the background.
                    child: Center(
                      // Example: Uncomment to see the top section placeholder
                      // child: Text(
                      //   'Top Section (Background)',
                      //   style: TextStyle(color: Colors.white, fontSize: 20),
                      // ),
                    ),
                  ),
                ),
              ),
              // Bottom white rounded section
              Expanded(
                // flex: 65 means this section takes approx 65% of the screen height
                flex: 81,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    // Apply rounded corners only to the top
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30.0),
                    ),
                  ),
                  // You can place widgets like "Recent activities" cards here
                  // For this request, we are only building the background.
                  child: Center(
                    // Example: Uncomment to see the bottom section placeholder
                    // child: Text(
                    //   'Bottom Section (Background)',
                    //   style: TextStyle(color: Colors.black, fontSize: 20),
                    // ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// CustomPainter to draw the wavy background lines
class WavePatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          // Lighter blue/purple for waves, with some transparency for a subtle effect
          ..color = const Color(0xFF4A4B8F)
          ..style =
              PaintingStyle
                  .stroke // Draw lines only (not filled)
          ..strokeWidth = 1.0; // Thin lines

    // These paths are approximated to mimic the waves in the image.
    // Adjust control points and positions for exact replication.

    // Wave 1 (highest)
    Path path1 = Path();
    path1.moveTo(0, size.height * 0.15);
    path1.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.20,
      size.width * 0.5,
      size.height * 0.15,
    );
    path1.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.10,
      size.width,
      size.height * 0.15,
    );
    canvas.drawPath(path1, paint);

    // Wave 2 (middle)
    Path path2 = Path();
    path2.moveTo(0, size.height * 0.40);
    path2.quadraticBezierTo(
      size.width * 0.2,
      size.height * 0.35,
      size.width * 0.4,
      size.height * 0.40,
    );
    path2.quadraticBezierTo(
      size.width * 0.6,
      size.height * 0.45,
      size.width * 0.8,
      size.height * 0.40,
    );
    path2.quadraticBezierTo(
      size.width * 0.95,
      size.height * 0.35,
      size.width,
      size.height * 0.40,
    );
    canvas.drawPath(path2, paint);

    // Wave 3 (closer to the bottom of the dark section)
    Path path3 = Path();
    path3.moveTo(0, size.height * 0.65);
    path3.quadraticBezierTo(
      size.width * 0.3,
      size.height * 0.70,
      size.width * 0.6,
      size.height * 0.65,
    );
    path3.quadraticBezierTo(
      size.width * 0.9,
      size.height * 0.60,
      size.width,
      size.height * 0.65,
    );
    canvas.drawPath(path3, paint);

    // Wave 4 (lower, more subtle)
    Path path4 = Path();
    path4.moveTo(0, size.height * 0.85);
    path4.quadraticBezierTo(
      size.width * 0.15,
      size.height * 0.80,
      size.width * 0.3,
      size.height * 0.85,
    );
    path4.quadraticBezierTo(
      size.width * 0.45,
      size.height * 0.90,
      size.width * 0.6,
      size.height * 0.85,
    );
    path4.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.80,
      size.width * 0.9,
      size.height * 0.85,
    );
    path4.quadraticBezierTo(
      size.width,
      size.height * 0.90,
      size.width,
      size.height * 0.85,
    );
    canvas.drawPath(path4, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // Return false as the waves are static and don't need to be repainted unless parameters change.
    return false;
  }
}
