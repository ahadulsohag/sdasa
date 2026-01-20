import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_role.dart';

class AuthService {
  final _supabase = Supabase.instance.client;

  // Sign up with Role
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String fullName,
    required String phone,
    required UserRole role,
    String? address,
    String? organizationName,
  }) async {
    final response = await _supabase.auth.signUp(
      email: email,
      password: password,
      data: {
        'full_name': fullName,
        'phone_number': phone,
        'role': role.name,
        if (address != null) 'address': address,
        if (organizationName != null) 'organization_name': organizationName,
      },
    );

    if (response.user != null) {
      try {
        await _supabase.from('profiles').upsert({
          'id': response.user!.id,
          'full_name': fullName,
          'phone_number': phone,
          'role': role.name,
          if (address != null) 'address': address,
          if (organizationName != null) 'organization_name': organizationName,
        });
      } catch (e) {
        // Ignore RLS/Permission errors here; the SQL trigger will handle it
      }
    }

    return response;
  }

  // Login
  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // Logout
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  // Get current user profile with role-specific data
  Future<Map<String, dynamic>?> getProfile(String userId) async {
    final response = await _supabase
        .from('profiles')
        .select('*, volunteers(*), authorities(*)')
        .eq('id', userId)
        .maybeSingle();

    if (response == null) return null;

    // Flatten role-specific data for easier model parsing
    final result = Map<String, dynamic>.from(response);

    if (response['volunteers'] != null) {
      final List vList = response['volunteers'] as List;
      if (vList.isNotEmpty) {
        result.addAll(Map<String, dynamic>.from(vList.first));
      }
    }

    if (response['authorities'] != null) {
      final List aList = response['authorities'] as List;
      if (aList.isNotEmpty) {
        result.addAll(Map<String, dynamic>.from(aList.first));
      }
    }

    return result;
  }
}
