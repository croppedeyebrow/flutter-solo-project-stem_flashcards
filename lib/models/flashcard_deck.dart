import 'flashcard.dart';

class FlashcardDeck {
  final String id;
  final String title;
  final String description;
  final String subject;
  final String difficulty;
  final String icon;
  final List<Flashcard> cards;
  final int totalCards;
  final String? color;

  const FlashcardDeck({
    required this.id,
    required this.title,
    required this.description,
    required this.subject,
    required this.difficulty,
    required this.icon,
    required this.cards,
    required this.totalCards,
    this.color,
  });

  factory FlashcardDeck.fromJson(Map<String, dynamic> json) {
    return FlashcardDeck(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      subject: json['subject'] as String,
      difficulty: json['difficulty'] as String,
      icon: json['icon'] as String,
      totalCards: json['totalCards'] as int,
      color: json['color'] as String?,
      cards: (json['cards'] as List<dynamic>)
          .map((cardJson) =>
              Flashcard.fromJson(cardJson as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'subject': subject,
      'difficulty': difficulty,
      'icon': icon,
      'totalCards': totalCards,
      'color': color,
      'cards': cards.map((card) => card.toJson()).toList(),
    };
  }

  FlashcardDeck copyWith({
    String? id,
    String? title,
    String? description,
    String? subject,
    String? difficulty,
    String? icon,
    List<Flashcard>? cards,
    int? totalCards,
    String? color,
  }) {
    return FlashcardDeck(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      subject: subject ?? this.subject,
      difficulty: difficulty ?? this.difficulty,
      icon: icon ?? this.icon,
      cards: cards ?? this.cards,
      totalCards: totalCards ?? this.totalCards,
      color: color ?? this.color,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FlashcardDeck && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'FlashcardDeck(id: $id, title: $title, totalCards: $totalCards)';
  }
}
