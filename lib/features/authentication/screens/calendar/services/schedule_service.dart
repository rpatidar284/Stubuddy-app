import 'package:intl/intl.dart';
import 'package:stu_buddy/features/authentication/screens/calendar/models/schedule_event_model.dart';
import 'package:stu_buddy/utils/local_storage/SQLite.dart';

class ScheduleService {
  final DBHelper _dbHelper = DBHelper.getInstance;

  Future<int> insertEvent(ScheduleEventModel event) async {
    return await _dbHelper.insertScheduleEvent(event.toMap());
  }

  Future<List<ScheduleEventModel>> getEventsForDate(DateTime date) async {
    final String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    final List<Map<String, dynamic>> maps = await _dbHelper.getEventsByDate(
      formattedDate,
    );
    return List.generate(
      maps.length,
      (i) => ScheduleEventModel.fromMap(maps[i]),
    );
  }

  // NEW: Method to get all events for the calendar indicator
  Future<List<ScheduleEventModel>> getAllEvents() async {
    final List<Map<String, dynamic>> maps =
        await _dbHelper.getAllScheduleEvents();
    return List.generate(
      maps.length,
      (i) => ScheduleEventModel.fromMap(maps[i]),
    );
  }

  Future<int> deleteEvent(int id) async {
    return await _dbHelper.deleteScheduleEvent(id);
  }
}
