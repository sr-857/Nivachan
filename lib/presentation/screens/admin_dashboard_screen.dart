import 'package:flutter/material.dart';
import 'pending_candidates_screen.dart';
import 'vote_monitoring_screen.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _AdminCard(
              title: 'Candidate Approvals',
              icon: Icons.person_add,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PendingCandidatesScreen())),
            ),
            _AdminCard(
              title: 'Vote Monitoring',
              icon: Icons.poll,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const VoteMonitoringScreen())),
            ),
            _AdminCard(
              title: 'Audit Logs',
              icon: Icons.history,
              onTap: () {}, // To be implemented
            ),
            _AdminCard(
              title: 'Settings',
              icon: Icons.settings,
              onTap: () {}, // To be implemented
            ),
          ],
        ),
      ),
    );
  }
}

class _AdminCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _AdminCard({required this.title, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: Colors.blue),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
