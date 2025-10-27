import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color color;
  final IconData icon;
  final VoidCallback onPressed;

  const CustomButton({
    super.key,
    required this.text,
    required this.color,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: Icon(icon, color: Colors.white),
        label: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
