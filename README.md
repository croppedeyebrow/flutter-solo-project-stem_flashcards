# 📝 STEM 플래시카드 통합 앱 기획서 (Final Version)

---

## 1. 프로젝트 개요 및 목표.

### 1.1 핵심 가치

STEM 통합: 수학, 물리, 화학, 생물을 단일 앱에서 학습하며, 향후 확장성을 확보합니다.

오프라인 우선: 모든 데이터는 로컬 JSON에 내장하여 서버 비용 및 관리 부담을 제거합니다.

MVP 목표: 1-2일 내 배포 가능한 핵심 학습 기능 구현에 집중합니다.

### 1.2 타겟 고객

고등학생 ~ 대학교 2학년: STEM 과목의 공식, 정의, 개념을 암기하려는 학습자.

주요 니즈: 빠르고 시각적으로 매력적인 반복 학습 툴.

## 2. 콘텐츠 및 데이터 아키텍처

### 2.1 콘텐츠 계층 구조 (4단계)

앱은 4단계의 깊이로 구성됩니다.

Category (카테고리): STEM (최상위)

Subject (과목): Math, Physics, Chemistry, Biology

Deck (덱): 각 과목 내의 세부 주제 (예: '미적분 기본 공식', '뉴턴 역학')

Card (카드): 플래시카드 한 장 (앞/뒤)

### 2.2 데이터 파일 명세

파일명: assets/data/decks.json

구조: JSON 배열 형태로 모든 덱을 저장하며, 각 덱에는 subject, title, description 및 cards 배열이 포함됩니다.

수식 처리: 카드 콘텐츠는 LaTeX 문자열로 저장되며, 렌더링 시 flutter_tex를 사용합니다.

## 3. 기술 아키텍처 및 상태 관리

### 3.1 프레임워크 및 라이브러리

- 프레임워크: Flutter (생산성 및 크로스 플랫폼)

- 수식 렌더링: flutter_tex

- 상태 관리: Riverpod

### 3.2 Riverpod 상태 관리 전략

- 상태 유형

- Riverpod Provider

- 역할 및 목적

- 비동기 데이터 로딩

- FutureProvider

- decks.json 파일을 읽고, 모든 덱 데이터를 비동기로 로드하며 로딩/에러 상태를 관리합니다. (data_loader.dart)

- 덱 선택 상태

- StateProvider<Deck?>

- 현재 사용자가 학습을 위해 선택한 덱 객체를 저장합니다.

- 학습 진행 상태

- StateNotifierProvider

- StudyScreen 내부에서 현재 카드 인덱스, 카드 앞/뒤 상태를 관리합니다. (MVP 이후 적용)

### 3.3 데이터 로딩 서비스 (lib/services/data_loader.dart) 구현

- 앱에 내장된 JSON 데이터를 로드하고 Dart 객체(Deck 리스트)로 변환하는 핵심 로직입니다. Riverpod의 FutureProvider를 사용하여 UI 레이어에서 비동기 데이터의 로딩, 성공, 실패 상태를 쉽게 처리할 수 있습니다.

````dart // lib/services/data_loader.dart

import 'dart:convert'; import 'package:flutter/services.dart' show rootBundle; import 'package:flutter_riverpod/flutter_riverpod.dart'; import '../models/deck.dart';

// Riverpod: 앱 전체에서 모든 덱 데이터를 비동기로 로드하고 제공하는 FutureProvider final allDecksProvider = FutureProvider<List<Deck>>((ref) async { return DataLoader.loadAllDecks(); });

/// JSON 파일을 읽고 Dart 객체로 변환하는 비즈니스 로직을 담당하는 서비스 클래스 class DataLoader { static const String _dataPath = 'assets/data/decks.json';

/// assets/data/decks.json 파일에서 모든 덱 데이터를 로드합니다. static Future<List<Deck>> loadAllDecks() async { try { // 1. JSON 파일 내용 읽기 final String response = await rootBundle.loadString(_dataPath);

  // 2. JSON 문자열을 List<Map<String, dynamic>>으로 디코딩
  final List<dynamic> jsonList = json.decode(response);

  // 3. 각 Map을 Deck 모델 객체로 변환하여 리스트로 반환
  return jsonList.map((json) => Deck.fromJson(json)).toList();

} catch (e) {
  // 로딩 중 오류 발생 시, 디버깅을 위해 오류를 출력하고 예외를 던집니다.
  print('Error loading decks from JSON: $e');
  throw Exception('Failed to load flashcard data.');
}

} } ```

## 4. UI/UX 및 디자인 시스템
### 4.1 디자인 컨셉
글래스모피즘(Glassmorphism): 모든 주요 UI 요소(카드, 목록 항목)에 반투명한 배경 블러 효과를 적용합니다.

### 4.2 3D UI:

입체감: `BoxShadow`를 사용하여 위젯에 깊이감을 주어 3D 버튼이나 떠 있는 카드와 같은 시각적 효과를 연출합니다.

카드 전환: 카드를 뒤집을 때(Flip) 3D 회전 애니메이션을 적용하여 입체감을 극대화합니다.

### 4.3 폴더 구조 (Theme / Utils 상세)
`lib/theme/`: `app_theme.dart` 파일에 기본 `ThemeData`와 함께 글래스 효과에 필요한 `kBlurRadius`, `kGlassOpacity` 등 디자인 상수들을 정의합니다.

`lib/utils/`: `ColorPalette` 클래스와 같은 재사용 가능한 상수 정의 및 헬퍼 함수를 저장합니다.

## 5. MVP 구현 계획
### 5.1 스크린

### 5.2 핵심 기능 및 디자인 적용

### 5.3 `DeckListScreen`

1. `FutureProvider`를 구독하여 덱 목록 표시.   2. 각 덱 카드는 글래스모피즘 스타일 적용 및 3D 그림자로 입체감 부여.

`StudyScreen`

1. 선택된 덱의 카드를 순환하며 표시.   2. 카드 콘텐츠는 `flutter_tex`로 렌더링.   3. 카드 터치 시 3D Flip 애니메이션을 사용하여 앞/뒤 전환.

`main.dart`

`ProviderScope` 설정 및 `app_theme.dart`의 `ThemeData` 적용.
````
