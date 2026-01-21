import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/models/user_role.dart';
import '../../core/providers/user_provider.dart';
import '../../core/services/auth_service.dart';
import '../info/about_app_screen.dart';
import '../info/founders_story_screen.dart';
import '../info/safety_guides_screen.dart';

class MainShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainShell({super.key, required this.navigationShell});

  Color _getThemeColor(UserRole role) {
    switch (role) {
      case UserRole.volunteer:
        return Colors.green;
      case UserRole.authority:
        return Colors.indigo;
      case UserRole.citizen:
        return const Color(0xFFD32F2F);
    }
  }

  List<NavigationDestination> _getDestinations(UserRole role) {
    switch (role) {
      case UserRole.authority:
        return const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Manage',
          ),
          NavigationDestination(
            icon: Icon(Icons.map_outlined),
            selectedIcon: Icon(Icons.map),
            label: 'Tactical',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_alert_outlined),
            selectedIcon: Icon(Icons.add_alert),
            label: 'Publish',
          ),
          NavigationDestination(
            icon: Icon(Icons.sos_outlined, color: Colors.red),
            selectedIcon: Icon(Icons.sos, color: Colors.red),
            label: 'Monitor',
          ),
        ];
      case UserRole.volunteer:
        return const [
          NavigationDestination(
            icon: Icon(Icons.assignment_ind_outlined),
            selectedIcon: Icon(Icons.assignment_ind),
            label: 'Tasks',
          ),
          NavigationDestination(
            icon: Icon(Icons.map_outlined),
            selectedIcon: Icon(Icons.map),
            label: 'Site Map',
          ),
          NavigationDestination(
            icon: Icon(Icons.notifications_outlined),
            selectedIcon: Icon(Icons.notifications),
            label: 'Alerts',
          ),
          NavigationDestination(
            icon: Icon(Icons.volunteer_activism_outlined, color: Colors.red),
            selectedIcon: Icon(Icons.volunteer_activism, color: Colors.red),
            label: 'Respond',
          ),
        ];
      case UserRole.citizen:
        return const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.map_outlined),
            selectedIcon: Icon(Icons.map),
            label: 'Shelters',
          ),
          NavigationDestination(
            icon: Icon(Icons.notifications_outlined),
            selectedIcon: Icon(Icons.notifications),
            label: 'Alerts',
          ),
          NavigationDestination(
            icon: Icon(Icons.sos_outlined, color: Colors.red),
            selectedIcon: Icon(Icons.sos, color: Colors.red),
            label: 'SOS',
          ),
        ];
    }
  }

  String _getAppBarTitle(int index, UserRole role) {
    if (index == 0) {
      switch (role) {
        case UserRole.authority:
          return 'Command Center';
        case UserRole.volunteer:
          return 'Field Ops';
        case UserRole.citizen:
          return 'Home Dashboard';
      }
    }
    switch (index) {
      case 1:
        return 'Tactical Map';
      case 2:
        return role == UserRole.authority ? 'Alert Management' : 'Live Alerts';
      case 3:
        return role == UserRole.citizen ? 'Emergency SOS' : 'Rescue Monitor';
      default:
        return 'SDASA';
    }
  }

  @override
  Widget build(BuildContext context) {
    final role = context.watch<UserProvider>().role;
    final themeColor = _getThemeColor(role);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColor,
        foregroundColor: Colors.white,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('icon/Untitled design.png', height: 32, width: 32),
            const SizedBox(width: 8),
            Text(_getAppBarTitle(navigationShell.currentIndex, role)),
          ],
        ),
        centerTitle: true,
        elevation: 2,
      ),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [themeColor.withAlpha(204), themeColor],
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('icon/Untitled design.png', height: 60),
                    const SizedBox(height: 12),
                    Text(
                      '${role.name.toUpperCase()} MODE',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('About SDASA'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AboutAppScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.history_edu),
              title: const Text('Founders\' Story'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const FoundersStoryScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.health_and_safety_outlined),
              title: const Text('Safety Guides'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const SafetyGuidesScreen(),
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.blueGrey),
              title: const Text('Sign Out'),
              onTap: () async {
                Navigator.pop(context);
                await AuthService().signOut();
                if (context.mounted) {
                  context.read<UserProvider>().setRole(UserRole.citizen);
                  context.go('/login');
                }
              },
            ),
            const Spacer(),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'v1.0.0',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        destinations: _getDestinations(role),
      ),
    );
  }
}
