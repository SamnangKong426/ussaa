import 'package:flutter/material.dart';

enum ChipColor {
  Active,
  Inactive,
}

Color getChipColor(ChipColor chipColor) {
  switch (chipColor) {
    case ChipColor.Active:
      return const Color.fromRGBO(5, 147, 255, 1.0);
    case ChipColor.Inactive:
      return const Color.fromARGB(255, 100, 95, 212);
    default:
      return Colors.grey;
  }
}

class CategoryButton extends StatelessWidget {
  final String categoryName;
  final bool isActive;
  final VoidCallback onPressed;

  const CategoryButton({
    Key? key,
    required this.categoryName,
    required this.isActive,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 5),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: isActive ? getChipColor(ChipColor.Active) : getChipColor(ChipColor.Inactive),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          side: BorderSide.none,
        ),
        child: Text(
          categoryName,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}