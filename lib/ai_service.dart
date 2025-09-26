import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AIService {
  static const String _openaiUrl = 'https://api.openai.com/v1/chat/completions';
  static const String _geminiUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent';

  static String? get _openaiApiKey => dotenv.env['OPENAI_API_KEY'];
  static String? get _geminiApiKey => dotenv.env['GEMINI_API_KEY'];

  static Future<String> generateStoryWithOpenAI({
    required String prompt,
    required int storyAILevel,
    required int imageAILevel,
  }) async {
    if (_openaiApiKey == null || _openaiApiKey!.isEmpty) {
      return 'Error: OpenAI API key not configured. Please add your API key to .env file.';
    }

    try {
      final storyPrompt = _buildStoryPrompt(prompt, storyAILevel);
      
      final response = await http.post(
        Uri.parse(_openaiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_openaiApiKey',
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo',
          'messages': [
            {
              'role': 'system',
              'content': 'You are a creative storyteller who writes engaging, kid-friendly stories. Keep stories appropriate for children ages 5-12.'
            },
            {
              'role': 'user',
              'content': storyPrompt,
            }
          ],
          'max_tokens': 500,
          'temperature': 0.8,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'].trim();
      } else {
        return 'Error generating story: ${response.statusCode} - ${response.body}';
      }
    } catch (e) {
      return 'Error connecting to AI service: $e';
    }
  }

  static Future<String> generateStoryWithGemini({
    required String prompt,
    required int storyAILevel,
    required int imageAILevel,
  }) async {
    if (_geminiApiKey == null || _geminiApiKey!.isEmpty) {
      return 'Error: Gemini API key not configured. Please add your API key to .env file.';
    }

    try {
      final storyPrompt = _buildStoryPrompt(prompt, storyAILevel);
      
      final response = await http.post(
        Uri.parse('$_geminiUrl?key=$_geminiApiKey'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'contents': [{
            'parts': [{
              'text': 'You are a creative storyteller who writes engaging, kid-friendly stories. Keep stories appropriate for children ages 5-12.\n\n$storyPrompt'
            }]
          }],
          'generationConfig': {
            'temperature': 0.8,
            'maxOutputTokens': 500,
          }
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['candidates'][0]['content']['parts'][0]['text'].trim();
      } else {
        return 'Error generating story: ${response.statusCode} - ${response.body}';
      }
    } catch (e) {
      return 'Error connecting to AI service: $e';
    }
  }

  static String _buildStoryPrompt(String userPrompt, int aiLevel) {
    String creativityLevel;
    
    if (aiLevel <= 25) {
      creativityLevel = "Write a simple, straightforward story based closely on this idea";
    } else if (aiLevel <= 50) {
      creativityLevel = "Write a creative story with some imaginative elements based on this idea";
    } else if (aiLevel <= 75) {
      creativityLevel = "Write a very creative and imaginative story inspired by this idea";
    } else {
      creativityLevel = "Write an extremely creative, magical, and fantastical story loosely inspired by this idea";
    }

    return '''$creativityLevel: "$userPrompt"

Please write a kid-friendly story that is:
- Appropriate for children ages 5-12
- Around 200-300 words long
- Engaging and fun to read
- Includes a clear beginning, middle, and end
- Has positive themes and characters

Story:''';
  }

  // Helper method to test if API keys are configured
  static bool get hasOpenAIKey => _openaiApiKey != null && _openaiApiKey!.isNotEmpty;
  static bool get hasGeminiKey => _geminiApiKey != null && _geminiApiKey!.isNotEmpty;
  static bool get hasAnyKey => hasOpenAIKey || hasGeminiKey;
}
