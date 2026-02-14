import 'package:flutter/material.dart';
import '../../data/models/candidate_model.dart';
import '../../services/voting_service.dart';
import '../../services/candidate_service.dart';

class VotingDashboardScreen extends StatefulWidget {
  final String userId;
  const VotingDashboardScreen({super.key, required this.userId});

  @override
  State<VotingDashboardScreen> createState() => _VotingDashboardScreenState();
}

class _VotingDashboardScreenState extends State<VotingDashboardScreen> {
  final _candidateService = CandidateService();
  final _votingService = VotingService();
  
  final Map<String, String?> _selectedCandidates = {
    'President': null,
    'Secretary': null,
    'Treasurer': null,
  };

  bool _isSubmitting = false;

  Future<void> _submitVotes() async {
    final missingCategories = _selectedCandidates.entries
        .where((e) => e.value == null)
        .map((e) => e.key)
        .toList();

    if (missingCategories.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please vote for: ${missingCategories.join(', ')}')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      for (var entry in _selectedCandidates.entries) {
        await _votingService.castVote(
          userId: widget.userId,
          candidateId: entry.value!,
          category: entry.key,
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Votes submitted successfully!'), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Voting Dashboard')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Gated Society Election',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            _buildCategorySection('President'),
            const Divider(height: 32),
            _buildCategorySection('Secretary'),
            const Divider(height: 32),
            _buildCategorySection('Treasurer'),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _isSubmitting ? null : _submitVotes,
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
              child: _isSubmitting 
                  ? const CircularProgressIndicator() 
                  : const Text('Submit All Votes', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySection(String category) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          category,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
        ),
        const SizedBox(height: 8),
        FutureBuilder<List<CandidateModel>>(
          future: _candidateService.getApprovedCandidates(category),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Text('No candidates available in this category.');
            }

            return Column(
              children: snapshot.data!.map((candidate) {
                return RadioListTile<String>(
                  title: Text(candidate.fullName),
                  subtitle: Text(candidate.summary),
                  value: candidate.id,
                  groupValue: _selectedCandidates[category],
                  onChanged: (value) {
                    setState(() => _selectedCandidates[category] = value);
                  },
                  secondary: candidate.photoUrl != null 
                      ? CircleAvatar(backgroundImage: NetworkImage(candidate.photoUrl!))
                      : const CircleAvatar(child: Icon(Icons.person)),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}
