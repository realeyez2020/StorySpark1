import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class AiClient {
  final String baseUrl; // e.g., http://localhost:3001/api
  AiClient(this.baseUrl);

  Future<Map<String, dynamic>> initBook({
    required String pitch,
    required String styleLabel,
    required String genreLabel,
    String ageBand = 'kids',
    bool allowAiNames = true,
    bool forceRhyme = false,
  }) async {
    final r = await http.post(Uri.parse('$baseUrl/book/init'),
      headers: {'content-type': 'application/json'},
      body: jsonEncode({
        'pitch': pitch,
        'styleLabel': styleLabel,
        'genreLabel': genreLabel,
        'ageBand': ageBand,
        'allowAiNames': allowAiNames,
        'forceRhyme': forceRhyme,
      }),
    );
    if (r.statusCode >= 300) throw Exception('initBook error: ${r.body}');
    return jsonDecode(r.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> writePage({
    required String bookId,
    required int page,
    required String idea,
    bool? forceRhyme,
  }) async {
    final r = await http.post(Uri.parse('$baseUrl/story'),
      headers: {'content-type': 'application/json'},
      body: jsonEncode({
        'book_id': bookId,
        'page': page,
        'idea': idea,
        if (forceRhyme != null) 'forceRhyme': forceRhyme,
      }),
    );
    if (r.statusCode >= 300) throw Exception('writePage error: ${r.body}');
    return jsonDecode(r.body) as Map<String, dynamic>;
  }

  Future<Uint8List> renderPage({
    required String bookId,
    required int page,
    required List<String> lines,
    required String styleLabel,
    required String genreLabel,
    List<Map<String, dynamic>> characters = const [],
  }) async {
    final r = await http.post(Uri.parse('$baseUrl/image'),
      headers: {'content-type': 'application/json'},
      body: jsonEncode({
        'book_id': bookId,
        'page': page,
        'lines': lines,
        'styleLabel': styleLabel,
        'genreLabel': genreLabel,
        'characters': characters,
      }),
    );
    if (r.statusCode >= 300) throw Exception('renderPage error: ${r.body}');
    final j = jsonDecode(r.body) as Map<String, dynamic>;
    final b64 = j['image_b64'] as String;
    return base64Decode(b64);
  }

  // Legacy compatibility methods
  Future<AuthorOutput> generatePageText({
    required int page,
    required String idea,
    required String category,
    required Map<String, dynamic> storyBible,
  }) async {
    // This is a legacy wrapper - new system should use book sessions
    final result = await writePage(
      bookId: 'legacy',
      page: page,
      idea: idea,
    );
    
    return AuthorOutput(
      page: result['page'] ?? page,
      lines: List<String>.from(result['lines'] ?? []),
      sceneHint: result['scene_hint'],
      rhymeLabels: List<String>.from(result['rhyme_labels'] ?? []),
      endWords: List<String>.from(result['end_words'] ?? []),
      syllables: List<int>.from(result['syllables'] ?? []),
      continuityRefs: [],
      passesChecks: result['passes_checks'] ?? false,
    );
  }

  Future<Uint8List> generatePageImage({
    required int page,
    required String scene,
    required List<Map<String, dynamic>> characters,
    required String userStyle,
    required String genreLabel,
    required Map<String, dynamic> artBible,
  }) async {
    // Legacy wrapper
    return renderPage(
      bookId: 'legacy',
      page: page,
      lines: [scene],
      styleLabel: userStyle,
      genreLabel: genreLabel,
      characters: characters,
    );
  }
}

// Keep existing models for compatibility
class AuthorOutput {
  final int page;
  final List<String> lines;
  final String? sceneHint;
  final List<String> rhymeLabels;
  final List<String> endWords;
  final List<int> syllables;
  final List<String> continuityRefs;
  final bool passesChecks;

  AuthorOutput({
    required this.page,
    required this.lines,
    this.sceneHint,
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
      sceneHint: json['scene_hint'],
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

  ImageOutput({required this.page, required this.imageB64});

  factory ImageOutput.fromJson(Map<String, dynamic> json) {
    return ImageOutput(
      page: json['page'] ?? 1,
      imageB64: json['image_b64'] ?? '',
    );
  }
}
