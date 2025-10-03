import 'package:flutter/material.dart';

class SimpleDeckListScreen extends StatelessWidget {
  final String? selectedSubject;

  const SimpleDeckListScreen({super.key, this.selectedSubject});

  @override
  Widget build(BuildContext context) {
    // 하드코딩된 덱 데이터
    final allDecks = [
      {
        'id': 'math_formulas_1',
        'title': '수학 공식 - 기본',
        'description': '고등학교 수학의 핵심 공식들을 모았습니다',
        'subject': 'math',
        'subjectKorean': '수학',
        'difficulty': '중급',
        'icon': '📐',
        'totalCards': 3,
      },
      {
        'id': 'math_formulas_2',
        'title': '수학 공식 - 고급',
        'description': '대학교 수학의 고급 공식들',
        'subject': 'math',
        'subjectKorean': '수학',
        'difficulty': '고급',
        'icon': '📐',
        'totalCards': 5,
      },
      {
        'id': 'physics_laws_1',
        'title': '물리 법칙 - 역학',
        'description': '뉴턴의 운동법칙과 기본 역학 공식들',
        'subject': 'physics',
        'subjectKorean': '물리',
        'difficulty': '중급',
        'icon': '⚡',
        'totalCards': 3,
      },
      {
        'id': 'physics_laws_2',
        'title': '물리 법칙 - 전자기학',
        'description': '전자기학의 기본 법칙들',
        'subject': 'physics',
        'subjectKorean': '물리',
        'difficulty': '고급',
        'icon': '⚡',
        'totalCards': 4,
      },
      {
        'id': 'chemistry_elements_1',
        'title': '화학 원소 - 주기율표',
        'description': '주요 화학 원소들의 기호와 특성',
        'subject': 'chemistry',
        'subjectKorean': '화학',
        'difficulty': '기초',
        'icon': '🧪',
        'totalCards': 3,
      },
      {
        'id': 'biology_cells_1',
        'title': '생물학 - 세포 구조',
        'description': '세포의 구조와 기능',
        'subject': 'biology',
        'subjectKorean': '생물',
        'difficulty': '기초',
        'icon': '🧬',
        'totalCards': 4,
      },
    ];

    // 선택된 과목에 따라 필터링
    final filteredDecks = selectedSubject != null
        ? allDecks.where((deck) => deck['subject'] == selectedSubject).toList()
        : allDecks;

    // 과목 이름 매핑
    final subjectNames = {
      'math': '수학',
      'physics': '물리',
      'chemistry': '화학',
      'biology': '생물',
    };

    final subjectTitle =
        selectedSubject != null ? subjectNames[selectedSubject] ?? '전체' : '전체';

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
              // App Bar
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
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Icon(
                          Icons.psychology,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$subjectTitle Flashcards',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              selectedSubject != null
                                  ? '$subjectTitle 과목의 플래시카드'
                                  : '수학 • 물리 • 화학 • 생물 공식 암기',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Deck List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: filteredDecks.length,
                  itemBuilder: (context, index) {
                    final deck = filteredDecks[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          '/study',
                          arguments: deck['id'],
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: _getSubjectColors(
                                          deck['subject'] as String),
                                    ),
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  child: Center(
                                    child: Text(
                                      deck['icon'] as String,
                                      style: const TextStyle(fontSize: 28),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        deck['title'] as String,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        deck['description'] as String,
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.8),
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                _buildInfoChip(
                                    deck['subject'] as String,
                                    _getSubjectColors(
                                        deck['subject'] as String)[0]),
                                const SizedBox(width: 12),
                                _buildInfoChip(
                                    deck['difficulty'] as String,
                                    _getDifficultyColor(
                                        deck['difficulty'] as String)),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Text(
                                    '${deck['totalCards']}개 카드',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.3),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: color.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  List<Color> _getSubjectColors(String subject) {
    switch (subject) {
      case 'math':
      case '수학':
        return [const Color(0xFF4facfe), const Color(0xFF00f2fe)];
      case 'physics':
      case '물리':
        return [const Color(0xFF667eea), const Color(0xFF764ba2)];
      case 'chemistry':
      case '화학':
        return [const Color(0xFFf093fb), const Color(0xFFf5576c)];
      case 'biology':
      case '생물':
        return [const Color(0xFF43e97b), const Color(0xFF38f9d7)];
      default:
        return [const Color(0xFF4facfe), const Color(0xFF00f2fe)];
    }
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case '기초':
        return const Color(0xFF43e97b);
      case '중급':
        return const Color(0xFFf093fb);
      case '고급':
        return const Color(0xFFf5576c);
      default:
        return const Color(0xFF4facfe);
    }
  }
}
