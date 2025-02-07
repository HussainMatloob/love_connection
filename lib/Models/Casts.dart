class Cast {
  final String id;
  final String religion;
  final String cast;
  final String sect;
  final String createdAt;

  Cast({
    required this.id,
    required this.religion,
    required this.cast,
    required this.sect,
    required this.createdAt,
  });

  factory Cast.fromJson(Map<String, dynamic> json) {
    return Cast(
      id: json['id'] as String,
      religion: json['religion'] as String,
      cast: json['cast'] as String,
      sect: json['sect'] as String,
      createdAt: json['created_at'] as String,
    );
  }
}
