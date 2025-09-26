import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class AuthorOutput {
  final int page;
  final List<String> lines;
  final List<String> rhymeLabels;
  final List<String> endWords;
  final List<int> syllables;
  final List<String> continuityRefs;
  final bool passesChecks;

  AuthorOutput({
    required this.page,
    required this.lines,
    required this.rhymeLabels,
    required this.endWords,
    required this.syllables,
    required this.continuityRefs,
    required this.passesChecks,
  });

  factory AuthorOutput.fromJson(Map<String, dynamic> json) {
    return AuthorOutput(
      page: json['page'] ?? 1,
      lines: List<String>.from(json['lines'] ?? []),
      rhymeLabels: List<String>.from(json['rhyme_labels'] ?? []),
      endWords: List<String>.from(json['end_words'] ?? []),
      syllables: List<int>.from(json['syllables'] ?? []),
      continuityRefs: List<String>.from(json['continuity_refs'] ?? []),
      passesChecks: json['passes_checks'] ?? false,
    );
  }
}

class ImageOutput {
  final int page;
  final String imageB64;

  ImageOutput({
    required this.page,
    required this.imageB64,
  });

  factory ImageOutput.fromJson(Map<String, dynamic> json) {
    return ImageOutput(
      page: json['page'] ?? 1,
      imageB64: json['image_b64'] ?? '',
    );
  }
}

class AiClient {
  final String baseUrl;
  final http.Client _client = http.Client();

  AiClient({required this.baseUrl});

  Future<AuthorOutput> generatePageText({
    required int page,
    required String idea,
    required String category,
    required Map<String, dynamic> storyBible,
  }) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/story'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'page': page,
          'idea': idea,
          'category': category,
          'story_bible': storyBible,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return AuthorOutput.fromJson(data);
      } else {
        throw Exception('Failed to generate text: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error generating page text: $e');
    }
  }

  Future<Uint8List> generatePageImage({
    required int page,
    required String scene,
    required List<Map<String, dynamic>> characters,
    required String userStyle,
    required Map<String, dynamic> artBible,
  }) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/image'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'page': page,
          'scene': scene,
          'characters': characters,
          'userStyle': userStyle,
          'art_bible': artBible,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final imageOutput = ImageOutput.fromJson(data);
        
        // Decode base64 to bytes
        return base64Decode(imageOutput.imageB64);
      } else {
        throw Exception('Failed to generate image: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error generating page image: $e');
    }
  }

  Future<bool> moderateContent(String text) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/moderate'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'text': text}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['is_safe'] ?? false;
      } else {
        return false; // Assume unsafe if moderation fails
      }
    } catch (e) {
      print('Moderation error: $e');
      return false; // Assume unsafe if error
    }
  }

  void dispose() {
    _client.close();
  }
}

// Mock client for testing without a backend
class MockAiClient extends AiClient {
  MockAiClient() : super(baseUrl: 'mock');

  @override
  Future<AuthorOutput> generatePageText({
    required int page,
    required String idea,
    required String category,
    required Map<String, dynamic> storyBible,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Generate mock content based on the idea
    final mockLines = _generateMockLines(idea, page);
    
    return AuthorOutput(
      page: page,
      lines: mockLines,
      rhymeLabels: ['A', 'A', 'B', 'B'],
      endWords: ['day', 'way', 'bright', 'light'],
      syllables: [8, 8, 8, 8],
      continuityRefs: [idea, category],
      passesChecks: true,
    );
  }

  @override
  Future<Uint8List> generatePageImage({
    required int page,
    required String scene,
    required List<Map<String, dynamic>> characters,
    required String userStyle,
    required Map<String, dynamic> artBible,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 3));

    // Return a 1x1 transparent PNG as mock image
    const mockImageB64 = 'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg==';
    return base64Decode(mockImageB64);
  }

  @override
  Future<bool> moderateContent(String text) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return true; // Always safe for testing
  }

  List<String> _generateMockLines(String idea, int page) {
    final templates = [
      [
        "Once upon a time in a magical place",
        "A wonderful story begins with grace",
        "Adventure awaits around every turn",
        "So many lessons for us to learn"
      ],
      [
        "Our hero discovers something new",
        "With courage and heart they'll see it through", 
        "The journey ahead is full of surprise",
        "With friendship and hope that never dies"
      ],
      [
        "Through forests deep and mountains high",
        "Our brave friend reaches for the sky",
        "With every step the path grows bright",
        "Guiding them toward the morning light"
      ],
      [
        "Now wisdom gained and lessons learned",
        "A grateful heart and spirit earned",
        "The adventure ends but memories stay",
        "To light the path for another day"
      ],
    ];

    final index = (page - 1) % templates.length;
    return templates[index];
  }
}
