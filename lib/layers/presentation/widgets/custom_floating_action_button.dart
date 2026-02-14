import 'package:flutter/material.dart';
import 'package:food_control/layers/presentation/style/app_colors.dart';

class CustomFloatingActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget? icon;
  final double? iconSize;

  const CustomFloatingActionButton({
    super.key,
    required this.onPressed,
    this.icon,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      shape: const CircleBorder(),
      backgroundColor: AppColors.standart,
      foregroundColor: Colors.white,
      child: icon ??
          const Icon(
            Icons.add,
            size: 30,
          ),
    );
  }
}