import 'package:flutter/material.dart';

class FeatureCard extends StatelessWidget {
  final String title;
  final String iconPath;
  final VoidCallback onTap;

  const FeatureCard({
    Key? key,
    required this.title,
    required this.iconPath,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,

            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                iconPath,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
