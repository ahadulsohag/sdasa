import 'package:flutter/material.dart';

class AuthorityDashboard extends StatelessWidget {
  const AuthorityDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.account_balance, size: 64, color: Colors.indigo),
            const SizedBox(height: 16),
            Text(
              'Authority Dashboard',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const Text('Official response monitoring in progress'),
          ],
        ),
      ),
    );
  }
}
