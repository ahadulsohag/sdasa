enum AlertSeverity { low, medium, high, critical }

enum AlertType { flood, earthquake, fire, cyclone, tsunami, other }

class AlertModel {
  final String id;
  final String title;
  final String description;
  final AlertSeverity severity;
  final AlertType type;
  final DateTime timestamp;
  final String location;
  final double? latitude;
  final double? longitude;

  AlertModel({
    required this.id,
    required this.title,
    required this.description,
    required this.severity,
    required this.type,
    required this.timestamp,
    required this.location,
    this.latitude,
    this.longitude,
  });

  factory AlertModel.fromJson(Map<String, dynamic> json) {
    return AlertModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      severity: AlertSeverity.values.firstWhere(
        (e) => e.name == json['severity'],
        orElse: () => AlertSeverity.medium,
      ),
      type: AlertType.other, // Add type column later if needed
      timestamp: DateTime.parse(json['created_at']),
      location: json['location'],
      // latitude: (json['latitude'] as num?)?.toDouble(),
      // longitude: (json['longitude'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'severity': severity.name,
      'location': location,
      'created_at': timestamp.toIso8601String(),
    };
  }

  // Mock factory for generating sample data
  factory AlertModel.mock(int index) {
    return AlertModel(
      id: "alert_$index",
      title: "Disaster Alert #$index",
      description:
          "This is a detailed description of the disaster alert. Please take necessary precautions and stay safe. Follow official instructions.",
      severity: AlertSeverity.values[index % AlertSeverity.values.length],
      type: AlertType.values[index % AlertType.values.length],
      timestamp: DateTime.now().subtract(Duration(hours: index * 2)),
      location: "District ${index + 1}, Region A",
      latitude: 23.8103 + (index * 0.01),
      longitude: 90.4125 + (index * 0.01),
    );
  }
}
