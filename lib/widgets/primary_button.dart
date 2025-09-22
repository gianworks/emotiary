import "package:flutter/material.dart";
import "package:icons_plus/icons_plus.dart";
import "package:emotiary/theme/app_colors.dart";

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              offset: const Offset(0, 8),
              blurRadius: 16,
              spreadRadius: -8
            )
          ]
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            fixedSize: const Size(320, 40),
            backgroundColor: AppColors.brownSugar,
            foregroundColor: Colors.white,
            elevation: 0,
            shadowColor: Colors.transparent
          ),
          onPressed: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text("Continue", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              SizedBox(width: 8),
              Icon(AntDesign.right_outline, size: 16)
            ]
          )
        )
      )
    );
  }
}
