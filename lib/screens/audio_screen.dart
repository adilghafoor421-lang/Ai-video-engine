import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/script_model.dart';
import '../widgets/gradient_button.dart';
import 'face_upload_screen.dart';

class AudioScreen extends StatefulWidget {
  final ScriptModel script;
  const AudioScreen({super.key, required this.script});

  @override
  State<AudioScreen> createState() => _AudioScreenState();
}

class _AudioScreenState extends State<AudioScreen> {
  final FlutterTts _tts = FlutterTts();
  int _currentPlayingScene = -1;
  bool _allAudioReady = false;
  late List<bool> _sceneAudioReady;

  @override
  void initState() {
    super.initState();
    _sceneAudioReady = List.filled(widget.script.scenes.length, false);
    _initTts();
  }

  Future<void> _initTts() async {
    await _tts.setLanguage('hi-IN');
    await _tts.setSpeechRate(0.85);
    await _tts.setPitch(1.0);
    await _tts.setVolume(1.0);
    _tts.setCompletionHandler(() {
      setState(() => _currentPlayingScene = -1);
    });
  }

  Future<void> _playScene(int index) async {
    if (_currentPlayingScene == index) {
      await _tts.stop();
      setState(() => _currentPlayingScene = -1);
      return;
    }
    setState(() => _currentPlayingScene = index);
    await _tts.speak(widget.script.scenes[index].script);
  }

  Future<void> _markAllReady() async {
    setState(() {
      _sceneAudioReady = List.filled(widget.script.scenes.length, true);
      _allAudioReady = true;
    });
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🎙️ Audio Preview'),
        backgroundColor: const Color(0xFF0A0A0F),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: widget.script.scenes.length,
              itemBuilder: (context, index) {
                final scene = widget.script.scenes[index];
                final isPlaying = _currentPlayingScene == index;

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF13131A),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isPlaying
                          ? const Color(0xFF6C63FF)
                          : Colors.white12,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF6C63FF).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Scene ${scene.sceneNumber}',
                              style: const TextStyle(
                                color: Color(0xFF6C63FF),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () => _playScene(index),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: isPlaying
                                    ? const Color(0xFFFF6584)
                                    : const Color(0xFF6C63FF),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                isPlaying ? Icons.stop : Icons.play_arrow,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        scene.script,
                        style: TextStyle(
                          color: isPlaying ? Colors.white : Colors.white70,
                          fontSize: 13,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '😶 ${scene.faceExpression}',
                        style: const TextStyle(
                            color: Colors.white38, fontSize: 11),
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: (index * 80).ms);
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Color(0xFF13131A),
              border: Border(top: BorderSide(color: Colors.white12)),
            ),
            child: Column(
              children: [
                if (!_allAudioReady)
                  OutlinedButton(
                    onPressed: _markAllReady,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF6C63FF)),
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('✅ Audio Review Ho Gaya',
                        style: TextStyle(color: Color(0xFF6C63FF))),
                  ),
                if (_allAudioReady) ...[
                  const SizedBox(height: 8),
                  GradientButton(
                    text: '📸 Face Upload — Next Step',
                    isLoading: false,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              FaceUploadScreen(script: widget.script),
                        ),
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
