import 'package:supabase_flutter/supabase_flutter.dart';

class VotingService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Cast a vote for a candidate
  Future<void> castVote({
    required String userId,
    required String candidateId,
    required String category,
  }) async {
    try {
      // The database trigger will handle the "one vote per flat" logic
      // and RLS handles the "one vote per user per category" logic
      await _supabase.from('votes').insert({
        'user_id': userId,
        'candidate_id': candidateId,
        'category': category,
      });

      // Optionally update user voting status
      await _supabase
          .from('users')
          .update({'has_voted': true})
          .eq('id', userId);
    } catch (e) {
      if (e.toString().contains('already voted')) {
        throw Exception('Your flat has already voted in this category');
      }
      throw Exception('Failed to cast vote: $e');
    }
  }

  /// Get live vote counts for a category
  Stream<List<Map<String, dynamic>>> getVoteCountsStream(String category) {
    return _supabase
        .from('votes')
        .stream(primaryKey: ['id'])
        .eq('category', category)
        .map((data) {
          // Process stream data to count votes per candidate
          final counts = <String, int>{};
          for (var vote in data) {
            final candidateId = vote['candidate_id'] as String;
            counts[candidateId] = (counts[candidateId] ?? 0) + 1;
          }
          return counts.entries
              .map((e) => {'candidate_id': e.key, 'count': e.value})
              .toList();
        });
  }
}
