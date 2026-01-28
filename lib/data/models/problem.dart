class Problem {
  final String id;
  final String description;
  final String subject;
  final String imagePath;
  final DateTime createdAt;

  Problem({
    required this.id,
    required this.description,
    required this.subject,
    required this.imagePath,
    required this.createdAt,
  });

  factory Problem.fromJson(Map<String, dynamic> json) {
    return Problem(
      id: json['id'] as String,
      description: json['description'] as String,
      subject: json['subject'] as String,
      imagePath: json['imagePath'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'subject': subject,
      'imagePath': imagePath,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
