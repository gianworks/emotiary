import "dart:convert";
import "package:flutter/material.dart";
import "package:flutter_quill/flutter_quill.dart";
import "package:emotiary/core/theme/app_colors.dart";
import "package:emotiary/core/theme/app_text_styles.dart";
import "package:emotiary/core/utils/quill_utils.dart";
import "package:emotiary/core/helpers/snack_bar_helper.dart";
import "package:emotiary/core/helpers/text_block_style_helper.dart";
import "package:emotiary/widgets/primary_button.dart";

class EntryWritingScreen extends StatefulWidget {
  final String? entryTitleJson;
  final String? entryTextJson;
  final bool isKeyboardVisible;
  final Function(String titleJson, String textJson) onFinished;

  const EntryWritingScreen({
    super.key,
    this.entryTitleJson,
    this.entryTextJson,
    required this.isKeyboardVisible,
    required this.onFinished
  });

  @override
  State<EntryWritingScreen> createState() => _EntryWritingScreenState();
}

class _EntryWritingScreenState extends State<EntryWritingScreen> with AutomaticKeepAliveClientMixin {
  late QuillController _titleQuillController;
  late QuillController _textQuillController;

  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _textFocusNode = FocusNode();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    _titleQuillController = (widget.entryTitleJson != null) 
    ? QuillController(
      document: QuillUtils.jsonToDocument(widget.entryTitleJson!),
      selection: TextSelection.collapsed(offset: 0)
    )
    : QuillController.basic();

    _textQuillController = (widget.entryTextJson != null) 
    ? QuillController(
      document: QuillUtils.jsonToDocument(widget.entryTextJson!),
      selection: TextSelection.collapsed(offset: 0)
    )
    : QuillController.basic();

    _titleFocusNode.addListener(() => setState(() {}));
    _textFocusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    super.dispose();
    _titleQuillController.dispose();
    _textQuillController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final bool isTitleNotEmpty = _titleQuillController.document.toPlainText().trim().isNotEmpty;
    final bool isTextNotEmpty = _textQuillController.document.toPlainText().trim().isNotEmpty;

    return Scaffold(
      body: ListView(
        padding: const EdgeInsetsGeometry.symmetric(horizontal: 16),
        children: [
          const SizedBox(height: 48),
          QuillEditor.basic(
            controller: _titleQuillController,
            focusNode: _titleFocusNode,
            config: QuillEditorConfig(
              placeholder: "Title",
              customStyles: DefaultStyles(
                paragraph: TextBlockStyleHelper.create(AppTextStyles.headlineMedium),
                placeHolder: TextBlockStyleHelper.create(TextStyle(fontFamily: "Urbanist", fontSize: 24, color: AppColors.warmGray))
              )
            )
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 384,
            child: QuillEditor.basic(
              controller: _textQuillController,
              focusNode: _textFocusNode,
              config: QuillEditorConfig(
                autoFocus: true,
                placeholder: "Write anything here..",
                customStyles: DefaultStyles(
                  paragraph: TextBlockStyleHelper.create(AppTextStyles.bodyLarge),
                  placeHolder: TextBlockStyleHelper.create(TextStyle(fontFamily: "Urbanist", fontSize: 16, color: AppColors.warmGray))
                )
              )
            )
          ),
          const SizedBox(height: 48),
          PrimaryButton(
            label: "Done", 
            onPressed: () => (isTitleNotEmpty && isTextNotEmpty) 
            ? widget.onFinished(
              jsonEncode(_titleQuillController.document.toDelta().toJson()),
              jsonEncode(_textQuillController.document.toDelta().toJson())
            ) 
            : SnackBarHelper.show("Please add a title and text before saving.", context)
          )
        ]
      ),
      backgroundColor: Colors.transparent,
      bottomSheet: (widget.isKeyboardVisible) ? QuillSimpleToolbar(
        controller: (_titleFocusNode.hasFocus) ? _titleQuillController : _textQuillController,
        config: const QuillSimpleToolbarConfig(
          multiRowsDisplay: false,
          showDividers: false,
          showFontFamily: false,
          showFontSize: false,
          showHeaderStyle: false,
          showClearFormat: false,
          showListCheck: false,
          showSubscript: false,
          showSuperscript: false,
          showInlineCode: false,
          showCodeBlock: false,
          showLink: false,
          showIndent: false,
          showUndo: false,
          showRedo: false,
          showListBullets: false,
          showListNumbers: false,
          showSearchButton: false,
          color: Colors.white,
          buttonOptions: QuillSimpleToolbarButtonOptions(
            base: QuillToolbarBaseButtonOptions(
              iconTheme: QuillIconTheme(
                iconButtonSelectedData: IconButtonData(color: Colors.white),
                iconButtonUnselectedData: IconButtonData(color: AppColors.taupeGray)
              )
            )
          )
        )
      ) : SizedBox.shrink()
    );
  }
}
