import 'user_role.dart';

class AppUser {
  final String userID;
  final String name;
  final String email;
  final String? phone;
  final String? address;
  final UserRole role;

  AppUser({
    required this.userID,
    required this.name,
    required this.email,
    this.phone,
    this.address,
    required this.role,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    final roleStr = json['role'] as String? ?? 'citizen';
    final role = UserRole.values.firstWhere(
      (e) => e.name == roleStr,
      orElse: () => UserRole.citizen,
    );

    switch (role) {
      case UserRole.volunteer:
        return Volunteer.fromJson(json);
      case UserRole.authority:
        return Authority.fromJson(json);
      case UserRole.citizen:
        return AppUser(
          userID: json['id'],
          name: json['full_name'],
          email: json['email'] ?? '',
          phone: json['phone_number'],
          address: json['address'],
          role: role,
        );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': userID,
      'full_name': name,
      'email': email,
      'phone_number': phone,
      'address': address,
      'role': role.name,
    };
  }
}

class Volunteer extends AppUser {
  final bool availabilityStatus;
  final List<String> skills;

  Volunteer({
    required super.userID,
    required super.name,
    required super.email,
    super.phone,
    super.address,
    this.availabilityStatus = true,
    this.skills = const [],
  }) : super(role: UserRole.volunteer);

  factory Volunteer.fromJson(Map<String, dynamic> json) {
    return Volunteer(
      userID: json['id'],
      name: json['full_name'],
      email: json['email'] ?? '',
      phone: json['phone_number'],
      address: json['address'],
      availabilityStatus: json['availability_status'] ?? true,
      skills: json['skills'] != null ? List<String>.from(json['skills']) : [],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'availability_status': availabilityStatus,
      'skills': skills,
    };
  }
}

class Authority extends AppUser {
  final String? organizationName;
  final String? authorityBadgeID;

  Authority({
    required super.userID,
    required super.name,
    required super.email,
    super.phone,
    super.address,
    this.organizationName,
    this.authorityBadgeID,
  }) : super(role: UserRole.authority);

  factory Authority.fromJson(Map<String, dynamic> json) {
    return Authority(
      userID: json['id'],
      name: json['full_name'],
      email: json['email'] ?? '',
      phone: json['phone_number'],
      address: json['address'],
      organizationName: json['organization_name'],
      authorityBadgeID: json['authority_badge_id'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'organization_name': organizationName,
      'authority_badge_id': authorityBadgeID,
    };
  }
}
