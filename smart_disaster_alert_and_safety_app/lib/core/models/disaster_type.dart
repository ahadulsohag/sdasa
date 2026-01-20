class DisasterType {
  final String id;
  final String name;
  final String? description;

  DisasterType({required this.id, required this.name, this.description});

  factory DisasterType.fromJson(Map<String, dynamic> json) {
    return DisasterType(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'description': description};
  }
}
