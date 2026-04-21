import 'package:flutter/material.dart';

Widget letter(String character, bool isSelected) {
  return Container(
    height: 45,
    width: 40,
    decoration: BoxDecoration(
      gradient: isSelected
          ? const LinearGradient(colors: [Colors.grey, Colors.grey])
          : const LinearGradient(
        colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
      ),
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.4),
          blurRadius: 4,
          offset: const Offset(0, 3),
        )
      ],
    ),
    child: Center(
      child: Text(
        character,
        style: TextStyle(
          color: isSelected ? Colors.white38 : Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 22.0,
          decoration: isSelected ? TextDecoration.lineThrough : null,
          decorationColor: Colors.white54,
          decorationThickness: 2,
        ),
      ),
    ),
  );
}
