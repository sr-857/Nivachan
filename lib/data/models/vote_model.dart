class VoteModel {
  final String id;
  final String userId;
  final String candidateId;
  final String category;
  final DateTime createdAt;

  VoteModel({
    required this.id,
    required this.userId,
    required this.candidateId,
    required this.category,
    required this.createdAt,
  });

  factory VoteModel.fromJson(Map<String, dynamic> json) {
    return VoteModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      candidateId: json['candidate_id'] as String,
      category: json['category'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'candidate_id': candidateId,
      'category': category,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
