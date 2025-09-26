import "dart:convert";
import "package:flutter_quill/flutter_quill.dart";
import "package:flutter_quill/quill_delta.dart";

class QuillUtils {
  static String jsonToPlainText(String jsonString) => Document.fromDelta(Delta.fromJson(jsonDecode(jsonString))).toPlainText();
}
