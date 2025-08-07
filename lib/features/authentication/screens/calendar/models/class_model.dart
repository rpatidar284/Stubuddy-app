import 'package:stu_buddy/utils/local_storage/SQLite.dart';

class TimetableModel {
  int? id;
  String subject;
  String time;
  String room;
  String instructor;
  String day;
  String subjectTag;

  TimetableModel({
    this.id,
    required this.subject,
    required this.time,
    required this.room,
    required this.instructor,
    required this.day,
    required this.subjectTag,
  });

  factory TimetableModel.fromMap(Map<String, dynamic> map) {
    return TimetableModel(
      id: map[DBHelper.COL_CLASS_ID],
      subject: map[DBHelper.COL_CLASS_SUBJECT],
      time: map[DBHelper.COL_CLASS_TIME],
      room: map[DBHelper.COL_CLASS_ROOM],
      instructor: map[DBHelper.COL_CLASS_INSTRUCTOR],
      day: map[DBHelper.COL_CLASS_DAY],
      subjectTag: map[DBHelper.COL_CLASS_SUBJECT_TAG] ?? 'General',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) DBHelper.COL_CLASS_ID: id,
      DBHelper.COL_CLASS_SUBJECT: subject,
      DBHelper.COL_CLASS_TIME: time,
      DBHelper.COL_CLASS_ROOM: room,
      DBHelper.COL_CLASS_INSTRUCTOR: instructor,
      DBHelper.COL_CLASS_DAY: day,
      DBHelper.COL_CLASS_SUBJECT_TAG: subjectTag,
    };
  }
}
