import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'features/home/home_screen.dart';
import 'features/capture/capture_screen.dart';
import 'features/tutor/tutor_screen.dart';
import 'features/answer_check/answer_screen.dart';
import 'state/tutor_provider.dart';
import 'state/answer_provider.dart';
import 'features/splash/splash_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TutorProvider()),
        ChangeNotifierProvider(create: (_) => AnswerProvider()),
      ],
      child: MaterialApp(
        title: 'Funda',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,


        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/home': (context) => const HomeScreen(),
          '/capture': (context) => const CaptureScreen(),
          '/tutor': (context) => const TutorScreen(),
          '/answer': (context) => const AnswerScreen(),
        },
      ),
    );
  }
}
