import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../widgets/custom_button.dart';

/// Shown right after a successful sign-in or sign-up. This is a minimal
/// landing screen for this module's deliverable; merge it with your
/// existing shopping-app Home Screen from the Widgets module as needed.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final signedInEmail = authService.currentUser?.email ?? 'Shopper';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            tooltip: 'Sign out',
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authService.signOut();
              if (context.mounted) {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/login', (_) => false);
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Welcome, $signedInEmail!',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            CustomButton(
              label: 'Add My Data',
              onPressed: () => Navigator.of(context).pushNamed('/add-data'),
            ),
            const SizedBox(height: 12),
            CustomButton(
              label: 'View Saved Data',
              isOutlined: true,
              onPressed: () => Navigator.of(context).pushNamed('/display-data'),
            ),
          ],
        ),
      ),
    );
  }
}
