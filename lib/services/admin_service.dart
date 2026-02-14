import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/models/candidate_model.dart';

class AdminService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Check if user has admin privileges
  Future<bool> isAdmin(String userId) async {
    try {
      final response = await _supabase
          .from('admin_roles')
          .select()
          .eq('user_id', userId)
          .maybeSingle();

      return response != null;
    } catch (e) {
      return false;
    }
  }

  /// Approve a candidate
  Future<void> approveCandidate(String candidateId) async {
    try {
      await _supabase
          .from('candidates')
          .update({'is_approved': true})
          .eq('id', candidateId);
      
      await _logAction('APPROVE_CANDIDATE', 'candidate', candidateId);
    } catch (e) {
      throw Exception('Failed to approve candidate: $e');
    }
  }

  /// Delete a candidate or rejectapplication
  Future<void> deleteCandidate(String candidateId) async {
    try {
      await _supabase
          .from('candidates')
          .delete()
          .eq('id', candidateId);
      
      await _logAction('DELETE_CANDIDATE', 'candidate', candidateId);
    } catch (e) {
      throw Exception('Failed to delete candidate: $e');
    }
  }

  /// Delete a vote (admin override)
  Future<void> deleteVote(String voteId) async {
    try {
      await _supabase
          .from('votes')
          .delete()
          .eq('id', voteId);
      
      await _logAction('DELETE_VOTE', 'vote', voteId);
    } catch (e) {
      throw Exception('Failed to delete vote: $e');
    }
  }

  /// Private helper to log admin actions
  Future<void> _logAction(String action, String targetType, String targetId) async {
    final user = _supabase.auth.currentUser;
    if (user != null) {
      await _supabase.from('admin_logs').insert({
        'admin_id': user.id,
        'action': action,
        'target_type': targetType,
        'target_id': targetId,
      });
    }
  }
}
