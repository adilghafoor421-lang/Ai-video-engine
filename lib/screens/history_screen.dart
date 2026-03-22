import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../models/script_model.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final StorageService _storageService = StorageService();
  List<ScriptModel> _scripts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final scripts = await _storageService.getAllScripts();
    setState(() {
      _scripts = scripts;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📚 History'),
        backgroundColor: const Color(0xFF0A0A0F),
        actions: [
          if (_scripts.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.white38),
              onPressed: () async {
                await _storageService.clearAll();
                _loadHistory();
              },
            ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF6C63FF)))
          : _scripts.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('🎬', style: TextStyle(fontSize: 48)),
                      SizedBox(height: 12),
                      Text(
                        'Koi script nahi hai abhi\nPehli video banao!',
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(color: Colors.white38, fontSize: 14),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _scripts.length,
                  itemBuilder: (context, index) {
                    final script = _scripts[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF13131A),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            script.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '🎬 ${script.scenes.length} scenes  •  ⏱️ ${script.totalDurationSeconds}s',
                            style: const TextStyle(
                                color: Colors.white38, fontSize: 12),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            script.hookLine,
                            style: const TextStyle(
                                color: Colors.white54, fontSize: 12),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
