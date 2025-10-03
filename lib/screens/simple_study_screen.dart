import 'package:flutter/material.dart';
import '../utils/navigation_util.dart';

class SimpleStudyScreen extends StatefulWidget {
  final String deckId;

  const SimpleStudyScreen({
    super.key,
    required this.deckId,
  });

  @override
  State<SimpleStudyScreen> createState() => _SimpleStudyScreenState();
}

class _SimpleStudyScreenState extends State<SimpleStudyScreen> {
  int currentCardIndex = 0;
  bool isCardFlipped = false;

  // 하드코딩된 카드 데이터
  final Map<String, List<Map<String, String>>> deckData = {
    'math_formulas_1': [
      {
        'front': '이차방정식의 해 공식',
        'back': 'ax² + bx + c = 0의 해는\nx = (-b ± √(b²-4ac)) / 2a',
      },
      {
        'front': '피타고라스 정리',
        'back': '직각삼각형에서\n빗변의 제곱 = 다른 두 변의 제곱의 합',
      },
      {
        'front': '미분의 기본 공식',
        'back': 'f(x) = xⁿ의 도함수는\nf\'(x) = nxⁿ⁻¹',
      },
    ],
    'physics_laws_1': [
      {
        'front': '뉴턴의 제1법칙',
        'back':
            '관성의 법칙:\n외부 힘이 작용하지 않으면\n정지한 물체는 계속 정지하고,\n운동하는 물체는 등속직선운동을 계속한다',
      },
      {
        'front': '뉴턴의 제2법칙',
        'back': 'F = ma\n(힘 = 질량 × 가속도)',
      },
      {
        'front': '운동에너지 공식',
        'back': 'KE = ½mv²\n(운동에너지 = ½ × 질량 × 속도의 제곱)',
      },
    ],
    'chemistry_elements_1': [
      {
        'front': '수소 (H)',
        'back': '원자번호 1\n가장 가벼운 원소\n무색무취의 기체',
      },
      {
        'front': '산소 (O)',
        'back': '원자번호 8\n생명체의 호흡에 필수적인 원소',
      },
      {
        'front': '탄소 (C)',
        'back': '원자번호 6\n모든 생명체의 기본 구성 요소',
      },
    ],
  };

  List<Map<String, String>> get currentDeck => deckData[widget.deckId] ?? [];

  @override
  Widget build(BuildContext context) {
    final cards = currentDeck;
    if (cards.isEmpty) {
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
            ),
          ),
          child: Column(
            children: [
              NavigationUtil.buildGlassNavigationBar(
                context: context,
                title: '아직 학습할 덱이 없습니다',
                showBackButton: true,
              ),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.white.withOpacity(0.7),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        '덱을 찾을 수 없습니다',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '덱 ID: ${widget.deckId}',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final currentCard = cards[currentCardIndex];
    final progress = (currentCardIndex + 1) / cards.length;

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
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 45,
                            height: 45,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
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
                                  _getDeckTitle(widget.deckId),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${currentCardIndex + 1} / ${cards.length}',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${(progress * 100).toInt()}%',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Progress bar
                      Container(
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: progress,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Flashcard
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isCardFlipped = !isCardFlipped;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Card type indicator
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            gradient: isCardFlipped
                                ? const LinearGradient(
                                    colors: [
                                      Color(0xFF43e97b),
                                      Color(0xFF38f9d7)
                                    ],
                                  )
                                : const LinearGradient(
                                    colors: [
                                      Color(0xFF4facfe),
                                      Color(0xFF00f2fe)
                                    ],
                                  ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            isCardFlipped ? '답' : '문제',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        // Card content
                        Expanded(
                          child: Center(
                            child: Text(
                              isCardFlipped
                                  ? currentCard['back']!
                                  : currentCard['front']!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                height: 1.4,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Tap instruction
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Text(
                            '터치하여 ${isCardFlipped ? '문제 보기' : '답 보기'}',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Navigation Controls
              Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildNavButton(
                        Icons.chevron_left,
                        '이전',
                        currentCardIndex > 0
                            ? () {
                                setState(() {
                                  currentCardIndex--;
                                  isCardFlipped = false;
                                });
                              }
                            : null,
                      ),
                      _buildNavButton(
                        isCardFlipped ? Icons.visibility_off : Icons.visibility,
                        isCardFlipped ? '문제' : '답',
                        () {
                          setState(() {
                            isCardFlipped = !isCardFlipped;
                          });
                        },
                        isPrimary: true,
                      ),
                      _buildNavButton(
                        Icons.chevron_right,
                        '다음',
                        currentCardIndex < cards.length - 1
                            ? () {
                                setState(() {
                                  currentCardIndex++;
                                  isCardFlipped = false;
                                });
                              }
                            : null,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavButton(
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
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getDeckTitle(String deckId) {
    switch (deckId) {
      case 'math_formulas_1':
        return '수학 공식 - 기본';
      case 'physics_laws_1':
        return '물리 법칙 - 역학';
      case 'chemistry_elements_1':
        return '화학 원소 - 주기율표';
      default:
        return '알 수 없는 덱';
    }
  }
}
