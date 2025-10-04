import "package:flutter/material.dart";

class PrimaryCard extends StatelessWidget {
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Function()? onTap;
  final Widget content;

  const PrimaryCard({
    super.key,
    this.width,
    this.height,
    this.margin,
    this.padding,
    this.onTap,
    required this.content
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(32),
        child: Ink(
          padding: padding,
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
