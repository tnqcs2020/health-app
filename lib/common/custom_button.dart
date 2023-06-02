import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color? color;
  final double height, width, borderRadius;
  const CustomButton({
    Key? key,
    required this.text,
    required this.onTap,
    this.color,
    this.height = 60,
    this.width = double.infinity,
    this.borderRadius = 20,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(width, height),
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color == null ? Colors.white : Colors.black,
          fontSize: 20,
        ),
      ),
    );
  }
}
