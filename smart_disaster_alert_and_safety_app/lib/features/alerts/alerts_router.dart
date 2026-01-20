import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/models/user_role.dart';
import '../../core/providers/user_provider.dart';
import 'alert_list_screen.dart';
import 'create_alert_screen.dart';

class AlertsRouter extends StatelessWidget {
  const AlertsRouter({super.key});

  @override
  Widget build(BuildContext context) {
    final role = context.watch<UserProvider>().role;

    switch (role) {
      case UserRole.authority:
        return const CreateAlertScreen();
      case UserRole.volunteer:
      case UserRole.citizen:
        return const AlertListScreen();
    }
  }
}
