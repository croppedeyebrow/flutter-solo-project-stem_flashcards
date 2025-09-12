import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/index.dart';
import '../widgets/index.dart';
import '../theme/index.dart';

class EnhancedStudyScreen extends ConsumerStatefulWidget {
  final String deckId;

  const EnhancedStudyScreen({
    super.key,
    required this.deckId,
  });

  @override
  ConsumerState<EnhancedStudyScreen> createState() =>
      _EnhancedStudyScreenState();
}

class _EnhancedStudyScreenState extends ConsumerState<EnhancedStudyScreen>
    with TickerProviderStateMixin {
  late AnimationController _progressController;
  late AnimationController _cardController;
  late Animation<double> _progressAnimation;
  late Animation<double> _cardAnimation;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _cardController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOut,
    ));

    _cardAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _cardController,
      curve: Curves.easeInOut,
    ));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeStudy();
    });
  }

  void _initializeStudy() {
    final deckAsync = ref.read(deckByIdProvider(widget.deckId));
    deckAsync.whenData((deck) {
      ref.read(studySessionProvider.notifier).startStudy(deck);
      _progressController.forward();
      _cardController.forward();
    });
  }

  @override
  void dispose() {
    _progressController.dispose();
    _cardController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final studySession = ref.watch(studySessionProvider);
    final deckAsync = ref.watch(deckByIdProvider(widget.deckId));

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF667eea),
              Color(0xFF764ba2),
              Color(0xFFf093fb),
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: deckAsync.when(
            data: (deck) =>
                _buildEnhancedStudyContent(context, deck, studySession),
            loading: () => _buildEnhancedLoadingState(context),
            error: (error, stack) => _buildEnhancedErrorState(context, error),
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedStudyContent(
      BuildContext context, dynamic deck, StudySession studySession) {
    if (studySession.deck == null) {
      return _buildEnhancedLoadingState(context);
    }

    final currentCard = studySession.deck!.cards[studySession.currentCardIndex];
    final progress =
        (studySession.currentCardIndex + 1) / studySession.deck!.cards.length;

    return Column(
      children: [
        // Enhanced Header
        Padding(
          padding: const EdgeInsets.all(20),
          child: GlassmorphismWidget(
            borderRadius: 25,
            blur: 15,
            opacity: 0.2,
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    // Back button with enhanced design
                    Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
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
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.3),
                                  offset: const Offset(0, 2),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${studySession.currentCardIndex + 1} / ${deck.cards.length}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Colors.white.withOpacity(0.8),
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ],
                      ),
                    ),
                    // Progress percentage with enhanced design
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF4facfe).withOpacity(0.4),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        '${(progress * 100).toInt()}%',
                        style:
                            Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Enhanced progress bar
                AnimatedBuilder(
                  animation: _progressAnimation,
                  builder: (context, child) {
                    return Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: progress * _progressAnimation.value,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
                            ),
                            borderRadius: BorderRadius.circular(4),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF4facfe).withOpacity(0.5),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),

        // Enhanced Flashcard
        Expanded(
          child: AnimatedBuilder(
            animation: _cardAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _cardAnimation.value,
                child: Opacity(
                  opacity: _cardAnimation.value,
                  child: _buildEnhancedFlashcard(
                      context, currentCard, studySession),
                ),
              );
            },
          ),
        ),

        // Enhanced Navigation Controls
        Padding(
          padding: const EdgeInsets.all(20),
          child: GlassmorphismWidget(
            borderRadius: 25,
            blur: 15,
            opacity: 0.2,
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildEnhancedNavButton(
                  context,
                  Icons.chevron_left,
                  '이전',
                  studySession.currentCardIndex > 0
                      ? () =>
                          ref.read(studySessionProvider.notifier).previousCard()
                      : null,
                ),
                _buildEnhancedNavButton(
                  context,
                  studySession.isCardFlipped
                      ? Icons.visibility_off
                      : Icons.visibility,
                  studySession.isCardFlipped ? '문제' : '답',
                  () => ref.read(studySessionProvider.notifier).flipCard(),
                  isPrimary: true,
                ),
                _buildEnhancedNavButton(
                  context,
                  Icons.chevron_right,
                  '다음',
                  studySession.currentCardIndex <
                          studySession.deck!.cards.length - 1
                      ? () => ref.read(studySessionProvider.notifier).nextCard()
                      : null,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEnhancedFlashcard(
      BuildContext context, dynamic card, StudySession studySession) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: GlassmorphismCard(
        borderRadius: 30,
        blur: 20,
        opacity: 0.15,
        onTap: () {
          ref.read(studySessionProvider.notifier).flipCard();
        },
        child: Container(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Card type indicator
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient: studySession.isCardFlipped
                      ? const LinearGradient(
                          colors: [Color(0xFF43e97b), Color(0xFF38f9d7)],
                        )
                      : const LinearGradient(
                          colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
                        ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: (studySession.isCardFlipped
                              ? const Color(0xFF43e97b)
                              : const Color(0xFF4facfe))
                          .withOpacity(0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  studySession.isCardFlipped ? '답' : '문제',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              const SizedBox(height: 30),
              // Card content
              Expanded(
                child: Center(
                  child: Text(
                    studySession.isCardFlipped ? card.back : card.front,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          height: 1.4,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Tap instruction
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.touch_app,
                      color: Colors.white.withOpacity(0.8),
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '터치하여 ${studySession.isCardFlipped ? '문제 보기' : '답 보기'}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white.withOpacity(0.8),
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedNavButton(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback? onPressed, {
    bool isPrimary = false,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          gradient: isPrimary
              ? const LinearGradient(
                  colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
                )
              : LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.2),
                    Colors.white.withOpacity(0.1),
                  ],
                ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: isPrimary
              ? [
                  BoxShadow(
                    color: const Color(0xFF4facfe).withOpacity(0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedLoadingState(BuildContext context) {
    return Center(
      child: GlassmorphismWidget(
        borderRadius: 25,
        blur: 15,
        opacity: 0.2,
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 3,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '학습을 준비하는 중...',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              '잠시만 기다려주세요',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withOpacity(0.8),
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedErrorState(BuildContext context, Object error) {
    return Center(
      child: GlassmorphismWidget(
        borderRadius: 25,
        blur: 15,
        opacity: 0.2,
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFf5576c), Color(0xFFf093fb)],
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Icon(
                Icons.error_outline,
                color: Colors.white,
                size: 30,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '오류가 발생했습니다',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white.withOpacity(0.8),
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            GlassmorphismButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                '돌아가기',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
