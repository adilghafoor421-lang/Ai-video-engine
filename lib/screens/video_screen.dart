import 'package:flutter/material.dart';
import 'dart:io';
import '../models/script_model.dart';
import '../widgets/gradient_button.dart';

class VideoScreen extends StatefulWidget {
  final ScriptModel script;
  final File faceImage;
  const VideoScreen({super.key, required this.script, required this.faceImage});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  bool _isProcessing = false;
  String _currentStep = '';
  double _progress = 0.0;
  bool _isDone = false;

  final List<String> _steps = [
    '🎙️ Audio generate ho raha hai...',
    '😊 Face animation ho rahi hai...',
    '🎬 Scenes join ho rahe hain...',
    '✨ Final render ho raha hai...',
    '✅ Video ready hai!',
  ];

  Future<void> _startProcessing() async {
    setState(() => _isProcessing = true);

    for (int i = 0; i < _steps.length; i++) {
      setState(() {
        _currentStep = _steps[i];
        _progress = (i + 1) / _steps.length;
      });
      await Future.delayed(const Duration(seconds: 2));
    }

    setState(() {
      _isDone = true;
      _isProcessing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🎬 Video Processing'),
        backgroundColor: const Color(0xFF0A0A0F),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF13131A),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      widget.faceImage,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.script.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${widget.script.scenes.length} scenes • ${widget.script.totalDurationSeconds}s',
                          style: const TextStyle(
                              color: Colors.white38, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            if (_isProcessing || _isDone)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF13131A),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Text(
                      _currentStep,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    LinearProgressIndicator(
                      value: _progress,
                      backgroundColor: Colors.white12,
                      valueColor: const AlwaysStoppedAnimation(
                          Color(0xFF6C63FF)),
                      minHeight: 6,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${(_progress * 100).toInt()}%',
                      style: const TextStyle(
                        color: Color(0xFF6C63FF),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            const Spacer(),
            if (!_isProcessing && !_isDone)
              GradientButton(
                text: '🚀 Processing Shuru Karo',
                isLoading: false,
                onPressed: _startProcessing,
              ),
            if (_isDone) ...[
              GradientButton(
                text: '⬇️ Video Download Karo',
                isLoading: false,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('✅ Video Downloads mein save ho gayi!'),
                      backgroundColor: Color(0xFF6C63FF),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () =>
                    Navigator.popUntil(context, (route) => route.isFirst),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.white24),
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text('🎬 Nayi Video Banao',
                    style: TextStyle(color: Colors.white54)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
