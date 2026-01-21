import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/models/user_role.dart';
import '../../core/providers/user_provider.dart';
import '../admin/admin_dashboard.dart';
import '../volunteer/volunteer_dashboard.dart';
import 'home_screen.dart';

class MainDashboardRouter extends StatelessWidget {
  const MainDashboardRouter({super.key});

  @override
  Widget build(BuildContext context) {
    final role = context.watch<UserProvider>().role;

    switch (role) {
      case UserRole.volunteer:
        return const VolunteerDashboard();
      case UserRole.authority:
        return const AdminDashboard(); // Contains official management features
      case UserRole.citizen:
        return const HomeScreen();
    }
  }
}
