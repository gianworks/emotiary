import "dart:convert";
import "package:http/http.dart" as http;
import "package:emotiary/data/models/entry.dart";

String buildReflectionPrompt(List<Entry> entries) {
  final buffer = StringBuffer();
  buffer.writeln("You are an empathetic AI reflection coach.");
  buffer.writeln("Below are the user's recent journal entries, including their moods and activities.");
  buffer.writeln("Please provide a thoughtful reflection that summarizes their emotional patterns, progress, and insights.\n");

  for (final entry in entries) {
    buffer.writeln("Date: ${entry.date}");
    buffer.writeln("Mood: ${entry.mood} ${entry.moodEmoji}");
    buffer.writeln("Activities: ${entry.activities.keys.join(', ')}");
    buffer.writeln("Title: ${entry.titleJson}");
    buffer.writeln("Text: ${entry.textJson}\n");
  }

  buffer.writeln("Now, please reflect on the overall emotional and behavioral trends. Offer gentle insights or suggestions.");
  return buffer.toString();
}

Future<String> getOpenRouterResponse(String prompt) async {
  const endpoint = "https://openrouter.ai/api/v1/chat/completions";
  const apiKey = "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";

  final headers = {
    "Authorization": "Bearer $apiKey",
    "Content-Type": "application/json",
  };

  final body = jsonEncode({
    "model": "gpt-3.5-turbo",
    "messages": [
      {"role": "system", "content": "You are a kind and empathetic journaling reflection assistant."},
      {"role": "user", "content": prompt},
    ],
    "max_tokens": 100,
    "temperature": 0.7,
  });

  final response = await http.post(
    Uri.parse(endpoint),
    headers: headers,
    body: body,
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data["choices"][0]["message"]["content"];
  } else {
    throw Exception("Failed to get response: ${response.body}");
  }
}
