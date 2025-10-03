import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_colors.dart';
import '../theme/glassmorphism.dart';

class LandingScreen extends ConsumerWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary,
              AppColors.secondary,
              AppColors.accent,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 앱 타이틀
                const Text(
                  'STEM Flashcards',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '과학 기술 공학 수학을 한 번에',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 60),

                // 과목 선택 카드들
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children: [
                      _buildSubjectCard(
                        context,
                        '수학',
                        'Math',
                        Icons.calculate,
                        AppColors.mathColor,
                        '/math',
                      ),
                      _buildSubjectCard(
                        context,
                        '물리',
                        'Physics',
                        Icons.science,
                        AppColors.physicsColor,
                        '/physics',
                      ),
                      _buildSubjectCard(
                        context,
                        '화학',
                        'Chemistry',
                        Icons.biotech,
                        AppColors.chemistryColor,
                        '/chemistry',
                      ),
                      _buildSubjectCard(
                        context,
                        '생물',
                        'Biology',
                        Icons.eco,
                        AppColors.biologyColor,
                        '/biology',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubjectCard(
    BuildContext context,
    String koreanTitle,
    String englishTitle,
    IconData icon,
    Color color,
    String route,
  ) {
    return GlassmorphismWidget(
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            '/subject',
            arguments: englishTitle.toLowerCase(),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: color,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                koreanTitle,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                englishTitle,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
