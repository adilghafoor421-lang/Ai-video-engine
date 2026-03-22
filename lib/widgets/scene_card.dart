import 'package:flutter/material.dart';
import '../models/script_model.dart';

class SceneCard extends StatelessWidget {
  final SceneModel scene;
  final int index;

  const SceneCard({super.key, required this.scene, required this.index});

  Color _getTypeColor() {
    switch (scene.sceneType) {
      case 'hook': return const Color(0xFFFF6584);
      case 'problem': return const Color(0xFFFFB347);
      case 'cta': return const Color(0xFF4CAF50);
      default: return const Color(0xFF6C63FF);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF13131A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _getTypeColor().withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _getTypeColor().withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Scene ${scene.sceneNumber} • ${scene.sceneType.toUpperCase()}',
                  style: TextStyle(
                    color: _getTypeColor(),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                '${scene.durationSeconds}s',
                style: const TextStyle(color: Colors.white38, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            scene.script,
            style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.5),
          ),
          const SizedBox(height: 8),
          Text(
            '😶 ${scene.faceExpression}',
            style: const TextStyle(color: Colors.white38, fontSize: 11),
          ),
          const SizedBox(height: 4),
          Text(
            '📸 ${scene.visualDescription}',
            style: const TextStyle(color: Colors.white38, fontSize: 11),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              '📝 ${scene.subtitleText}',
              style: const TextStyle(color: Colors.white54, fontSize: 11),
            ),
          ),
        ],
      ),
    );
