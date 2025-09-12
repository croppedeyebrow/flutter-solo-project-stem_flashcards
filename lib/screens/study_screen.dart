import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/index.dart';
import '../widgets/index.dart';
import '../theme/index.dart';

class StudyScreen extends ConsumerStatefulWidget {
  final String deckId;

  const StudyScreen({
    super.key,
    required this.deckId,
  });

  @override
  ConsumerState<StudyScreen> createState() => _StudyScreenState();
}

class _StudyScreenState extends ConsumerState<StudyScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeStudy();
    });
  }

  void _initializeStudy() {
    final deckAsync = ref.read(deckByIdProvider(widget.deckId));
    deckAsync.whenData((deck) {
      ref.read(studySessionProvider.notifier).startStudy(deck);
    });
  }

  @override
  Widget build(BuildContext context) {
    final studySession = ref.watch(studySessionProvider);
    final deckAsync = ref.watch(deckByIdProvider(widget.deckId));

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: deckAsync.when(
            data: (deck) => _buildStudyContent(context, deck, studySession),
            loading: () => _buildLoadingState(context),
            error: (error, stack) => _buildErrorState(context, error),
          ),
        ),
      ),
    );
  }

  Widget _buildStudyContent(
      BuildContext context, dynamic deck, StudySession studySession) {
    if (studySession.deck == null) {
      return _buildLoadingState(context);
    }

    final currentCard = studySession.deck!.cards[studySession.currentCardIndex];
    final progress =
        (studySession.currentCardIndex + 1) / studySession.deck!.cards.length;

    return Column(
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.all(16),
          child: GlassmorphismWidget(
            borderRadius: 20,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            deck.title,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          Text(
                            '${studySession.currentCardIndex + 1} / ${deck.cards.length}',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        '${(progress * 100).toInt()}%',
                        style:
                            Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: AppColors.glassBackground,
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ],
            ),
          ),
        ),

        // Flashcard
        Expanded(
          child: FlashcardWidget(
            card: currentCard,
            isFlipped: studySession.isCardFlipped,
            onTap: () {
              ref.read(studySessionProvider.notifier).flipCard();
            },
            onSwipeLeft: () {
              if (studySession.currentCardIndex <
                  studySession.deck!.cards.length - 1) {
                ref.read(studySessionProvider.notifier).nextCard();
              }
            },
            onSwipeRight: () {
              if (studySession.currentCardIndex > 0) {
                ref.read(studySessionProvider.notifier).previousCard();
              }
            },
          ),
        ),

        // Navigation Controls
        Padding(
          padding: const EdgeInsets.all(16),
          child: GlassmorphismWidget(
            borderRadius: 20,
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GlassmorphismButton(
                  onPressed: studySession.currentCardIndex > 0
                      ? () =>
                          ref.read(studySessionProvider.notifier).previousCard()
                      : null,
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.chevron_left),
                      Text('이전'),
                    ],
                  ),
                ),
                GlassmorphismButton(
                  onPressed: () {
                    ref.read(studySessionProvider.notifier).flipCard();
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        studySession.isCardFlipped
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      const SizedBox(width: 4),
                      Text(studySession.isCardFlipped ? '문제 보기' : '답 보기'),
                    ],
                  ),
                ),
                GlassmorphismButton(
                  onPressed: studySession.currentCardIndex <
                          studySession.deck!.cards.length - 1
                      ? () => ref.read(studySessionProvider.notifier).nextCard()
                      : null,
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('다음'),
                      Icon(Icons.chevron_right),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    return Center(
      child: GlassmorphismWidget(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
            const SizedBox(height: 16),
            Text(
              '학습을 준비하는 중...',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, Object error) {
    return Center(
      child: GlassmorphismWidget(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: AppColors.error,
            ),
            const SizedBox(height: 16),
            Text(
              '오류가 발생했습니다',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.error,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('돌아가기'),
            ),
          ],
        ),
      ),
    );
  }
}
