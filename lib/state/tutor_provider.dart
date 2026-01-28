import 'package:flutter/foundation.dart';
import '../data/models/problem.dart';
import '../data/models/explanation.dart';
import '../data/services/gemini_api.dart';
import '../config/secrets.dart';

class TutorProvider extends ChangeNotifier {
  Problem? _currentProblem;
  Explanation? _explanation;
  bool _isLoading = false;
  String? _error;

  Problem? get currentProblem => _currentProblem;
  Explanation? get explanation => _explanation;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> setProblemFromImage(String imagePath) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final apiService = GeminiApiService(apiKey: Secrets.geminiApiKey);
      final explanation = await apiService.analyzeProblem(imagePath, '');

      _currentProblem = Problem(
        id: explanation.problemId,
        description: 'Math problem from image', // We could extract this from the explanation
        subject: 'Mathematics', // We could determine this from the API response
        imagePath: imagePath,
        createdAt: DateTime.now(),
      );

      _explanation = explanation;
    } catch (e) {
      _error = 'Failed to process image: $e';
      print('Error in setProblemFromImage: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearProblem() {
    _currentProblem = null;
    _explanation = null;
    _error = null;
    notifyListeners();
  }
}
