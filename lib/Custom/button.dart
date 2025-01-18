import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  // Accepting parameters e
  final String text;
  final Color textColor;
  final VoidCallback onPressed;
  final double borderRadius;

  // Constructor
  const Button({
    super.key,
    required this.text,
    required this.textColor,
    required this.onPressed,
    this.borderRadius = 8.0, 
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
      
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(color: textColor),
      ),
    );
  }
}
