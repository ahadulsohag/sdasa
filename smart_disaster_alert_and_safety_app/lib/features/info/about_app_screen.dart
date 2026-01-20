import 'package:flutter/material.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About SDASA')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Image.asset('icon/Untitled design.png', height: 120)),
            const SizedBox(height: 32),
            Text(
              'Smart Disaster Alert & Safety App (SDASA)',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.red.shade800,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'SDASA is a state-of-the-art disaster management system designed to bridge the gap between citizens, volunteers, and emergency services during critical events.',
              style: TextStyle(fontSize: 16, height: 1.6),
            ),
            const SizedBox(height: 24),
            _buildFeatureItem(
              context,
              Icons.notifications_active,
              'Real-time Alerts',
              'Stay informed with instant push notifications about local disasters.',
            ),
            _buildFeatureItem(
              context,
              Icons.sos,
              'Emergency SOS',
              'One-tap SOS signal to alert rescuers of your exact location.',
            ),
            _buildFeatureItem(
              context,
              Icons.people,
              'Volunteer Network',
              'Mobilizing trained volunteers to provide support where it is needed most.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(
    BuildContext context,
    IconData icon,
    String title,
    String desc,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.red.shade700, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  desc,
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
