import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/index.dart';

// JSON 데이터를 로드하는 Provider
final jsonDataProvider = FutureProvider<String>((ref) async {
  return await rootBundle.loadString('assets/data/decks.json');
});

// 플래시카드 덱 목록을 제공하는 Provider
final flashcardDecksProvider = FutureProvider<List<FlashcardDeck>>((ref) async {
  final jsonString = await ref.watch(jsonDataProvider.future);
  final jsonData = json.decode(jsonString) as Map<String, dynamic>;
  final decksList = jsonData['decks'] as List<dynamic>;

  return decksList
      .map((deckJson) =>
          FlashcardDeck.fromJson(deckJson as Map<String, dynamic>))
      .toList();
});

// 특정 덱을 ID로 찾는 Provider
final deckByIdProvider =
    Provider.family<AsyncValue<FlashcardDeck>, String>((ref, deckId) {
  final decksAsync = ref.watch(flashcardDecksProvider);

  return decksAsync.when(
    data: (decks) {
      final deck = decks.firstWhere(
        (deck) => deck.id == deckId,
        orElse: () => throw Exception('Deck with id $deckId not found'),
      );
      return AsyncValue.data(deck);
    },
    loading: () => const AsyncValue.loading(),
    error: (error, stack) => AsyncValue.error(error, stack),
  );
});

// 현재 학습 중인 카드 인덱스를 관리하는 StateProvider
final currentCardIndexProvider = StateProvider<int>((ref) => 0);

// 카드가 뒤집혔는지 상태를 관리하는 StateProvider
final isCardFlippedProvider = StateProvider<bool>((ref) => false);

// 학습 세션 상태를 관리하는 StateNotifier
class StudySessionNotifier extends StateNotifier<StudySession> {
  StudySessionNotifier() : super(StudySession.initial());

  void startStudy(FlashcardDeck deck) {
    state = StudySession(
      deck: deck,
      currentCardIndex: 0,
      isCardFlipped: false,
      correctAnswers: 0,
      totalAnswered: 0,
    );
  }

  void nextCard() {
    if (state.deck != null &&
        state.currentCardIndex < state.deck!.cards.length - 1) {
      state = state.copyWith(
        currentCardIndex: state.currentCardIndex + 1,
        isCardFlipped: false,
      );
    }
  }

  void previousCard() {
    if (state.currentCardIndex > 0) {
      state = state.copyWith(
        currentCardIndex: state.currentCardIndex - 1,
        isCardFlipped: false,
      );
    }
  }

  void flipCard() {
    state = state.copyWith(isCardFlipped: !state.isCardFlipped);
  }

  void answerCard(bool isCorrect) {
    state = state.copyWith(
      correctAnswers:
          isCorrect ? state.correctAnswers + 1 : state.correctAnswers,
      totalAnswered: state.totalAnswered + 1,
    );
  }

  void resetSession() {
    state = StudySession.initial();
  }
}

// 학습 세션 Provider
final studySessionProvider =
    StateNotifierProvider<StudySessionNotifier, StudySession>((ref) {
  return StudySessionNotifier();
});

// 학습 세션 데이터 클래스
class StudySession {
  final FlashcardDeck? deck;
  final int currentCardIndex;
  final bool isCardFlipped;
  final int correctAnswers;
  final int totalAnswered;

  const StudySession({
    this.deck,
    required this.currentCardIndex,
    required this.isCardFlipped,
    required this.correctAnswers,
    required this.totalAnswered,
  });

  factory StudySession.initial() {
    return const StudySession(
      deck: null,
      currentCardIndex: 0,
      isCardFlipped: false,
      correctAnswers: 0,
      totalAnswered: 0,
    );
  }

  StudySession copyWith({
    FlashcardDeck? deck,
    int? currentCardIndex,
    bool? isCardFlipped,
    int? correctAnswers,
    int? totalAnswered,
  }) {
    return StudySession(
      deck: deck ?? this.deck,
      currentCardIndex: currentCardIndex ?? this.currentCardIndex,
      isCardFlipped: isCardFlipped ?? this.isCardFlipped,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      totalAnswered: totalAnswered ?? this.totalAnswered,
    );
  }

  double get accuracy {
    if (totalAnswered == 0) return 0.0;
    return correctAnswers / totalAnswered;
  }

  bool get isCompleted {
    return deck != null && currentCardIndex >= deck!.cards.length - 1;
  }
}
