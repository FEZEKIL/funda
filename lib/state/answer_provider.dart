import 'package:flutter/foundation.dart';
import '../config/secrets.dart';
import '../data/services/gemini_api.dart';

class AnswerProvider extends ChangeNotifier {
  String? _userAnswer;
  bool? _isCorrect;
  String? _feedback;
  bool _isLoading = false;
  String? _error;

  String? get userAnswer => _userAnswer;
  bool? get isCorrect => _isCorrect;
  String? get feedback => _feedback;
  bool get isLoading => _isLoading;
  String? get error => _error;



  Future<void> checkAnswer(String answer, String correctAnswer) async {
    _isLoading = true;
    _error = null;
    _userAnswer = answer;
    notifyListeners();

    try {
      final apiService = GeminiApiService(apiKey: Secrets.geminiApiKey);
      final result = await apiService.checkAnswer(answer, correctAnswer);

      _isCorrect = result['correct'] as bool? ?? false;
      _feedback = result['feedback'] as String?;

      if (_feedback == null) {
         if (_isCorrect!) {
          _feedback = 'Great job! Your answer is correct. 🎉';
        } else {
          _feedback = 'Not quite right. The answer should be closer to: $correctAnswer';
        }
      }
      
    } catch (e) {
      _error = 'Failed to check answer: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void reset() {
    _userAnswer = null;
    _isCorrect = null;
    _feedback = null;
    _error = null;
    notifyListeners();
  }
}
