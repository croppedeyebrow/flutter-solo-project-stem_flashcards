import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/index.dart';
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
      home: const DeckListScreen(),
      routes: {
        '/study': (context) {
          final deckId = ModalRoute.of(context)?.settings.arguments as String?;
          if (deckId == null) {
            return const DeckListScreen();
          }
          return StudyScreen(deckId: deckId);
        },
      },
    );
  }
}
