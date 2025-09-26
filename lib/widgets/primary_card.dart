import "package:flutter/material.dart";

class PrimaryCard extends StatelessWidget {
  final Function()? onTap;
  final Widget content;

  const PrimaryCard({
    super.key,
    this.onTap,
    required this.content
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(32),
        child: Ink(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                offset: const Offset(0, 4),
                blurRadius: 8,
                spreadRadius: -4
              )
            ]
          ),
          child: content
        )
      )
    );
  }
}
