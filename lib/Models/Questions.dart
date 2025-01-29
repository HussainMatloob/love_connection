class Question {
  final String id;
  final int categoryId;
  final String question;
  final List<String> options;

  Question({
    required this.id,
    required this.categoryId,
    required this.question,
    required this.options,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      categoryId: int.parse(json['categoryid']),
      question: json['question'],
      options: json['options'].split(","),
    );
  }
}
