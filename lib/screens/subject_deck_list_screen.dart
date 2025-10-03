import 'package:flutter/material.dart';
import '../utils/subject_page_template.dart';
import '../utils/navigation_util.dart';

class SubjectDeckListScreen extends StatelessWidget {
  final String subjectId;

  const SubjectDeckListScreen({
    super.key,
    required this.subjectId,
  });

  @override
  Widget build(BuildContext context) {
    final subjectInfo = SubjectPageTemplate.getSubjectInfo(subjectId);
    final decks = SubjectPageTemplate.getDefaultDecks(subjectId);
    final gradientColors = SubjectPageTemplate.getSubjectGradient(subjectId);

    print('SubjectId: $subjectId');
    print('SubjectInfo: $subjectInfo');
    print('Decks count: ${decks.length}');

    if (subjectInfo == null) {
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.grey.shade400, Colors.grey.shade600],
            ),
          ),
          child: Column(
            children: [
              NavigationUtil.buildGlassNavigationBar(
                context: context,
                title: '오류',
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
                      Text(
                        '덱을 찾을 수 없습니다',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '과목 ID: $subjectId',
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

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradientColors,
          ),
        ),
        child: Column(
          children: [
            // 네비게이션 바
            NavigationUtil.buildGlassNavigationBar(
              context: context,
              title: '${subjectInfo.koreanName} Flashcards',
              showBackButton: true,
              leading: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: subjectInfo.colors,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    subjectInfo.icon,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ),

            // 헤더 정보
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                subjectInfo.description,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            // Deck List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: decks.length,
                itemBuilder: (context, index) {
                  final deck = decks[index];
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
                                    colors: subjectInfo.colors,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      deck['title'] as String,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
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
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              _buildInfoChip(
                                deck['difficulty'] as String,
                                _getDifficultyColor(
                                  deck['difficulty'] as String,
                                ),
                              ),
                              const SizedBox(width: 8),
                              _buildInfoChip(
                                '${deck['totalCards']}개 카드',
                                Colors.white.withOpacity(0.3),
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
    );
  }
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
