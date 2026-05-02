class Word {
  final String word;
  final String partOfSpeech;
  final String etymology;
  final String definition;
  final String example;

  const Word({
    required this.word,
    required this.partOfSpeech,
    required this.etymology,
    required this.definition,
    required this.example,
  });

  factory Word.fromJson(Map<String, dynamic> json) => Word(
        word: json['word'] as String,
        partOfSpeech: json['partOfSpeech'] as String,
        etymology: json['etymology'] as String,
        definition: json['definition'] as String,
        example: json['example'] as String,
      );
}
