import "package:flutter/material.dart";
import 'package:flutter_quill/flutter_quill.dart';
import "package:emotiary/theme/app_colors.dart";

class NoteWriteWidget extends StatelessWidget {
  final QuillController titleQuillController;
  final QuillController noteQuillController;

  final FocusNode titleFocusNode;
  final FocusNode noteFocusNode;

  final bool isKeyboardUp;

  const NoteWriteWidget({
    super.key,
    required this.titleQuillController,
    required this.noteQuillController,
    required this.titleFocusNode,
    required this.noteFocusNode,
    required this.isKeyboardUp
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            Center(
              child: Container(
                width: 350,
                height: 50,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(width: 1, color: AppColors.tan),
                  borderRadius: BorderRadius.circular(8)
                ),
                child: QuillEditor.basic(
                  controller: titleQuillController,
                  focusNode: titleFocusNode,
                  config: QuillEditorConfig(
                    autoFocus: true,
                    scrollable: true,
                    expands:  true,
                    placeholder: "Add title..",
                    customStyles: DefaultStyles(
                      paragraph: DefaultTextBlockStyle(
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.veryDarkBrown),
                        HorizontalSpacing(0, 0),
                        VerticalSpacing(0, 0),
                        VerticalSpacing(0, 0),
                        null
                      ),
                      placeHolder: DefaultTextBlockStyle(
                        TextStyle(fontSize: 20, color: Colors.grey),
                        HorizontalSpacing(0, 0),
                        VerticalSpacing(0, 0),
                        VerticalSpacing(0, 0),
                        null
                      )
                    )
                  )
                )
              )
            ),
            const SizedBox(height: 20),
            Center(
              child: Container(
                width: 350,
                height: 400,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(width: 1, color: AppColors.tan),
                  borderRadius: BorderRadius.circular(8)
                ),
                child: QuillEditor.basic(
                  controller: noteQuillController,
                  focusNode: noteFocusNode,
                  config: QuillEditorConfig(
                    placeholder: "Add note..",
                    customStyles: DefaultStyles(
                      paragraph: DefaultTextBlockStyle(
                        TextStyle(fontSize: 16, color: AppColors.brown),
                        HorizontalSpacing(0, 0),
                        VerticalSpacing(0, 0),
                        VerticalSpacing(0, 0),
                        null
                      ),
                      placeHolder: DefaultTextBlockStyle(
                        TextStyle(fontSize: 16, color: Colors.grey),
                        HorizontalSpacing(0, 0),
                        VerticalSpacing(0, 0),
                        VerticalSpacing(0, 0),
                        null
                      )
                    )
                  )
                )
              )
            )
          ]
        )
      ),
      bottomSheet: (isKeyboardUp) ? QuillSimpleToolbar(
        controller: (titleFocusNode.hasFocus) ? titleQuillController : noteQuillController,
        config: QuillSimpleToolbarConfig(
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
          showColorButton: false,
          showBackgroundColorButton: false,
          showListBullets: false,
          showListNumbers: false,
          showQuote: (noteFocusNode.hasFocus),
          showBoldButton: (noteFocusNode.hasFocus),
          color: AppColors.beige
        )
      ) : null
    );
  }
}
