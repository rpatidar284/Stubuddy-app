import 'package:stu_buddy/utils/local_storage/SQLite.dart';

class ScheduleEventModel {
  int? id;
  String subject;
  String tag;
  String startTime;
  String endTime;
  String date;
  String room;
  String instructor;

  ScheduleEventModel({
    this.id,
    required this.subject,
    required this.tag,
    required this.startTime,
    required this.endTime,
    required this.date,
    required this.room,
    required this.instructor,
  });

  factory ScheduleEventModel.fromMap(Map<String, dynamic> map) {
    return ScheduleEventModel(
      id: map[DBHelper.COL_EVENT_ID],
      subject: map[DBHelper.COL_EVENT_SUBJECT],
      tag: map[DBHelper.COL_EVENT_TAG],
      startTime: map[DBHelper.COL_EVENT_START_TIME],
      endTime: map[DBHelper.COL_EVENT_END_TIME],
      date: map[DBHelper.COL_EVENT_DATE],
      room: map[DBHelper.COL_EVENT_ROOM],
      instructor: map[DBHelper.COL_EVENT_INSTRUCTOR],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) DBHelper.COL_EVENT_ID: id,
      DBHelper.COL_EVENT_SUBJECT: subject,
      DBHelper.COL_EVENT_TAG: tag,
      DBHelper.COL_EVENT_START_TIME: startTime,
      DBHelper.COL_EVENT_END_TIME: endTime,
      DBHelper.COL_EVENT_DATE: date,
      DBHelper.COL_EVENT_ROOM: room,
      DBHelper.COL_EVENT_INSTRUCTOR: instructor,
    };
  }
}
