import "package:flutter/material.dart";
import "package:emotiary/core/theme/app_colors.dart";
import "package:emotiary/core/theme/app_text_styles.dart";

class BottomAppBarItem extends StatelessWidget {
  final int index;
  final int currentNavIndex;
  final IconData unselectedIcon;
  final IconData selectedIcon;
  final String label;
  final Function(int) onTap;

  const BottomAppBarItem({
    super.key,
    required this.index,
    required this.currentNavIndex,
    required this.unselectedIcon,
    required this.selectedIcon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () => onTap(index),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon((currentNavIndex == index) ? selectedIcon : unselectedIcon, color: AppColors.taupeGray),
              Text(label, style: AppTextStyles.bodySmall)
            ]
          )
        )
      )
    );
  }
}
