import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../models/script_model.dart';
import '../widgets/gradient_button.dart';
import 'video_screen.dart';

class FaceUploadScreen extends StatefulWidget {
  final ScriptModel script;
  const FaceUploadScreen({super.key, required this.script});

  @override
  State<FaceUploadScreen> createState() => _FaceUploadScreenState();
}

class _FaceUploadScreenState extends State<FaceUploadScreen> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(
      source: source,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 90,
    );
    if (image != null) {
      setState(() => _selectedImage = File(image.path));
    }
  }

  void _showPickerDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF13131A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library,
                  color: Color(0xFF6C63FF)),
              title: const Text('Gallery se',
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt,
                  color: Color(0xFFFF6584)),
              title: const Text('Camera se',
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📸 Face Upload'),
        backgroundColor: const Color(0xFF0A0A0F),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF6C63FF).withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFF6C63FF).withOpacity(0.3),
                ),
              ),
              child: const Column(
                children: [
                  Text('📌 Best Results Ke Liye:',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14)),
                  SizedBox(height: 8),
                  Text(
                    '• Clear front-facing photo\n'
                    '• Achhi lighting ho\n'
                    '• Face clear aur sharp ho\n'
                    '• Background simple ho',
                    style: TextStyle(
                        color: Colors.white60,
                        fontSize: 13,
                        height: 1.6),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: _showPickerDialog,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: const Color(0xFF13131A),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _selectedImage != null
                        ? const Color(0xFF6C63FF)
                        : Colors.white12,
                    width: 2,
                  ),
                ),
                child: _selectedImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Image.file(_selectedImage!,
                            fit: BoxFit.cover),
                      )
                    : const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_a_photo_outlined,
                              color: Colors.white38, size: 48),
                          SizedBox(height: 8),
                          Text('Photo Upload Karo',
                              style: TextStyle(
                                  color: Colors.white38, fontSize: 13)),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _pickImage(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library_outlined),
                    label: const Text('Gallery'),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF6C63FF)),
                      foregroundColor: const Color(0xFF6C63FF),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _pickImage(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt_outlined),
                    label: const Text('Camera'),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFFF6584)),
                      foregroundColor: const Color(0xFFFF6584),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            if (_selectedImage != null)
              GradientButton(
                text: '🎬 Video Processing — Next Step',
                isLoading: false,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => VideoScreen(
                        script: widget.script,
                        faceImage: _selectedImage!,
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
