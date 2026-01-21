import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/models/user_role.dart';
import '../../core/providers/user_provider.dart';
import '../../core/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  UserRole _selectedRole = UserRole.citizen;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkExistingSession();
  }

  Future<void> _checkExistingSession() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      setState(() => _isLoading = true);
      try {
        final profile = await _authService.getProfile(user.id);
        if (profile != null && mounted) {
          final dbRoleStr = (profile['role'] as String? ?? 'citizen')
              .trim()
              .toLowerCase();
          final dbRole = UserRole.values.firstWhere(
            (e) => e.name.toLowerCase() == dbRoleStr,
            orElse: () => UserRole.citizen,
          );
          context.read<UserProvider>().setRole(dbRole);
          context.go('/home');
        } else if (mounted) {
          // If logged in but no profile, maybe sign out to be safe or just stay on login
          await _authService.signOut();
        }
      } catch (e) {
        // Silently fail and show login screen
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _login() async {
    setState(() => _isLoading = true);
    try {
      final response = await _authService.login(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final user = response.user;
      if (user != null && mounted) {
        // Wait a small moment for DB sync/triggers
        await Future.delayed(const Duration(milliseconds: 500));

        // Fetch profile to verify role
        final profile = await _authService.getProfile(user.id);

        if (profile == null) {
          await _authService.signOut();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Profile not found! Please ensure your account is properly registered.',
                ),
                backgroundColor: Colors.orange,
                duration: Duration(seconds: 5),
              ),
            );
          }
          setState(() => _isLoading = false);
          return;
        }

        final dbRoleStr = (profile['role'] as String? ?? 'citizen')
            .trim()
            .toLowerCase();
        final dbRole = UserRole.values.firstWhere(
          (e) => e.name.toLowerCase() == dbRoleStr,
          orElse: () => UserRole.citizen,
        );

        // Update global state and navigate
        if (mounted) {
          context.read<UserProvider>().setRole(dbRole);
          context.go('/home');
        }
      }
    } on PostgrestException catch (e) {
      if (mounted) {
        String message = e.message;
        if (message.contains('profiles') &&
            message.contains('does not exist')) {
          message =
              'Critical Error: The "profiles" table is missing in Supabase.';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 10),
          ),
        );
      }
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Color get _themeColor {
    switch (_selectedRole) {
      case UserRole.volunteer:
        return Colors.green;
      case UserRole.authority:
        return Colors.indigo;
      case UserRole.citizen:
        return const Color(0xFFD32F2F); // Red
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [_themeColor, Colors.black87],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              color: Colors.white.withAlpha(230), // 0.9 opacity
              child: Padding(
                padding: EdgeInsets.all(
                  MediaQuery.of(context).size.width < 400 ? 16 : 32,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            'icon/Untitled design.png',
                            height: 100,
                            width: 100,
                            fit: BoxFit.contain,
                          ),
                        )
                        .animate(key: ValueKey(_selectedRole))
                        .scale(duration: 300.ms, curve: Curves.elasticOut),
                    const SizedBox(height: 20),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        '${_selectedRole.name.toUpperCase()} LOGIN',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: SegmentedButton<UserRole>(
                        segments: const [
                          ButtonSegment(
                            value: UserRole.citizen,
                            label: Text('Citizen'),
                            icon: Icon(Icons.person),
                          ),
                          ButtonSegment(
                            value: UserRole.volunteer,
                            label: Text('Volunteer'),
                            icon: Icon(Icons.handshake),
                          ),
                          ButtonSegment(
                            value: UserRole.authority,
                            label: Text('Authority'),
                            icon: Icon(Icons.account_balance),
                          ),
                        ],
                        selected: {_selectedRole},
                        onSelectionChanged: (Set<UserRole> newSelection) {
                          setState(() {
                            _selectedRole = newSelection.first;
                          });
                        },
                        style: const ButtonStyle(
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: const Icon(Icons.email_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _themeColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                'LOGIN',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () =>
                          context.push('/register?role=${_selectedRole.name}'),
                      child: Text(
                        "Don't have an account? Register here",
                        style: TextStyle(color: _themeColor.withAlpha(204)),
                      ),
                    ),
                  ],
                ),
              ),
            ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.1, end: 0),
          ),
        ),
      ),
    );
  }
}
