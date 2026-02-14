class CandidateModel {
  final String id;
  final String fullName;
  final String summary; // Max 300 words
  final String? photoUrl;
  final String category; // President, Secretary, Treasurer
  final bool isApproved;
  final DateTime createdAt;

  CandidateModel({
    required this.id,
    required this.fullName,
    required this.summary,
    this.photoUrl,
    required this.category,
    this.isApproved = false,
    required this.createdAt,
  });

  factory CandidateModel.fromJson(Map<String, dynamic> json) {
    return CandidateModel(
      id: json['id'] as String,
      fullName: json['full_name'] as String,
      summary: json['summary'] as String,
      photoUrl: json['photo_url'] as String?,
      category: json['category'] as String,
      isApproved: json['is_approved'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'summary': summary,
      'photo_url': photoUrl,
      'category': category,
      'is_approved': isApproved,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
