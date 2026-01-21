import 'app_location.dart';

class Shelter {
  final String? shelterID;
  final String name;
  final int capacity;
  final int currentOccupancy;
  final String status;
  final AppLocation? location;

  Shelter({
    this.shelterID,
    required this.name,
    required this.capacity,
    this.currentOccupancy = 0,
    this.status = 'open',
    this.location,
  });

  factory Shelter.fromJson(Map<String, dynamic> json) {
    return Shelter(
      shelterID: json['id'],
      name: json['name'],
      capacity: json['capacity'],
      currentOccupancy: json['current_occupancy'],
      status: json['status'],
      location: json['locations'] != null
          ? AppLocation.fromJson(json['locations'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (shelterID != null) 'id': shelterID,
      'name': name,
      'capacity': capacity,
      'current_occupancy': currentOccupancy,
      'status': status,
      if (location?.id != null) 'location_id': location!.id,
    };
  }

  int getAvailableSlots() => capacity - currentOccupancy;
}
