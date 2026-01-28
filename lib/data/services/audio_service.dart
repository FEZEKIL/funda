import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';
import 'dart:typed_data';

class AudioService {
  // Assuming backend is running on localhost:5000, change if needed
  static const String _backendUrl = 'http://localhost:5000/api/tts/synthesize';

  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> speak(String text) async {
    try {
      final response = await http.post(
        Uri.parse(_backendUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"text": text}),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['audioContent'] != null) {
          final audioData = jsonResponse['audioContent'];
          final bytes = base64Decode(audioData);
          await _playAudio(bytes);
        } else {
          print('Invalid TTS response structure');
        }
      } else {
        print('TTS Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error playing audio: $e');
    }
  }

  Future<void> _playAudio(Uint8List bytes) async {
    await _audioPlayer.play(BytesSource(bytes));
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
  }
}
