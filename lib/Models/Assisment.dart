class AssessmentCategory {
  final String id;
  final String image;
  final String title;

  AssessmentCategory({
    required this.id,
    required this.image,
    required this.title,
  });

  factory AssessmentCategory.fromJson(Map<String, dynamic> json) {
    return AssessmentCategory(
      id: json['id'],
      image: json['image'],
      title: json['title'],
    );
  }
}