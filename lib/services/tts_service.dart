import 'package:flutter_tts/flutter_tts.dart';

class TTSService {
  final FlutterTts _tts = FlutterTts();
  bool _isPlaying = false;
  bool get isPlaying => _isPlaying;

  Future<void> init() async {
    _tts.setLanguage("my-MM");
    _tts.setCompletionHandler(() => _isPlaying = false);
    _tts.setErrorHandler((msg) => _isPlaying = false);
  }

  // 15 Voice Profiles Mapping (Simulated via Pitch/Rate)
  Map<String, Map<String, double>> get voiceProfiles => {
    "Voice 01 - Natural Male": {"pitch": 1.0, "rate": 0.5},
    "Voice 02 - Natural Female": {"pitch": 1.2, "rate": 0.5},
    "Voice 03 - Deep Male": {"pitch": 0.8, "rate": 0.45},
    "Voice 04 - Soft Female": {"pitch": 1.3, "rate": 0.45},
    "Voice 05 - Energetic Male": {"pitch": 1.1, "rate": 0.6},
    "Voice 06 - Energetic Female": {"pitch": 1.4, "rate": 0.6},
    "Voice 07 - Documentary Male": {"pitch": 0.85, "rate": 0.4},
    "Voice 08 - Storyteller Male": {"pitch": 0.95, "rate": 0.48},
    "Voice 09 - Storyteller Female": {"pitch": 1.25, "rate": 0.48},
    "Voice 10 - Calm Narrator": {"pitch": 1.0, "rate": 0.35},
    "Voice 11 - Professional Presenter": {"pitch": 1.05, "rate": 0.52},
    "Voice 12 - Movie Recap": {"pitch": 0.9, "rate": 0.55},
    "Voice 13 - Mystery": {"pitch": 0.75, "rate": 0.42},
    "Voice 14 - Friendly Creator": {"pitch": 1.15, "rate": 0.55},
    "Voice 15 - Premium Narrator": {"pitch": 0.95, "rate": 0.45},
  };

  Future<void> speak(String text, String voice, double speedMultiplier) async {
    if (_isPlaying) await _tts.stop();
    
    final profile = voiceProfiles[voice] ?? voiceProfiles["Voice 01 - Natural Male"]!;
    
    _tts.setPitch(profile["pitch"]!);
    _tts.setSpeechRate(profile["rate"]! * speedMultiplier);
    
    _isPlaying = true;
    
    // Long text segmentation
    final sentences = text.split(RegExp(r'[။\n]+'));
    for (String sentence in sentences) {
      if (sentence.trim().isNotEmpty) {
        await _tts.speak(sentence.trim());
      }
    }
    _isPlaying = false;
  }

  Future<void> stop() async {
    await _tts.stop();
    _isPlaying = false;
  }
}
