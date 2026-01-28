import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/tutor_provider.dart';
import '../../widgets/loading_indicator.dart';
import 'widgets/step_card.dart';
import 'widgets/hint_box.dart';

class TutorScreen extends StatefulWidget {
  const TutorScreen({super.key});

  @override
  State<TutorScreen> createState() => _TutorScreenState();
}

class _TutorScreenState extends State<TutorScreen> {
  int _currentStepIndex = 0;

  void _showNextStep() {
    final tutorProvider = context.read<TutorProvider>();
    if (_currentStepIndex < tutorProvider.explanation!.steps.length - 1) {
      setState(() {
        _currentStepIndex++;
      });
    }
  }

  void _showHint() {
    final tutorProvider = context.read<TutorProvider>();
    if (tutorProvider.explanation != null &&
        tutorProvider.explanation!.hints.isNotEmpty) {
      final hint = tutorProvider.explanation!.hints.first;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Hint'),
          content: Text(hint),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Got it!'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final tutorProvider = context.watch<TutorProvider>();

    if (tutorProvider.isLoading) {
      return const Scaffold(
        body: LoadingIndicator(message: 'Analyzing your problem...'),
      );
    }

    if (tutorProvider.error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Tutor')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Error: ${tutorProvider.error}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      );
    }

    if (tutorProvider.explanation == null) {
      return const Scaffold(
        body: LoadingIndicator(message: 'Loading explanation...'),
      );
    }

    final explanation = tutorProvider.explanation!;
    final steps = explanation.steps;
    final currentStep = steps[_currentStepIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Step-by-Step Tutor'),
        actions: [
        
          IconButton(
            icon: const Icon(Icons.lightbulb),
            onPressed: _showHint,
            tooltip: 'Get a hint',
          ),
        ],
      ),
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
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  StepCard(step: currentStep),
                  if (_currentStepIndex < steps.length - 1) ...[
                    const SizedBox(height: 16),
                    HintBox(
                      hint: 'Next step: ${steps[_currentStepIndex + 1].title}',
                    ),
                  ],
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              border: Border(top: BorderSide(color: Colors.grey[300]!)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      'Step ${_currentStepIndex + 1} of ${steps.length}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const Spacer(),
                    if (explanation.finalAnswer != null)
                      Flexible(
                        child: Text(
                          'Final Answer: ${explanation.finalAnswer}',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    if (_currentStepIndex > 0)
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              _currentStepIndex--;
                            });
                          },
                          child: const Text('Previous'),
                        ),
                      ),
                    if (_currentStepIndex > 0) const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _currentStepIndex < steps.length - 1
                            ? _showNextStep
                            : () => Navigator.pushNamed(context, '/answer'),
                        child: Text(
                          _currentStepIndex < steps.length - 1
                              ? 'Next Step'
                              : 'Check My Answer',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
