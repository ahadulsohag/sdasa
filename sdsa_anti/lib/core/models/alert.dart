import 'app_location.dart';

enum AlertSeverity { low, medium, high, critical }

class Alert {
  final String? alertID;
  final String title;
  final String description;
  final AlertSeverity severity;
  final DateTime timeStamp;
  final AppLocation? location;
  final String? disasterTypeID;
  final String? createdBy;
  final String status;

  Alert({
    this.alertID,
    required this.title,
    required this.description,
    required this.severity,
    DateTime? timeStamp,
    this.location,
    this.disasterTypeID,
    this.createdBy,
    this.status = 'active',
  }) : timeStamp = timeStamp ?? DateTime.now();

  factory Alert.fromJson(Map<String, dynamic> json) {
    return Alert(
      alertID: json['id'],
      title: json['title'],
      description: json['description'],
      severity: AlertSeverity.values.firstWhere(
        (e) => e.name == json['severity'],
        orElse: () => AlertSeverity.medium,
      ),
      timeStamp: DateTime.parse(json['timestamp']),
      location: json['locations'] != null
          ? AppLocation.fromJson(json['locations'])
          : null,
      disasterTypeID: json['disaster_type_id'],
      createdBy: json['created_by'],
      status: json['status'] ?? 'active',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (alertID != null) 'id': alertID,
      'title': title,
      'description': description,
      'severity': severity.name,
      'timestamp': timeStamp.toIso8601String(),
      if (location?.id != null) 'location_id': location!.id,
      'disaster_type_id': disasterTypeID,
      'created_by': createdBy,
      'status': status,
    };
  }
}
