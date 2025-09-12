import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/index.dart';
import 'screens/enhanced_deck_list_screen.dart';
import 'screens/enhanced_study_screen.dart';
import 'screens/test_screen.dart';
import 'screens/simple_deck_list_screen.dart';
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
      home: const SimpleDeckListScreen(),
      routes: {
        '/study': (context) {
          final deckId = ModalRoute.of(context)?.settings.arguments as String?;
          if (deckId == null) {
            return const SimpleDeckListScreen();
          }
          return SimpleStudyScreen(deckId: deckId);
        },
      },
    );
  }
}
