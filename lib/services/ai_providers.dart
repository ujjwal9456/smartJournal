import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';
import 'package:journal/core/http_client.dart';

abstract class AiProviders {
  Future<String> request(String prompt);
}

class OllamaChatProvider extends ChangeNotifier implements LlmProvider {
  final String model;
  final String apiUrl;

  OllamaChatProvider({required this.model, required this.apiUrl});

  // internal mutable history; exposed as an unmodifiable iterable
  final List<ChatMessage> _history = <ChatMessage>[];

  @override
  Iterable<ChatMessage> get history => List.unmodifiable(_history);

  
  Future<String> request(String prompt) async {
    final headers = {
      "Content-Type": "application/json",
    };

    final data = {
      "model": model,
      "messages": [
        {"role": "user", "content": prompt}
      ],
      "stream": false
    };

    try {
      final response = await AppHttp.post(
        apiUrl,
        headers: headers,
        data: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        final decodedResponse = response.data;
        return decodedResponse["message"]["content"];
      } else {
        throw Exception(
            "Failed to fetch response from Ollama API. Status code: ${response.statusCode}, body: ${response.data}");
      }
    } on DioException catch (e) {
      throw Exception("Error requesting Ollama API: $e\nBody: ${e.response}");
    }
  }

  /// Ollama in this implementation does not stream; produce a single-chunk stream
  /// containing the full response. If Ollama streaming is available, replace this
  /// with streaming logic that yields incremental tokens.
  @override
  Stream<String> generateStream(String prompt, {Iterable<Attachment> attachments = const []}) async* {
    final resp = await request(prompt);
    yield resp;
  }

  /// Send a message and return a stream that yields the full response once.
  /// This also gives a place to update internal history and notify listeners.
  @override
  Stream<String> sendMessageStream(String prompt, {Iterable<Attachment> attachments = const []}) async* {
    // If you know how to construct ChatMessage, you can push the user's message into _history here.
    // Example (pseudo):
    // _history.add(ChatMessage(...user message...));
    // notifyListeners();

    _history.add(ChatMessage(text: prompt, attachments: [], origin: MessageOrigin.user));
    notifyListeners();

    final resp = await request(prompt);

    // If you know ChatMessage constructors, add assistant message to history here:
    // _history.add(ChatMessage(...assistant message...));
    // notifyListeners();
    _history.add(ChatMessage(text: resp, attachments: [], origin: MessageOrigin.llm));
    notifyListeners();

    yield resp;
  }
  
  @override
  set history(Iterable<ChatMessage> history) {
    _history.clear();
    _history.addAll(history);
    notifyListeners();
  }
}