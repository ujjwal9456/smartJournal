import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';
import 'package:journal/providers/chat_provider.dart';

class Chat extends ConsumerWidget{
  const Chat({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatProvider = ref.watch(chatProviderProvider);
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
