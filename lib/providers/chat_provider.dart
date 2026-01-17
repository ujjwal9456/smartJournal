import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:journal/services/ai_providers.dart';

// Provider for the chat instance that persists across navigation
final chatProviderProvider = Provider<OllamaChatProvider>((ref) {
  return OllamaChatProvider(
    model: 'llama3.2:1b',
    apiUrl: 'http://localhost:8000/chat'
  );
});

// Provider to track if chat is initialized
final chatInitializedProvider = StateProvider<bool>((ref) => false);