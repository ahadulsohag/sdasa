import 'dart:math';

class AppLocation {
  final String? id;
  final double latitude;
  final double longitude;
  final String? addressName;

  AppLocation({
    this.id,
    required this.latitude,
    required this.longitude,
    this.addressName,
  });

  factory AppLocation.fromJson(Map<String, dynamic> json) {
    return AppLocation(
      id: json['id'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      addressName: json['address_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'latitude': latitude,
      'longitude': longitude,
      'address_name': addressName,
    };
  }

  double getDistance(AppLocation other) {
    const p = 0.017453292519943295;
    final c = cos;
    final a =
        0.5 -
        c((other.latitude - latitude) * p) / 2 +
        c(latitude * p) *
            c(other.latitude * p) *
            (1 - c((other.longitude - longitude) * p)) /
            2;
    return 12742 * asin(sqrt(a)); // 2 * R; R = 6371 km
  }
}
