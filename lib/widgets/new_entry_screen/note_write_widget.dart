import "package:flutter/material.dart";
import 'package:flutter_quill/flutter_quill.dart';
import "package:emotiary/theme/app_colors.dart";

class NoteWriteWidget extends StatelessWidget {
  final QuillController titleQuillController;
  final QuillController noteQuillController;
  final QuillController activeController;

  final FocusNode titleFocusNode;
  final FocusNode noteFocusNode;

  final bool isKeyboardUp;

  const NoteWriteWidget({
    super.key,
    required this.titleQuillController,
    required this.noteQuillController,
    required this.activeController,
    required this.titleFocusNode,
    required this.noteFocusNode,
    required this.isKeyboardUp
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              Text("What would you call this entry?", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.veryDarkBrown)),
              const SizedBox(height: 10),
              Container(
                height: 45,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white, 
                  border: Border.all(width: 1, color: AppColors.tan),
                  borderRadius: BorderRadius.all(Radius.circular(8))
                ),
                child: QuillEditor.basic(
                  controller: titleQuillController,
                  focusNode: titleFocusNode,
                  config: QuillEditorConfig(
                    autoFocus: true,
                    scrollable: true,
                    expands:  true,
                    placeholder: "Add a title..",
                    customStyles: DefaultStyles(
                      paragraph: DefaultTextBlockStyle(
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.veryDarkBrown),
                        HorizontalSpacing(0, 0),
                        VerticalSpacing(0, 0),
                        VerticalSpacing(0, 0),
                        null
                      ),
                      placeHolder: DefaultTextBlockStyle(
                        TextStyle(fontSize: 16, color: Colors.grey[400]),
                        HorizontalSpacing(0, 0),
                        VerticalSpacing(0, 0),
                        VerticalSpacing(0, 0),
                        null
                      )
                    )
                  )
                )
              ),
              const SizedBox(height: 20),
              Text("What's on your mind today?", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.veryDarkBrown)),
              const SizedBox(height: 10),
              Container(
                height: 200,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white, 
                  border: Border.all(width: 1, color: AppColors.tan),
                  borderRadius: BorderRadius.all(Radius.circular(8))
                ),
                child: QuillEditor.basic(
                  controller: noteQuillController,
                  focusNode: noteFocusNode,
                  config: QuillEditorConfig(
                    scrollable: true,
                    expands:  true,
                    placeholder: "Add a note..",
                    customStyles: DefaultStyles(
                      paragraph: DefaultTextBlockStyle(
                        TextStyle(fontSize: 16, color: AppColors.veryDarkBrown),
                        HorizontalSpacing(0, 0),
                        VerticalSpacing(0, 0),
                        VerticalSpacing(0, 0),
                        null
                      ),
                      placeHolder: DefaultTextBlockStyle(
                        TextStyle(fontSize: 16, color: Colors.grey[400]),
                        HorizontalSpacing(0, 0),
                        VerticalSpacing(0, 0),
                        VerticalSpacing(0, 0),
                        null
                      )
                    )
                  )
                )
              ),
            ]
          )
        )
      ),
      bottomSheet: (isKeyboardUp) ? QuillSimpleToolbar(
        controller: activeController,
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
          showListBullets: false,
          showListNumbers: false,
          showQuote: (noteFocusNode.hasFocus),
          showBoldButton: (noteFocusNode.hasFocus),
          color: AppColors.beige
        )
      ) : SizedBox.shrink()
    );
  }
}
