import 'package:flutter_tts/flutter_tts.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tts_service.g.dart';

// A provider for the TextToSpeech service
@riverpod
TextToSpeechService textToSpeechService(TextToSpeechServiceRef ref) {
  return TextToSpeechService();
}

class TextToSpeechService {
  final FlutterTts _flutterTts = FlutterTts();
  bool _isInitialized = false;

  TextToSpeechService() {
    _init();
  }

  Future<void> _init() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts
        .setSpeechRate(0.5); // Slightly slower for better understanding
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);
    _isInitialized = true;
  }

  Future<void> speak(String text) async {
    if (!_isInitialized) {
      await _init();
    }

    // Stop any current speech
    await _flutterTts.stop();

    // Start speaking the new text
    await _flutterTts.speak(text);
  }

  Future<void> stop() async {
    await _flutterTts.stop();
  }

  void dispose() {
    _flutterTts.stop();
  }
}
