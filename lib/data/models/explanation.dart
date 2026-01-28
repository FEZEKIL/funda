class Explanation {
  final String id;
  final String problemId;
  final List<Step> steps;
  final String? finalAnswer;
  final List<String> hints;
  final DateTime createdAt;

  Explanation({
    required this.id,
    required this.problemId,
    required this.steps,
    this.finalAnswer,
    required this.hints,
    required this.createdAt,
  });

  factory Explanation.fromJson(Map<String, dynamic> json) {
    return Explanation(
      id: json['id'] as String,
      problemId: json['problemId'] as String,
      steps: (json['steps'] as List<dynamic>)
          .map((step) => Step.fromJson(step as Map<String, dynamic>))
          .toList(),
      finalAnswer: json['finalAnswer'] as String?,
      hints: List<String>.from(json['hints'] as List),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'problemId': problemId,
      'steps': steps.map((step) => step.toJson()).toList(),
      'finalAnswer': finalAnswer,
      'hints': hints,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

class Step {
  final int number;
  final String title;
  final String explanation;
  final String? formula;
  final String? calculation;

  Step({
    required this.number,
    required this.title,
    required this.explanation,
    this.formula,
    this.calculation,
  });

  factory Step.fromJson(Map<String, dynamic> json) {
    return Step(
      number: json['number'] as int,
      title: json['title'] as String,
      explanation: json['explanation'] as String,
      formula: json['formula'] as String?,
      calculation: json['calculation'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'title': title,
      'explanation': explanation,
      'formula': formula,
      'calculation': calculation,
    };
  }
}
