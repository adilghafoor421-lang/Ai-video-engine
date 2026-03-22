import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import '../models/script_model.dart';

class AnthropicService {
  static const String _baseUrl = 'https://api.anthropic.com/v1/messages';

  Future<ScriptModel> generateScript({
    required String prompt,
    required String apiKey,
    required int numScenes,
  }) async {
    const systemPrompt = """
You are a WORLD-CLASS YouTube video director and scriptwriter.

YOUR JOB:
- Take the user's topic and create a CINEMATIC scene-by-scene script
- Language: Natural Hinglish (Hindi + English mix)
- Tone: Confident, engaging, like a top creator
- Hook must be EXTREMELY strong

SCENE STRUCTURE:
1. Scene 1 = HOOK — MAX 15 seconds
2. Scene 2 = PROBLEM — 20 seconds
3. Middle Scenes = VALUE content — 20-25 seconds each
4. Last Scene = CTA — 15 seconds

OUTPUT: strict JSON only, no extra text:
{
  "title": "Catchy YouTube title with emoji",
  "hook_line": "First line jo viewer ko rok de",
  "target_audience": "Exact audience description",
  "total_duration_seconds": 120,
  "scenes": [
    {
      "scene_number": 1,
      "scene_type": "hook",
      "duration_seconds": 15,
      "script": "Exact words in natural Hinglish",
      "visual_description": "Camera angle and background",
      "face_expression": "Exact expression description",
      "emotion": "excited",
      "subtitle_text": "Short on-screen text"
    }
  ],
  "thumbnail_idea": "Thumbnail description",
  "tags": ["tag1", "tag2", "tag3"],
  "description_hook": "First 2 lines of YouTube description"
}
""";

    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': apiKey,
        'anthropic-version': '2023-06-01',
      },
      body: jsonEncode({
        'model': 'claude-opus-4-6',
        'max_tokens': 4000,
        'system': systemPrompt,
        'messages': [
          {
            'role': 'user',
            'content': 'Topic: $prompt\nScenes: $numScenes\nMake it VIRAL.',
          }
        ],
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('API Error: ${response.statusCode}');
    }

    final data = jsonDecode(response.body);
    final text = data['content'][0]['text'] as String;

    final start = text.indexOf('{');
    final end = text.lastIndexOf('}') + 1;
    final jsonStr = text.substring(start, end);
    final scriptJson = jsonDecode(jsonStr) as Map<String, dynamic>;

    scriptJson['id'] = const Uuid().v4();
    scriptJson['created_at'] = DateTime.now().toIso8601String();

    return ScriptModel.fromJson(scriptJson);
  }
}
