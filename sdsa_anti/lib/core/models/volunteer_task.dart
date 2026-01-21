import 'app_location.dart';

class VolunteerTask {
  final String? taskID;
  final String? alertID;
  final String? volunteerID;
  final String? shelterID;
  final String status;
  final DateTime assignedTime;
  final DateTime? completedTime;
  final AppLocation? location;

  VolunteerTask({
    this.taskID,
    this.alertID,
    this.volunteerID,
    this.shelterID,
    this.status = 'assigned',
    DateTime? assignedTime,
    this.completedTime,
    this.location,
  }) : assignedTime = assignedTime ?? DateTime.now();

  factory VolunteerTask.fromJson(Map<String, dynamic> json) {
    return VolunteerTask(
      taskID: json['id'],
      alertID: json['alert_id'],
      volunteerID: json['volunteer_id'],
      shelterID: json['shelter_id'],
      status: json['status'],
      assignedTime: DateTime.parse(json['assigned_time']),
      completedTime: json['completed_time'] != null
          ? DateTime.parse(json['completed_time'])
          : null,
      location: json['locations'] != null
          ? AppLocation.fromJson(json['locations'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (taskID != null) 'id': taskID,
      'alert_id': alertID,
      'volunteer_id': volunteerID,
      'shelter_id': shelterID,
      'status': status,
      'assigned_time': assignedTime.toIso8601String(),
      if (completedTime != null)
        'completed_time': completedTime!.toIso8601String(),
      if (location?.id != null) 'location_id': location!.id,
    };
  }
}
