import "package:flutter/material.dart";
import "package:emotiary/core/theme/app_colors.dart";

class PrimarySearchBar extends StatelessWidget {
  final double height;
  final FocusNode focusNode;
  final Widget? leading;
  final String hintText;
  final TextStyle hintStyle;
  final TextStyle textStyle;
  final Function(String query)? onChanged;

  const PrimarySearchBar({
    super.key,
    required this.height,
    required this.focusNode,
    this.leading,
    required this.hintText,
    required this.hintStyle,
    required this.textStyle,
    this.onChanged
  });

  @override
  Widget build(BuildContext context) {
    return SearchBar(
      focusNode: focusNode,
      constraints: BoxConstraints(minHeight: height),
      backgroundColor: WidgetStateProperty.all(Colors.white),
      overlayColor: WidgetStateProperty.all(Colors.transparent),
      elevation: WidgetStateProperty.all(0),
      leading: leading,
      hintText: hintText,
      hintStyle: WidgetStateProperty.all(hintStyle),
      textStyle: WidgetStateProperty.all(textStyle),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30), 
          side: BorderSide(width: 1, color: (focusNode.hasFocus) ? AppColors.brownSugar : AppColors.griege)
        )
      ),
      onChanged: onChanged,
    );
  }
}
