import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/answer_provider.dart';
import '../../state/tutor_provider.dart';
import '../../core/utils/validators.dart';
import '../../widgets/primary_button.dart';
import 'widgets/feedback_box.dart';

import 'widgets/scratchpad.dart';

class AnswerScreen extends StatefulWidget {
  const AnswerScreen({super.key});

  @override
  State<AnswerScreen> createState() => _AnswerScreenState();
}

class _AnswerScreenState extends State<AnswerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _answerController = TextEditingController();
  bool _showScratchpad = false;

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  Future<void> _checkAnswer() async {
    if (!_formKey.currentState!.validate()) return;

    final tutorProvider = context.read<TutorProvider>();
    final answerProvider = context.read<AnswerProvider>();

    final correctAnswer = tutorProvider.explanation?.finalAnswer ?? '';
    await answerProvider.checkAnswer(_answerController.text, correctAnswer);
  }

  @override
  Widget build(BuildContext context) {
    final answerProvider = context.watch<AnswerProvider>();
    final tutorProvider = context.watch<TutorProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Check Your Answer'),

        foregroundColor: const Color(0xFF00D2FF),
        actions: [
          IconButton(
            icon: Icon(
              _showScratchpad ? Icons.edit_off : Icons.edit,
              color: const Color(0xFF00D2FF),
            ),
            onPressed: () {
              setState(() {
                _showScratchpad = !_showScratchpad;
              });
            },
            tooltip: _showScratchpad ? 'Hide Scratchpad' : 'Show Scratchpad',
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Problem: ${tutorProvider.currentProblem?.description ?? "Unknown"}',
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge?.copyWith(color: Colors.black),
                  ),
                  const SizedBox(height: 16),
                  if (tutorProvider.explanation?.finalAnswer != null)
                    Text(
                      'Expected Answer: ${tutorProvider.explanation!.finalAnswer}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: Colors.grey[600],
                      ),
                    ),

                  if (_showScratchpad) ...[
                    const SizedBox(height: 16),
                    const Scratchpad(height: 250),
                  ],

                  const SizedBox(height: 24),
                  Form(
                    key: _formKey,
                    child: TextFormField(
                      controller: _answerController,
                      decoration: const InputDecoration(
                        labelText: 'Your Answer',
                        hintText: 'Enter your solution here',
                        border: OutlineInputBorder(),
                      ),
                      validator: Validators.validateAnswer,
                      maxLines: 3,
                    ),
                  ),
                  const SizedBox(height: 24),
                  PrimaryButton(
                    text: 'Check Answer',
                    onPressed: answerProvider.isLoading ? null : _checkAnswer,
                    isLoading: answerProvider.isLoading,
                    backgroundColor: const Color(0xFFBEFF00),
                    foregroundColor: const Color(0xFF00D2FF),
                  ),
                  if (answerProvider.error != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                        answerProvider.error!,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  if (answerProvider.feedback != null) ...[
                    const SizedBox(height: 24),
                    FeedbackBox(
                      isCorrect: answerProvider.isCorrect ?? false,
                      feedback: answerProvider.feedback!,
                    ),
                  ],
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, '/tutor'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00D2FF),
                    ),
                    child: const Text('Back to Steps',
                    style: TextStyle(
                      color: Colors.white
                    ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/',
                      (route) => false,
                    ),
                    child: const Text('New Problem'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
