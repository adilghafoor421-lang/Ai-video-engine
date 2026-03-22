import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../services/anthropic_service.dart';
import '../services/storage_service.dart';
import '../models/script_model.dart';
import '../widgets/scene_card.dart';
import '../widgets/gradient_button.dart';
import 'audio_screen.dart';

class ScriptScreen extends StatefulWidget {
  const ScriptScreen({super.key});

  @override
  State<ScriptScreen> createState() => _ScriptScreenState();
}

class _ScriptScreenState extends State<ScriptScreen> {
  final TextEditingController _promptController = TextEditingController();
  final TextEditingController _apiKeyController = TextEditingController();
  final AnthropicService _anthropicService = AnthropicService();
  final StorageService _storageService = StorageService();

  ScriptModel? _generatedScript;
  bool _isLoading = false;
  int _numScenes = 6;
  bool _apiKeyVisible = false;

  @override
  void initState() {
    super.initState();
    _loadApiKey();
  }

  Future<void> _loadApiKey() async {
    final key = await _storageService.getApiKey();
    if (key != null) {
      _apiKeyController.text = key;
    }
  }

  Future<void> _generateScript() async {
    if (_promptController.text.trim().isEmpty) {
      _showSnack('Prompt likhna zaroori hai! ✍️');
      return;
    }
    if (_apiKeyController.text.trim().isEmpty) {
      _showSnack('API Key daalni zaroori hai! 🔑');
      return;
    }

    await _storageService.saveApiKey(_apiKeyController.text.trim());
    setState(() => _isLoading = true);

    try {
      final script = await _anthropicService.generateScript(
        prompt: _promptController.text.trim(),
        apiKey: _apiKeyController.text.trim(),
        numScenes: _numScenes,
      );
      await _storageService.saveScript(script);
      setState(() {
        _generatedScript = script;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showSnack('Error: ${e.toString()}');
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: const Color(0xFF6C63FF),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            pinned: true,
            backgroundColor: const Color(0xFF0A0A0F),
            flexibleSpace: FlexibleSpaceBar(
              title: ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Color(0xFF6C63FF), Color(0xFFFF6584)],
                ).createShader(bounds),
                child: const Text(
                  '🎬 AI Video Engine',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              centerTitle: true,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('🔑 Anthropic API Key'),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _apiKeyController,
                    obscureText: !_apiKeyVisible,
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                    decoration: InputDecoration(
                      hintText: 'sk-ant-api...',
                      hintStyle: const TextStyle(color: Colors.white24),
                      filled: true,
                      fillColor: const Color(0xFF13131A),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.white12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.white12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF6C63FF)),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _apiKeyVisible ? Icons.visibility_off : Icons.visibility,
                          color: Colors.white38,
                        ),
                        onPressed: () =>
                            setState(() => _apiKeyVisible = !_apiKeyVisible),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildLabel('✍️ Apna Topic Likho'),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _promptController,
                    maxLines: 4,
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                    decoration: InputDecoration(
                      hintText: 'e.g. AI se paise kamane ke 5 tarike...',
                      hintStyle: const TextStyle(color: Colors.white24),
                      filled: true,
                      fillColor: const Color(0xFF13131A),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Colors.white12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                            color: Color(0xFF6C63FF), width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildLabel('🎥 Scenes: $_numScenes'),
                  Slider(
                    value: _numScenes.toDouble(),
                    min: 3,
                    max: 10,
                    divisions: 7,
                    activeColor: const Color(0xFF6C63FF),
                    inactiveColor: Colors.white12,
                    onChanged: (val) =>
                        setState(() => _numScenes = val.toInt()),
                  ),
                  const SizedBox(height: 20),
                  GradientButton(
                    text: _isLoading ? 'Generating...' : '🚀 Script Generate Karo',
                    isLoading: _isLoading,
                    onPressed: _generateScript,
                  ),
                  const SizedBox(height: 30),
                  if (_generatedScript != null) _buildScriptResult(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white70,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildScriptResult() {
    final script = _generatedScript!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF6C63FF), Color(0xFFFF6584)],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(script.title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text('🎯 ${script.targetAudience}',
                  style: const TextStyle(color: Colors.white70, fontSize: 12)),
              Text(
                  '⏱️ ${script.totalDurationSeconds}s  •  🎬 ${script.scenes.length} scenes',
                  style: const TextStyle(color: Colors.white70, fontSize: 12)),
            ],
          ),
        ).animate().fadeIn().slideY(begin: 0.3),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF13131A),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: const Color(0xFFFF6584).withOpacity(0.5)),
          ),
          child: Row(
            children: [
              const Text('🪝 ', style: TextStyle(fontSize: 18)),
              Expanded(
                child: Text(script.hookLine,
                    style: const TextStyle(
                        color: Colors.white, fontSize: 13)),
              ),
            ],
          ),
        ).animate().fadeIn(delay: 200.ms),
        const SizedBox(height: 16),
        const Text('📜 Scenes',
            style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        ...script.scenes.asMap().entries.map((entry) {
          return SceneCard(scene: entry.value, index: entry.key)
              .animate()
              .fadeIn(delay: (entry.key * 100).ms)
              .slideX(begin: 0.2);
        }),
        const SizedBox(height: 20),
        GradientButton(
          text: '🎙️ Audio Banana — Next Step',
          isLoading: false,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AudioScreen(script: _generatedScript!),
              ),
            );
          },
        ),
      ],
    );
  }
}
