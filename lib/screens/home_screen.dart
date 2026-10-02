import 'package:flutter/material.dart';
import '../services/tts_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TTSService _ttsService = TTSService();
  final TextEditingController _textController = TextEditingController();
  
  String _selectedVoice = "Voice 01 - Natural Male";
  double _speed = 1.0;
  String _status = "Ready";
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _ttsService.init();
  }

  void _generateVoice() async {
    if (_textController.text.trim().isEmpty) {
      _showError("စာသားမထည့်ရသေးပါဘူး။ Script ကို Paste လုပ်ပေးပါ။");
      return;
    }

    setState(() {
      _isProcessing = true;
      _status = "Analyzing Text...";
    });

    await Future.delayed(const Duration(milliseconds: 500));
    setState(() => _status = "Generating Audio...");

    try {
      await _ttsService.speak(_textController.text, _selectedVoice, _speed);
      setState(() => _status = "Completed");
    } catch (e) {
      _showError("အသံဖန်တီးရာမှာ အခက်အခဲတစ်ခု ဖြစ်သွားပါတယ်။ ခဏစောင့်ပြီး ပြန်ကြိုးစားပေးပါ။");
      setState(() => _status = "Error");
    }

    setState(() => _isProcessing = false);
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: const Color(0xFF990000)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final charCount = _textController.text.length;
    final wordCount = _textController.text.trim().isEmpty ? 0 : _textController.text.trim().split(RegExp(r'\s+')).length;
    final estDuration = (wordCount / 2.5).toStringAsFixed(1);

    return Scaffold(
      appBar: AppBar(
        title: const Text("N - Gen Voice Studio", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF990000))),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Text Input Card
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Script Input", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _textController,
                    maxLines: 10,
                    decoration: InputDecoration(
                      hintText: "Paste your Burmese script here…",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Chars: $charCount | Words: $wordCount", style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                      Text("Est. Duration: ${estDuration}m", style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Controls Card
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Voice & Controls", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _selectedVoice,
                    decoration: InputDecoration(
                      labelText: "Voice Model (15 Profiles)",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    items: _ttsService.voiceProfiles.keys.map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
                    onChanged: (val) => setState(() => _selectedVoice = val!),
                  ),
                  const SizedBox(height: 16),
                  Text("Speed: ${_speed.toStringAsFixed(2)}x", style: const TextStyle(fontWeight: FontWeight.w500)),
                  Slider(value: _speed, min: 0.75, max: 1.3, activeColor: const Color(0xFF990000), onChanged: (v) => setState(() => _speed = v)),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Action Button
            ElevatedButton.icon(
              onPressed: _isProcessing ? null : _generateVoice,
              icon: const Icon(Icons.play_arrow),
              label: Text(_isProcessing ? "Processing..." : "Generate Voice"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF990000),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 12),
            Text(_status, textAlign: TextAlign.center, style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: child,
    );
  }
}
