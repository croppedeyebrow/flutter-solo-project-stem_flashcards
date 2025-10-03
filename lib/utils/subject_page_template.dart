import 'package:flutter/material.dart';

/// 과목별 페이지의 공통 템플릿을 제공하는 유틸리티 클래스
class SubjectPageTemplate {
  /// 과목 정보를 담는 데이터 클래스
  static const Map<String, SubjectInfo> subjects = {
    'math': SubjectInfo(
      id: 'math',
      koreanName: '수학',
      englishName: 'Math',
      icon: '📐',
      colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
      description: '수학의 핵심 공식과 개념',
    ),
    'physics': SubjectInfo(
      id: 'physics',
      koreanName: '물리',
      englishName: 'Physics',
      icon: '⚡',
      colors: [Color(0xFF667eea), Color(0xFF764ba2)],
      description: '물리 법칙과 현상',
    ),
    'chemistry': SubjectInfo(
      id: 'chemistry',
      koreanName: '화학',
      englishName: 'Chemistry',
      icon: '🧪',
      colors: [Color(0xFFf093fb), Color(0xFFf5576c)],
      description: '화학 원소와 반응',
    ),
    'biology': SubjectInfo(
      id: 'biology',
      koreanName: '생물',
      englishName: 'Biology',
      icon: '🧬',
      colors: [Color(0xFF43e97b), Color(0xFF38f9d7)],
      description: '생물학의 구조와 기능',
    ),
  };

  /// 과목별 기본 덱 데이터를 반환
  static List<Map<String, dynamic>> getDefaultDecks(String subjectId) {
    final subject = subjects[subjectId];
    if (subject == null) return [];

    switch (subjectId) {
      case 'math':
        return [
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
            'id': 'math_calculus',
            'title': '미적분학',
            'description': '미분과 적분의 기본 개념',
            'subject': 'math',
            'subjectKorean': '수학',
            'difficulty': '고급',
            'icon': '📐',
            'totalCards': 6,
          },
        ];

      case 'physics':
        return [
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
            'id': 'physics_thermodynamics',
            'title': '열역학',
            'description': '열과 에너지의 법칙',
            'subject': 'physics',
            'subjectKorean': '물리',
            'difficulty': '고급',
            'icon': '⚡',
            'totalCards': 5,
          },
        ];

      case 'chemistry':
        return [
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
            'id': 'chemistry_reactions',
            'title': '화학 반응',
            'description': '기본 화학 반응식과 원리',
            'subject': 'chemistry',
            'subjectKorean': '화학',
            'difficulty': '중급',
            'icon': '🧪',
            'totalCards': 4,
          },
          {
            'id': 'chemistry_organic',
            'title': '유기화학',
            'description': '탄소 화합물의 구조와 성질',
            'subject': 'chemistry',
            'subjectKorean': '화학',
            'difficulty': '고급',
            'icon': '🧪',
            'totalCards': 6,
          },
        ];

      case 'biology':
        return [
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
          {
            'id': 'biology_genetics',
            'title': '유전학',
            'description': '유전자와 유전의 법칙',
            'subject': 'biology',
            'subjectKorean': '생물',
            'difficulty': '중급',
            'icon': '🧬',
            'totalCards': 5,
          },
          {
            'id': 'biology_ecology',
            'title': '생태학',
            'description': '생태계와 환경의 상호작용',
            'subject': 'biology',
            'subjectKorean': '생물',
            'difficulty': '중급',
            'icon': '🧬',
            'totalCards': 4,
          },
        ];

      default:
        return [];
    }
  }

  /// 과목별 그라데이션 배경을 반환
  static List<Color> getSubjectGradient(String subjectId) {
    final subject = subjects[subjectId];
    if (subject == null) {
      return [const Color(0xFF667eea), const Color(0xFF764ba2)];
    }
    return subject.colors;
  }

  /// 과목 정보를 반환
  static SubjectInfo? getSubjectInfo(String subjectId) {
    return subjects[subjectId];
  }
}

/// 과목 정보를 담는 데이터 클래스
class SubjectInfo {
  final String id;
  final String koreanName;
  final String englishName;
  final String icon;
  final List<Color> colors;
  final String description;

  const SubjectInfo({
    required this.id,
    required this.koreanName,
    required this.englishName,
    required this.icon,
    required this.colors,
    required this.description,
  });
}
