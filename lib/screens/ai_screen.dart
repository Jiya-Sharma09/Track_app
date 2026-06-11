import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:track_app/providers/todo_provider.dart';
import 'package:track_app/service/gemini_service.dart';
import 'package:track_app/model/chat_messages.dart';

class AiScreen extends StatefulWidget {
  const AiScreen({super.key});

  @override
  State<AiScreen> createState() => _AiScreenState();
}

class _AiScreenState extends State<AiScreen> {
  final List<ChatMessages> _messages = [];
  final _gemini = GeminiService();
  final _inputController = TextEditingController();
  final _scrollController = ScrollController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initialLoadMessage();
  }

  Future<void> _initialLoadMessage() async {
    final todos = context.read<TodoProvider>().todos;
    final prompt = _gemini.buildInitialPrompt(todos);

    setState(() => _isLoading = true);

    final response = await _gemini.sendMessage(prompt);

    setState(() {
      _messages.add(ChatMessages(sender: "ai", text: response));
      _isLoading = false;
    });
    _scrollToBottom();
  }

  Future<void> _chatting(String userMessage) async {
    if (userMessage.trim().isEmpty) return;

    setState(() {
      _messages.add(ChatMessages(sender: "user", text: userMessage.trim()));
      _isLoading = true;
    });
    _inputController.clear();
    _scrollToBottom();

    final reply = await _gemini.sendMessage(userMessage.trim());

    setState(() {
      _messages.add(ChatMessages(sender: "ai", text: reply));
      _isLoading = false;
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
  final todos = context.read<TodoProvider>().todos;
  final prompt = _gemini.buildInitialPrompt(todos);
  
  setState(() {
    _messages.clear();  // clear old conversation
    _gemini.clearHistory(); // clear Gemini's memory too
    _isLoading = true;
  });

  final response = await _gemini.sendMessage(prompt);

  setState(() {
    _messages.add(ChatMessages(sender: "ai", text: response));
    _isLoading = false;
  });
  _scrollToBottom();
}



  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text("Your AI Productivity Coach !"),
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        centerTitle: true,
        // Add to AppBar actions
         actions: [ IconButton(
            onPressed: _isLoading ? null : _refresh,
            icon: const Icon(Icons.refresh),
            tooltip: 'Re-analyse my tasks',
          ),]
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: scheme.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const SizedBox(
                        width: 40,
                        child: LinearProgressIndicator(),
                      ),
                    ),
                  );
                }

                final message = _messages[index];
                final isUser = message.sender == "user";

                return Align(
                  alignment: isUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    decoration: BoxDecoration(
                      color: isUser
                          ? scheme.primary
                          : scheme.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      message.text,
                      style: TextStyle(
                        color: isUser ? scheme.onPrimary : scheme.onSurface,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _inputController,
                    decoration: InputDecoration(
                      hintText: 'Ask your productivity coach...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onSubmitted: (value) => _chatting(value),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  onPressed: _isLoading
                      ? null
                      : () => _chatting(_inputController.text),
                  icon: const Icon(Icons.send_rounded),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
