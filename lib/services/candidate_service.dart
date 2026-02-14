import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/models/candidate_model.dart';
import '../core/constants/supabase_constants.dart';

class CandidateService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Fetch all approved candidates by category
  Future<List<CandidateModel>> getApprovedCandidates(String category) async {
    try {
      final response = await _supabase
          .from('candidates')
          .select()
          .eq('category', category)
          .eq('is_approved', true);

      return (response as List)
          .map((json) => CandidateModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch candidates: $e');
    }
  }

  /// Create a new candidate (pending approval)
  Future<void> createCandidate({
    required String fullName,
    required String summary,
    required String category,
    File? photo,
  }) async {
    try {
      String? photoUrl;

      // Upload photo if provided
      if (photo != null) {
        final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
        await _supabase.storage
            .from(SupabaseConstants.candidatePhotosBucket)
            .upload(fileName, photo);

        photoUrl = _supabase.storage
            .from(SupabaseConstants.candidatePhotosBucket)
            .getPublicUrl(fileName);
      }

      await _supabase.from('candidates').insert({
        'full_name': fullName,
        'summary': summary,
        'category': category,
        'photo_url': photoUrl,
        'is_approved': false,
      });
    } catch (e) {
      throw Exception('Failed to create candidate: $e');
    }
  }
}
