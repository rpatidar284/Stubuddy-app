class Subject {
  final int? id;
  final String name;
  final String code;
  final int totalClasses;
  final int attendedClasses;
  final int credits;

  Subject({
    this.id,
    required this.name,
    required this.code,
    this.totalClasses = 0,
    this.attendedClasses = 0,
    required this.credits,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'totalClasses': totalClasses,
      'attendedClasses': attendedClasses,
      'credits': credits,
    };
  }

  factory Subject.fromMap(Map<String, dynamic> map) {
    return Subject(
      id: map['id'],
      name: map['name'],
      code: map['code'],
      totalClasses: map['totalClasses'],
      attendedClasses: map['attendedClasses'],
      credits: map['credits'],
    );
  }
}
