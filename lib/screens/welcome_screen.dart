import "package:flutter/material.dart";
import "package:emotiary/core/theme/app_colors.dart";
import "package:emotiary/core/theme/app_text_styles.dart";
import "package:emotiary/core/helpers/snack_bar_helper.dart";
import "package:emotiary/widgets/primary_search_bar.dart";
import "package:emotiary/widgets/primary_button.dart";

class WelcomeScreen extends StatefulWidget {
  final Function(String) onSaveUsername; 

  const WelcomeScreen({
    required this.onSaveUsername,
    super.key
  });

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController _pageController = PageController();
  final TextEditingController _searchBarController = TextEditingController();
  final FocusNode _searchBarFocusNode = FocusNode();

  void _goToNextPage() {
    if (_searchBarController.text.isEmpty) {
      SnackBarHelper.show("Please enter a name before continuing.", context);
      return;
    }

    if (_searchBarController.text.length > 10) {
      SnackBarHelper.show("Please enter a name under 10 characters.", context);
      return;
    }

    FocusScope.of(context).unfocus();
    _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  @override 
  void initState() {
    super.initState();
    _searchBarFocusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
    _searchBarController.dispose();
    _searchBarFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: [
          ListView(
            padding: const EdgeInsetsGeometry.symmetric(horizontal: 32),
            physics: NeverScrollableScrollPhysics(),
            children: [
              const SizedBox(height: 256),
              Text("Hi there, what\nshould we call you?", style: AppTextStyles.headlineLarge, textAlign: TextAlign.center),
              const SizedBox(height: 32),
              PrimarySearchBar(
                height: 48, 
                controller: _searchBarController,
                focusNode: _searchBarFocusNode,
                hintText: "Enter a name..", 
                hintStyle: TextStyle(fontSize: 20, color: AppColors.warmGray), 
                textStyle: TextStyle(fontSize: 20, color: AppColors.brownSugar, fontWeight: FontWeight.w500)
              ),
              const SizedBox(height: 64),
              PrimaryButton(
                label: "Continue",
                onPressed: _goToNextPage
              )
            ]
          ),
          ListView(
            padding: const EdgeInsetsGeometry.symmetric(horizontal: 16),
            physics: NeverScrollableScrollPhysics(),
            children: [
              const SizedBox(height: 192),
              Text("👋", style: TextStyle(fontSize: 48), textAlign: TextAlign.center),
              const SizedBox(height: 16),
              Text("Nice to meet you,\n${_searchBarController.text}", style: AppTextStyles.headlineLarge, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              Text("We'll use your name to make journaling more personal. You can change it anytime in settings.", style: AppTextStyles.bodyLarge, textAlign: TextAlign.center),
              const SizedBox(height: 64),
              PrimaryButton(
                label: "Let's Begin",
                onPressed: () => widget.onSaveUsername(_searchBarController.text)
              )
            ]
          )
        ]
      )
    );
  }
}
