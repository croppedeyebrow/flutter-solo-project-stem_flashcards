class Flashcard {
  final String id;
  final String front;
  final String back;
  final String? latexFront;
  final String? latexBack;
  final String? subject;
  final String? difficulty;

  const Flashcard({
    required this.id,
    required this.front,
    required this.back,
    this.latexFront,
    this.latexBack,
    this.subject,
    this.difficulty,
  });

  factory Flashcard.fromJson(Map<String, dynamic> json) {
    return Flashcard(
      id: json['id'] as String,
      front: json['front'] as String,
      back: json['back'] as String,
      latexFront: json['latexFront'] as String?,
      latexBack: json['latexBack'] as String?,
      subject: json['subject'] as String?,
      difficulty: json['difficulty'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'front': front,
      'back': back,
      'latexFront': latexFront,
      'latexBack': latexBack,
      'subject': subject,
      'difficulty': difficulty,
    };
  }

  Flashcard copyWith({
    String? id,
    String? front,
    String? back,
    String? latexFront,
    String? latexBack,
    String? subject,
    String? difficulty,
  }) {
    return Flashcard(
      id: id ?? this.id,
      front: front ?? this.front,
      back: back ?? this.back,
      latexFront: latexFront ?? this.latexFront,
      latexBack: latexBack ?? this.latexBack,
      subject: subject ?? this.subject,
      difficulty: difficulty ?? this.difficulty,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Flashcard && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Flashcard(id: $id, front: $front, back: $back)';
  }
}
