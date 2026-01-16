import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';
import 'package:journal/services/ai_providers.dart';

class Chat extends ConsumerStatefulWidget{
  const Chat({super.key});

  @override
  ConsumerState<Chat> createState() {
    return _ChatState();
  }

}


class _ChatState extends ConsumerState<Chat> {

  final chatProvider = OllamaChatProvider(
    model:'qwen2:7b',
    apiUrl:'http://localhost:11434/api/chat'
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LlmChatView(
        provider: chatProvider,
        suggestions: const [
          "I've been feeling dizzy lately. What now?",
          "How do I know if I need to see a doctor?",
          "What should I eat to boost my immunity?"
        ],
        style: LlmChatViewStyle(
          backgroundColor: Colors.white,
        ),
      ),
    );
  }
}
