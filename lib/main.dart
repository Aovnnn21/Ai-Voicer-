import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(const NGenVoiceStudio());

class NGenVoiceStudio extends StatelessWidget {
  const NGenVoiceStudio({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'N - Gen Voice Studio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF990000), // Deep Red
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        textTheme: GoogleFonts.interTextTheme(),
      ),
      home: const StudioScreen(),
    );
  }
}

class StudioScreen extends StatefulWidget {
  const StudioScreen({super.key});
  @override
  State<StudioScreen> createState() => _StudioScreenState();
}

class _StudioScreenState extends State<StudioScreen> {
  final FlutterTts _tts = FlutterTts();
  final TextEditingController _textController = TextEditingController();
  
  String _selectedVoice = "Voice 01 - Natural Male";
  double _speed = 1.0;
  double _pitch = 1.0;
  bool _isPlaying = false;
  String _status = "Ready";

  final List<String> _voices = [
    "Voice 01 - Natural Male", "Voice 02 - Natural Female", "Voice 03 - Deep Male",
    "Voice 04 - Soft Female", "Voice 05 - Energetic Male", "Voice 06 - Energetic Female",
    "Voice 07 - Documentary Male", "Voice 08 - Storyteller Male", "Voice 09 - Storyteller Female",
    "Voice 10 - Calm Narrator", "Voice 11 - Professional Presenter", "Voice 12 - Movie Recap",
    "Voice 13 - Mystery", "Voice 14 - Friendly Creator", "Voice 15 - Premium Narrator"
  ];

  @override
  void initState() {
    super.initState();
    _initTts();
    _textController.addListener(_updateCounts);
  }

  void _initTts() {
    _tts.setLanguage("my-MM"); // Burmese
    _tts.setSpeechRate(_speed);
    _tts.setPitch(_pitch);
  }

  void _updateCounts() => setState(() {});

  void _applyVoiceProfile() {
    // Simulate voice profiles by adjusting pitch/speed based on selection
    int index = _voices.indexOf(_selectedVoice);
    if (index == 2 || index == 6 || index == 14) { // Deep/Doc/Premium
      _tts.setPitch(0.8); 
    } else if (index == 3 || index == 8) { // Soft/Storyteller Female
      _tts.setPitch(1.2); 
    } else {
      _tts.setPitch(_pitch);
    }
    _tts.setSpeechRate(_speed);
  }

  Future<void> _generateAndPlay() async {
    if (_textController.text.isEmpty) {
      _showSnackbar("စာသားမထည့်ရသေးပါဘူး။ (Please enter text)");
      return;
    }
    
    setState(() { _status = "Generating Audio..."; _isPlaying = true; });
    _applyVoiceProfile();
    
    await _tts.speak(_textController.text);
    setState(() { _status = "Completed"; _isPlaying = false; });
  }

  void _showSnackbar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: const Color(0xFF990000))
    );
  }

  @override
  Widget build(BuildContext context) {
    final charCount = _textController.text.length;
    final wordCount = _textController.text.trim().isEmpty ? 0 : _textController.text.trim().split(RegExp(r'\s+')).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text("N - Gen Voice Studio", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF990000),
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
                    maxLines: 8,
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
                      Text("Est. Duration: ${(wordCount / 2.5).toStringAsFixed(1)}m", style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
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
                      labelText: "Voice Model",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    items: _voices.map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
                    onChanged: (val) => setState(() => _selectedVoice = val!),
                  ),
                  const SizedBox(height: 16),
                  _buildSlider("Speed", _speed, 0.5, 1.5, (v) => setState(() => _speed = v)),
                  _buildSlider("Pitch", _pitch, 0.5, 1.5, (v) => setState(() => _pitch = v)),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Action Buttons
            ElevatedButton.icon(
              onPressed: _isPlaying ? null : _generateAndPlay,
              icon: const Icon(Icons.play_arrow),
              label: Text(_isPlaying ? "Processing..." : "Generate Voice"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF990000),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 12),
            Text(_status, textAlign: TextAlign.center, style: TextStyle(color: Colors.grey.shade600)),
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
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: child,
    );
  }

  Widget _buildSlider(String label, double value, double min, double max, ValueChanged<double> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("$label: ${value.toStringAsFixed(2)}x", style: const TextStyle(fontWeight: FontWeight.w500)),
        Slider(value: value, min: min, max: max, activeColor: const Color(0xFF990000), onChanged: onChanged),
      ],
    );
  }
}
