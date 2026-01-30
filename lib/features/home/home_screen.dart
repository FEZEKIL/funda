import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/tutor_provider.dart';
import 'widgets/feature_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Lab Assistant'),
        centerTitle: true,
      
        foregroundColor: const Color(0xFF00D2FF),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to your AI Math & Physics Tutor!',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Take a photo of your problem and get step-by-step help.',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: const Color(0xFF00D2FF)),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  FeatureCard(
                    title: 'Capture Problem',
                    subtitle: 'Take a photo or upload',
                    icon: Icons.camera_alt,
                    color: const Color(0xFFBEFF00),
                    onTap: () => Navigator.pushNamed(context, '/capture'),
                  ),
                  FeatureCard(
                    title: 'Step-by-Step Tutor',
                    subtitle: 'Learn with guidance',
                    icon: Icons.school,
                    color: const Color(0xFF00D2FF),
                    onTap: () {
                      final tutorProvider = context.read<TutorProvider>();
                      if (tutorProvider.currentProblem != null) {
                        Navigator.pushNamed(context, '/tutor');
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please capture a problem first'),
                          ),
                        );
                      }
                    },
                  ),
                  FeatureCard(
                    title: 'Check Answer',
                    subtitle: 'Verify your solution',
                    icon: Icons.check_circle,
                    color: const Color(0xFFBEFF00),
                    onTap: () {
                      final tutorProvider = context.read<TutorProvider>();
                      if (tutorProvider.currentProblem != null) {
                        Navigator.pushNamed(context, '/answer');
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please capture a problem first'),
                          ),
                        );
                      }
                    },
                  ),
                  FeatureCard(
                    title: 'Saved Problems',
                    subtitle: 'Review past work',
                    icon: Icons.history,
                    color: const Color(0xFF00D2FF),
                    onTap: () {
                      // TODO: Implement saved problems screen
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Saved problems coming soon!'),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
