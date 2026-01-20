import 'package:flutter/material.dart';

class SOSScreen extends StatelessWidget {
  const SOSScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade50,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.emergency_share, size: 100, color: Colors.red),
            const SizedBox(height: 20),
            Text(
              'SOS Activated!',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text('Broadcasting location to rescuers...'),
          ],
        ),
      ),
    );
  }
}
