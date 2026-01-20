import 'app_location.dart';

class SoSRequest {
  final String? requestID;
  final String? userID;
  final String status;
  final DateTime timestamp;
  final AppLocation? location;

  SoSRequest({
    this.requestID,
    this.userID,
    this.status = 'pending',
    DateTime? timestamp,
    this.location,
  }) : timestamp = timestamp ?? DateTime.now();

  factory SoSRequest.fromJson(Map<String, dynamic> json) {
    return SoSRequest(
      requestID: json['id'],
      userID: json['user_id'],
      status: json['status'],
      timestamp: DateTime.parse(json['timestamp']),
      location: json['locations'] != null
          ? AppLocation.fromJson(json['locations'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (requestID != null) 'id': requestID,
      'user_id': userID,
      'status': status,
      'timestamp': timestamp.toIso8601String(),
      if (location?.id != null) 'location_id': location!.id,
    };
  }
}
