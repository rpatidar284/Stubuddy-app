class AttendanceRecord {
  final int? id;
  final int subjectId;
  final DateTime date;
  final bool isPresent;
  final String topic;

  AttendanceRecord({
    this.id,
    required this.subjectId,
    required this.date,
    required this.isPresent,
    this.topic = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'subjectId': subjectId,
      'date': date.toIso8601String(),
      'isPresent': isPresent ? 1 : 0,
      'topic': topic,
    };
  }

  factory AttendanceRecord.fromMap(Map<String, dynamic> map) {
    return AttendanceRecord(
      id: map['id'],
      subjectId: map['subjectId'],
      date: DateTime.parse(map['date']),
      isPresent: map['isPresent'] == 1,
      topic: map['topic'],
    );
  }
}
