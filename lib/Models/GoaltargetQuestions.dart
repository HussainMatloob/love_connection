class GoaltargetQuestions {
  final String id;
  final int categoryId;
  final String question;
  final List<String> options;

  GoaltargetQuestions({
    required this.id,
    required this.categoryId,
    required this.question,
    required this.options,
  });

  factory GoaltargetQuestions.fromJson(Map<String, dynamic> json) {
    return GoaltargetQuestions(
      id: json['id'],
      categoryId: int.parse(json['categoryid']),
      question: json['question'],
      options: json['options'].split("/"),
    );
  }
}
