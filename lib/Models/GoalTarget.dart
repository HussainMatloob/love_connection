class GoalTarget {
  final String id;
  final String image;
  final String title;
  final String createdBy;
  final String createdAt;
  final String imageUrl;

  GoalTarget({
    required this.id,
    required this.image,
    required this.title,
    required this.createdBy,
    required this.createdAt,
    required this.imageUrl,
  });

  factory GoalTarget.fromJson(Map<String, dynamic> json) {
    return GoalTarget(
      id: json['id'],
      image: json['image'] ?? '',
      title: json['title'] ?? '',
      createdBy: json['createdby'] ?? '',
      createdAt: json['createdat'] ?? '',
      imageUrl: json['image_url'] ?? '',
    );
  }
}
