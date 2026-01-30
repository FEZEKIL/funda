import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../models/explanation.dart';
import '../models/problem.dart';
import '../../config/secrets.dart';

class GeminiApiService {
  final String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent';
  GeminiApiService();

  String get _apiKey => Secrets.geminiApiKey;

  Future<Explanation> analyzeProblem(
    String imagePath,
    String description,
  ) async {
    try {
      final key = _apiKey;
      if (key.isEmpty) {
        throw Exception('API Key is missing');
      }

      // Handle both mobile (file path) and web (data URL or base64) scenarios
      late Uint8List imageBytes;

      // Check if imagePath is a data URL (web scenario)
      if (imagePath.startsWith('data:image')) {
        // Extract base64 data from data URL
        final base64Data = imagePath.split(',')[1];
        imageBytes = base64Decode(base64Data);
      } else {
        // Mobile scenario - read from file path
        final imageFile = File(imagePath);
        if (!await imageFile.exists()) {
          throw Exception('Image file not found: $imagePath');
        }
        imageBytes = await imageFile.readAsBytes();
      }

      final base64Image = base64Encode(imageBytes);

      // Prepare request body
      final requestBody = {
        "contents": [
          {
            "parts": [
              {
                "text":
                    "Analyze this math problem and explain it step-by-step. Provide the output in JSON format with the following structure: { \"problemId\": \"unique_id\", \"steps\": [\"Step 1 explanation\", \"Step 2 explanation\"], \"hint\": \"A helpful hint\", \"explanation\": \"Final answer and summary\" }. Description: $description",
              },
              {
                "inline_data": {"mime_type": "image/jpeg", "data": base64Image},
              },
            ],
          },
        ],
        "generationConfig": {"response_mime_type": "application/json"},
      };

      final response = await http.post(
        Uri.parse('$_baseUrl?key=$key'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      print('API Response Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        if (jsonResponse['candidates'] != null &&
            jsonResponse['candidates'].isNotEmpty &&
            jsonResponse['candidates'][0]['content']['parts'] != null) {
          final textResponse =
              jsonResponse['candidates'][0]['content']['parts'][0]['text'];
          final parsedContent = json.decode(textResponse);

          return Explanation(
            id:
                parsedContent['problemId']?.toString() ??
                DateTime.now().millisecondsSinceEpoch.toString(),
            problemId: parsedContent['problemId']?.toString() ?? 'unknown',
            steps: _convertSteps(parsedContent['steps']),
            hints: [parsedContent['hint'] ?? 'No hint available'],
            finalAnswer: parsedContent['explanation'] ?? 'Not provided',
            createdAt: DateTime.now(),
          );
        } else {
          throw Exception('Invalid response structure from Gemini API');
        }
      } else {
        throw Exception(
          'Failed to analyze image: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (error) {
      print('Error analyzing problem: $error');
      rethrow;
    }
  }

  List<Step> _convertSteps(dynamic steps) {
    if (steps is! List) return [];

    final convertedSteps = steps.asMap().entries.map((entry) {
      final index = entry.key;
      final stepText = entry.value.toString();
      return Step(
        number: index + 1,
        title: 'Step ${index + 1}',
        explanation: stepText,
      );
    }).toList();

    // Add a final step encouraging the user to try it themselves
    convertedSteps.add(
      Step(
        number: convertedSteps.length + 1,
        title: 'Your Turn',
        explanation:
            'Now that you have seen the steps, try to solve the problem yourself to verify your understanding!',
      ),
    );

    return convertedSteps;
  }

  // Helper method checkAnswer is removed or needs update if used.
  // Assuming basic functionality first.
  Future<Map<String, dynamic>> checkAnswer(
    String userAnswer,
    String correctAnswer,
  ) async {
    try {
      final key = _apiKey;
      if (key.isEmpty) {
        throw Exception('API Key is missing');
      }

      final prompt =
          """
      You are a math tutor. A student has provided an answer to a problem.
      The correct answer is: "$correctAnswer"
      The student's answer is: "$userAnswer"
      
      Determine if the student's answer is effectively correct. 
      For example, if the answer is "x = 9" and the student says "9", it is CORRECT.
      If the answer is "1/2" and the student says "0.5", it is CORRECT.
      
      Respond ONLY with valid JSON in the following format:
      {
        "correct": true/false,
        "feedback": "A short, encouraging explanation of why it is correct or incorrect."
      }
      Do not include markdown formatting or backticks.
      """;

      final requestBody = {
        "contents": [
          {
            "parts": [
              {"text": prompt},
            ],
          },
        ],
        "generationConfig": {"response_mime_type": "application/json"},
      };

      final response = await http.post(
        Uri.parse('$_baseUrl?key=$key'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        if (jsonResponse['candidates'] != null &&
            jsonResponse['candidates'].isNotEmpty &&
            jsonResponse['candidates'][0]['content']['parts'] != null) {
          final textResponse =
              jsonResponse['candidates'][0]['content']['parts'][0]['text'];
          return json.decode(textResponse);
        }
      }

      // Fallback
      return {
        "correct": false,
        "feedback": "Unable to verify answer at this time.",
      };
    } catch (e) {
      print('Error checking answer: $e');
      // Fallback local check
      final isCorrect =
          userAnswer.trim().toLowerCase() == correctAnswer.trim().toLowerCase();
      return {
        "correct": isCorrect,
        "feedback": isCorrect ? "Correct!" : "Incorrect. Please try again.",
      };
    }
  }

  Future<Map<String, dynamic>> getReports(String classId) async {
    // Mock implementation as we don't have backend
    return {
      'classId': classId,
      'className': 'Class $classId',
      'totalStudents': 10,
      'students': [],
      'classAverageAccuracy': 0,
      'mostChallengingTopics': [],
    };
  }
}
