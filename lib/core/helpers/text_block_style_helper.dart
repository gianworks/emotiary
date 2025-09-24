import "package:flutter/material.dart";
import "package:flutter_quill/flutter_quill.dart";

class TextBlockStyleHelper {
  static DefaultTextBlockStyle create(TextStyle textStyle) {
    return DefaultTextBlockStyle(
      textStyle, 
      const HorizontalSpacing(0, 0), 
      const VerticalSpacing(0, 0), 
      const VerticalSpacing(0, 0), 
      null
    );
  }  
}
