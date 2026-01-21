import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/models/user_role.dart';
import '../../core/providers/user_provider.dart';
import 'sos_screen.dart';
import '../admin/sos_management_screen.dart';

class SOSRouter extends StatelessWidget {
  const SOSRouter({super.key});

  @override
  Widget build(BuildContext context) {
    final role = context.watch<UserProvider>().role;

    switch (role) {
      case UserRole.authority:
      case UserRole.volunteer:
        return const SosManagementScreen();
      case UserRole.citizen:
        return const SOSScreen();
    }
  }
}
