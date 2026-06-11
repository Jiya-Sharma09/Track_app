import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:track_app/service/gemini_key.dart';
import 'package:track_app/model/todo_model.dart';

class GeminiService {
  final _model = GenerativeModel(
    model: 'gemini-2.5-flash',
    apiKey: GeminiConfig.apiKey,
  );

  final _chat = <Content>[]; // maintains conversation history for multi-turn

  Future<String> sendMessage(String userMessage) async {
    try{_chat.add(Content.text(userMessage));

    final response = await _model.generateContent(_chat);
    final reply = response.text ?? "No response generated.";

    _chat.add(Content.model([TextPart(reply)]));
    return reply;}catch(e){
      _chat.removeLast();
      return "Something went wrong. Please try again.";
    }
  }

  String buildInitialPrompt(List<Todo> todos) {
    final taskList = todos
        .map((t) => '- ${t.title} [${t.isDone ? "done" : "pending"}]')
        .join('\n');

    return """
              You are a productivity coach. Here are my tasks for today:

              $taskList

              Please provide:
              1. Summary of today's progress
              2. Completion percentage
              3. Suggestions to finish remaining tasks using techniques like Eat the Frog or Pomodoro
              4. A short motivational message

              Keep it concise.
           """;
  }

  void clearHistory() => _chat.clear();
}
