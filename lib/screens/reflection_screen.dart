import "package:flutter/material.dart";
import "package:icons_plus/icons_plus.dart";
import "package:emotiary/core/theme/app_colors.dart";
import "package:emotiary/core/theme/app_text_styles.dart";
import "package:emotiary/widgets/primary_card.dart";

class ReflectionScreen extends StatefulWidget {
  final String reflectionText;

  const ReflectionScreen({super.key, required this.reflectionText});

  @override
  State<ReflectionScreen> createState() => _ReflectionScreenState();
}

class _ReflectionScreenState extends State<ReflectionScreen> {
  

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsetsGeometry.symmetric(horizontal: 16),
      physics: NeverScrollableScrollPhysics(),
      children: [
        const SizedBox(height: 32),
        Text("Reflection", style: AppTextStyles.headlineLarge),
        const SizedBox(height: 32),
        PrimaryCard(
          padding: const EdgeInsetsGeometry.all(24),
          content: Column(
            children: [
              const Icon(AntDesign.book_fill, color: AppColors.darkBrown),
              const SizedBox(height: 8),
              const Text("Here's what we found\nfrom your recent journaling.", style: AppTextStyles.titleSmall, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              Text(widget.reflectionText, style: AppTextStyles.bodyLarge, textAlign: TextAlign.center)
            ]
          )
        )
      ]
    );
  }
}
