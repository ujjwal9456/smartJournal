import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';

abstract class AiProviders {
  Future<String> request(String prompt);
}

class OllamaChatProvider extends ChangeNotifier implements LlmProvider {
  final String model;
  final String apiUrl; 

  OllamaChatProvider({required this.model, required this.apiUrl});

  final List<ChatMessage> _history = <ChatMessage>[];

  @override
  Iterable<ChatMessage> get history => List.unmodifiable(_history);

  @override
  Stream<String> generateStream(
    String prompt, {
    Iterable<Attachment> attachments = const [],
  }) async* {
    final data = {
      "messages": [
        ..._history.map((m) => {
              "role": m.origin == MessageOrigin.user ? "user" : "assistant",
              "content": m.text,
            }),
        {"role": "user", "content": prompt}
      ]
    };

    try {
      print('Starting API call to: $apiUrl');
      print('Request data: $data');
      
      // Using Dio for a streaming response from Python backend
      final response = await Dio().post(
        apiUrl,
        data: data,
        options: Options(
          responseType: ResponseType.stream,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'text/event-stream',
          },
        ),
      );
      
      print('Response received: ${response.statusCode}');

      try {
        final stream = response.data!.stream;
        
        await for (final chunk in stream) {
          final decoded = utf8.decode(chunk);
          final lines = decoded.split('\n');
          
          for (final line in lines) {
            if (line.isNotEmpty) {
              print('Processing line: "$line"');
              // Handle SSE format - remove "data: " prefix
              String cleanLine = line;
              if (line.startsWith('data: ')) {
                cleanLine = line.substring(6);
              }
              
              // Skip [DONE] messages
              if (cleanLine == '[DONE]') {
                print('Received [DONE] signal');
                continue;
              }
              
              if (cleanLine.isNotEmpty) {
                try {
                  final jsonData = jsonDecode(cleanLine);
                  if (jsonData is Map && jsonData.containsKey('text')) {
                    final content = jsonData['text'] as String;
                    print('Yielding content: "$content"');
                    yield content;
                  }
                } catch (e) {
                  print('JSON decode error: $e');
                  print('Failed to parse: "$cleanLine"');
                }
              }
            }
          }
        }
      } catch (streamError) {
        print('Stream processing error: $streamError');
        print('Stream error type: ${streamError.runtimeType}');
        rethrow;
      }
    } catch (e) {
      throw Exception("Error connecting to Python Backend: $e");
    }
  }

  @override
  Stream<String> sendMessageStream(
    String prompt, {
    Iterable<Attachment> attachments = const [],
  }) async* {
    // 1. Add User Message to UI
    _history.add(ChatMessage(text: prompt, origin: MessageOrigin.user, attachments: []));
    notifyListeners();

    

    // 2. Stream the response from Python
    String completeResponse = "";
    await for (final token in generateStream(prompt, attachments: attachments)) {
      completeResponse += token;
      yield token;
    }

    // 3. Add AI Response to UI History
    _history.add(ChatMessage(text: completeResponse, origin: MessageOrigin.llm, attachments: []));
    notifyListeners();
  }

  @override
  set history(Iterable<ChatMessage> history) {
    _history.clear();
    _history.addAll(history);
    notifyListeners();
  }
}