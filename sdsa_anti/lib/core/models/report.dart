class Report {
  final String? reportID;
  final String type;
  final Map<String, dynamic> data;
  final String? adminID;
  final DateTime generateDate;

  Report({
    this.reportID,
    required this.type,
    required this.data,
    this.adminID,
    DateTime? generateDate,
  }) : generateDate = generateDate ?? DateTime.now();

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      reportID: json['id'],
      type: json['type'],
      data: json['data'] as Map<String, dynamic>,
      adminID: json['admin_id'],
      generateDate: DateTime.parse(json['generated_date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (reportID != null) 'id': reportID,
      'type': type,
      'data': data,
      'admin_id': adminID,
      'generated_date': generateDate.toIso8601String(),
    };
  }
}
