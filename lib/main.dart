import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/landing_screen.dart';
import 'screens/simple_deck_list_screen.dart';
import 'screens/subject_deck_list_screen.dart';
import 'screens/simple_study_screen.dart';
import 'theme/index.dart';

void main() {
  runApp(
    const ProviderScope(
      child: STEMFlashcardsApp(),
    ),
  );
}

class STEMFlashcardsApp extends StatelessWidget {
  const STEMFlashcardsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'STEM Flashcards',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const LandingScreen(),
      routes: {
        '/deck-list': (context) {
          final args = ModalRoute.of(context)?.settings.arguments
              as Map<String, dynamic>?;
          final subject = args?['subject'] as String?;
          return SimpleDeckListScreen(selectedSubject: subject);
        },
        '/subject': (context) {
          final subjectId =
              ModalRoute.of(context)?.settings.arguments as String?;
          if (subjectId == null) {
            return const LandingScreen();
          }
          return SubjectDeckListScreen(subjectId: subjectId);
        },
        '/study': (context) {
          final deckId = ModalRoute.of(context)?.settings.arguments as String?;
          if (deckId == null) {
            return const LandingScreen();
          }
          return SimpleStudyScreen(deckId: deckId);
        },
      },
    );
  }
}
