class SceneModel {
  final int sceneNumber;
  final String sceneType;
  final int durationSeconds;
  final String script;
  final String visualDescription;
  final String faceExpression;
  final String emotion;
  final String subtitleText;

  SceneModel({
    required this.sceneNumber,
    required this.sceneType,
    required this.durationSeconds,
    required this.script,
    required this.visualDescription,
    required this.faceExpression,
    required this.emotion,
    required this.subtitleText,
  });

  factory SceneModel.fromJson(Map<String, dynamic> json) => SceneModel(
        sceneNumber: json['scene_number'] ?? 0,
        sceneType: json['scene_type'] ?? '',
        durationSeconds: json['duration_seconds'] ?? 20,
        script: json['script'] ?? '',
        visualDescription: json['visual_description'] ?? '',
        faceExpression: json['face_expression'] ?? '',
        emotion: json['emotion'] ?? '',
        subtitleText: json['subtitle_text'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'scene_number': sceneNumber,
        'scene_type': sceneType,
        'duration_seconds': durationSeconds,
        'script': script,
        'visual_description': visualDescription,
        'face_expression': faceExpression,
        'emotion': emotion,
        'subtitle_text': subtitleText,
      };
}

class ScriptModel {
  final String id;
  final String title;
  final String hookLine;
  final String targetAudience;
  final int totalDurationSeconds;
  final List<SceneModel> scenes;
  final String thumbnailIdea;
  final List<String> tags;
  final String descriptionHook;
  final DateTime createdAt;

  ScriptModel({
    required this.id,
    required this.title,
    required this.hookLine,
    required this.targetAudience,
    required this.totalDurationSeconds,
    required this.scenes,
    required this.thumbnailIdea,
    required this.tags,
    required this.descriptionHook,
    required this.createdAt,
  });

  factory ScriptModel.fromJson(Map<String, dynamic> json) => ScriptModel(
        id: json['id'] ?? '',
        title: json['title'] ?? '',
        hookLine: json['hook_line'] ?? '',
        targetAudience: json['target_audience'] ?? '',
        totalDurationSeconds: json['total_duration_seconds'] ?? 0,
        scenes: (json['scenes'] as List? ?? [])
            .map((s) => SceneModel.fromJson(s))
            .toList(),
        thumbnailIdea: json['thumbnail_idea'] ?? '',
        tags: List<String>.from(json['tags'] ?? []),
        descriptionHook: json['description_hook'] ?? '',
        createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'hook_line': hookLine,
        'target_audience': targetAudience,
        'total_duration_seconds': totalDurationSeconds,
        'scenes': scenes.map((s) => s.toJson()).toList(),
        'thumbnail_idea': thumbnailIdea,
        'tags': tags,
        'description_hook': descriptionHook,
        'created_at': createdAt.toIso8601String(),
      };
}
