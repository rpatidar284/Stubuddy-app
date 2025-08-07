import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

class DBHelper {
  DBHelper._();
  static final DBHelper getInstance = DBHelper._();

  static const String TABLE_USERS = "users";
  static const String COL_USER_ID = "id";
  static const String COL_USER_FIRST_NAME = "firstName";
  static const String COL_USER_LAST_NAME = "lastName";
  static const String COL_USER_USERNAME = "username";
  static const String COL_USER_EMAIL = "email";
  static const String COL_USER_PHONE_NUM = "phoneNum";
  static const String COL_USER_PROFILE_PICTURE = "profilePicture";

  static const String TABLE_CLASS = "class_table";
  static const String COL_CLASS_ID = "id";
  static const String COL_CLASS_SUBJECT = "subject";
  static const String COL_CLASS_TIME = "time";
  static const String COL_CLASS_ROOM = "room";
  static const String COL_CLASS_INSTRUCTOR = "instructor";
  static const String COL_CLASS_DAY = "day";
  static const String COL_CLASS_SUBJECT_TAG = "subjectTag";

  static const String TABLE_SCHEDULE_EVENTS = "schedule_events";
  static const String COL_EVENT_ID = "id";
  static const String COL_EVENT_SUBJECT = "subject";
  static const String COL_EVENT_TAG = "tag";
  static const String COL_EVENT_START_TIME = "startTime";
  static const String COL_EVENT_END_TIME = "endTime";
  static const String COL_EVENT_DATE = "date";
  static const String COL_EVENT_ROOM = "room";
  static const String COL_EVENT_INSTRUCTOR = "instructor";

  static const String TABLE_SUBJECTS = "subjects";
  static const String COL_SUB_ID = "id";
  static const String COL_SUB_NAME = "name";
  static const String COL_SUB_CODE = "code";
  static const String COL_SUB_TOTAL_CLASSES = "totalClasses";
  static const String COL_SUB_ATTENDED_CLASSES = "attendedClasses";
  static const String COL_SUB_CREDITS = "credits";

  static const String TABLE_ATTENDANCE = "attendance_records";
  static const String COL_ATT_ID = "id";
  static const String COL_ATT_SUBJECT_ID = "subjectId";
  static const String COL_ATT_DATE = "date";
  static const String COL_ATT_IS_PRESENT = "isPresent";
  static const String COL_ATT_TOPIC = "topic";

  static const String TABLE_TASKS = "tasks";
  static const String COL_TASK_ID = "id";
  static const String COL_TASK_TITLE = "title";
  static const String COL_TASK_DESCRIPTION = "description";
  static const String COL_TASK_DUE_DATE = "dueDate";
  static const String COL_TASK_PRIORITY = "priority";
  static const String COL_TASK_SUBJECT = "subject";
  static const String COL_TASK_IS_COMPLETED = "isCompleted";
  static const String COL_TASK_CREATED_AT = "createdAt";
  static const String COL_TASK_UPDATED_AT = "updatedAt";

  static const String TABLE_GRADE_SUBJECTS = "grade_subjects";
  static const String COL_GRADE_SUB_ID = "id";
  static const String COL_GRADE_SUB_NAME = "name";
  static const String COL_GRADE_SUB_TEACHER = "teacher";

  static const String TABLE_GRADES = "grades";
  static const String COL_GRADE_ID = "id";
  static const String COL_GRADE_SUBJECT_ID = "subjectId";
  static const String COL_GRADE_WEIGHTAGE = "weightage";
  static const String COL_GRADE_TOTAL_MARKS = "totalMarks";
  static const String COL_GRADE_MARKS_OBTAINED = "marksObtained";
  static const String COL_GRADE_PERCENTAGE = "percentage";

  Database? _db;

  Future<Database> getDB() async {
    _db = _db ?? await _openDB();
    return _db!;
  }

  Future<void> deleteDB() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    String dbPath = join(appDir.path, "stybuddy.db");
    if (await databaseExists(dbPath)) {
      await deleteDatabase(dbPath);
      if (kDebugMode) {
        print("DBHelper: Database deleted at $dbPath");
      }
      _db = null;
    }
  }

  Future<Database> _openDB() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    String dbPath = join(appDir.path, "stybuddy.db");

    return await openDatabase(
      dbPath,
      version: 9,
      onCreate: (db, version) async {
        if (kDebugMode) {
          print("DBHelper: Creating database tables (version $version)");
        }
        await db.execute('''
          CREATE TABLE $TABLE_USERS (
            $COL_USER_ID TEXT PRIMARY KEY,
            $COL_USER_FIRST_NAME TEXT,
            $COL_USER_LAST_NAME TEXT,
            $COL_USER_USERNAME TEXT,
            $COL_USER_EMAIL TEXT,
            $COL_USER_PHONE_NUM TEXT,
            $COL_USER_PROFILE_PICTURE TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE $TABLE_CLASS (
            $COL_CLASS_ID INTEGER PRIMARY KEY AUTOINCREMENT,
            $COL_CLASS_SUBJECT TEXT,
            $COL_CLASS_TIME TEXT,
            $COL_CLASS_ROOM TEXT,
            $COL_CLASS_INSTRUCTOR TEXT,
            $COL_CLASS_DAY TEXT,
            $COL_CLASS_SUBJECT_TAG TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE $TABLE_SCHEDULE_EVENTS (
            $COL_EVENT_ID INTEGER PRIMARY KEY AUTOINCREMENT,
            $COL_EVENT_SUBJECT TEXT,
            $COL_EVENT_TAG TEXT,
            $COL_EVENT_START_TIME TEXT,
            $COL_EVENT_END_TIME TEXT,
            $COL_EVENT_DATE TEXT,
            $COL_EVENT_ROOM TEXT,
            $COL_EVENT_INSTRUCTOR TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE $TABLE_SUBJECTS (
            $COL_SUB_ID INTEGER PRIMARY KEY AUTOINCREMENT,
            $COL_SUB_NAME TEXT NOT NULL,
            $COL_SUB_CODE TEXT,
            $COL_SUB_TOTAL_CLASSES INTEGER,
            $COL_SUB_ATTENDED_CLASSES INTEGER,
            $COL_SUB_CREDITS INTEGER
          )
        ''');
        await db.execute('''
          CREATE TABLE $TABLE_ATTENDANCE (
            $COL_ATT_ID INTEGER PRIMARY KEY AUTOINCREMENT,
            $COL_ATT_SUBJECT_ID INTEGER,
            $COL_ATT_DATE TEXT,
            $COL_ATT_IS_PRESENT INTEGER,
            $COL_ATT_TOPIC TEXT,
            FOREIGN KEY($COL_ATT_SUBJECT_ID) REFERENCES $TABLE_SUBJECTS($COL_SUB_ID) ON DELETE CASCADE
          )
        ''');
        await db.execute('''
          CREATE TABLE $TABLE_TASKS (
            $COL_TASK_ID INTEGER PRIMARY KEY AUTOINCREMENT,
            $COL_TASK_TITLE TEXT NOT NULL,
            $COL_TASK_DESCRIPTION TEXT,
            $COL_TASK_DUE_DATE TEXT,
            $COL_TASK_PRIORITY TEXT NOT NULL,
            $COL_TASK_SUBJECT TEXT,
            $COL_TASK_IS_COMPLETED INTEGER NOT NULL,
            $COL_TASK_CREATED_AT TEXT NOT NULL,
            $COL_TASK_UPDATED_AT TEXT NOT NULL
          )
        ''');
        await db.execute('''
          CREATE TABLE $TABLE_GRADE_SUBJECTS (
            $COL_GRADE_SUB_ID INTEGER PRIMARY KEY AUTOINCREMENT,
            $COL_GRADE_SUB_NAME TEXT NOT NULL,
            $COL_GRADE_SUB_TEACHER TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE $TABLE_GRADES (
            $COL_GRADE_ID INTEGER PRIMARY KEY AUTOINCREMENT,
            $COL_GRADE_SUBJECT_ID INTEGER,
            $COL_GRADE_WEIGHTAGE REAL,
            $COL_GRADE_TOTAL_MARKS REAL,
            $COL_GRADE_MARKS_OBTAINED REAL,
            $COL_GRADE_PERCENTAGE REAL,
            FOREIGN KEY($COL_GRADE_SUBJECT_ID) REFERENCES $TABLE_GRADE_SUBJECTS($COL_GRADE_SUB_ID) ON DELETE CASCADE
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (kDebugMode) {
          print(
            "DBHelper: Upgrading database from version $oldVersion to $newVersion",
          );
        }
        if (oldVersion < 9) {
          await db.execute('''
            CREATE TABLE IF NOT EXISTS $TABLE_SCHEDULE_EVENTS (
              $COL_EVENT_ID INTEGER PRIMARY KEY AUTOINCREMENT,
              $COL_EVENT_SUBJECT TEXT,
              $COL_EVENT_TAG TEXT,
              $COL_EVENT_START_TIME TEXT,
              $COL_EVENT_END_TIME TEXT,
              $COL_EVENT_DATE TEXT,
              $COL_EVENT_ROOM TEXT,
              $COL_EVENT_INSTRUCTOR TEXT
            )
          ''');
          if (kDebugMode) {
            print("DBHelper: Created new table $TABLE_SCHEDULE_EVENTS");
          }
        }
      },
      onDowngrade: onDatabaseDowngradeDelete,
    );
  }

  Future<void> insertUser(Map<String, dynamic> data) async {
    final db = await getDB();
    await db.insert(
      TABLE_USERS,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, dynamic>?> getUserById(String userId) async {
    final db = await getDB();
    final List<Map<String, dynamic>> result = await db.query(
      TABLE_USERS,
      where: '$COL_USER_ID = ?',
      whereArgs: [userId],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<int> updateUser(Map<String, dynamic> data, String userId) async {
    final db = await getDB();
    return await db.update(
      TABLE_USERS,
      data,
      where: '$COL_USER_ID = ?',
      whereArgs: [userId],
    );
  }

  Future<int> insertScheduleEvent(Map<String, dynamic> data) async {
    final db = await getDB();
    return await db.insert(
      TABLE_SCHEDULE_EVENTS,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getEventsByDate(String date) async {
    final db = await getDB();
    return await db.query(
      TABLE_SCHEDULE_EVENTS,
      where: '$COL_EVENT_DATE = ?',
      whereArgs: [date],
      orderBy: "$COL_EVENT_START_TIME ASC",
    );
  }

  Future<int> deleteScheduleEvent(int id) async {
    final db = await getDB();
    return await db.delete(
      TABLE_SCHEDULE_EVENTS,
      where: '$COL_EVENT_ID = ?',
      whereArgs: [id],
    );
  }

  Future<int> insertClass(Map<String, dynamic> data) async {
    final db = await getDB();
    return await db.insert(TABLE_CLASS, data);
  }

  Future<List<Map<String, dynamic>>> getClassesByDay(String day) async {
    final db = await getDB();
    return await db.query(
      TABLE_CLASS,
      where: '$COL_CLASS_DAY = ?',
      whereArgs: [day],
      orderBy: "$COL_CLASS_TIME ASC",
    );
  }

  Future<int> deleteClass(int id) async {
    final db = await getDB();
    return await db.delete(
      TABLE_CLASS,
      where: '$COL_CLASS_ID = ?',
      whereArgs: [id],
    );
  }

  Future<int> insertSubject(Map<String, dynamic> data) async {
    final db = await getDB();
    return await db.insert(
      TABLE_SUBJECTS,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getAllSubjects() async {
    final db = await getDB();
    return await db.query(TABLE_SUBJECTS);
  }

  Future<Map<String, dynamic>?> getSubjectById(int id) async {
    final db = await getDB();
    final List<Map<String, dynamic>> result = await db.query(
      TABLE_SUBJECTS,
      where: '$COL_SUB_ID = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<int> updateSubject(Map<String, dynamic> data, int id) async {
    final db = await getDB();
    return await db.update(
      TABLE_SUBJECTS,
      data,
      where: '$COL_SUB_ID = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteSubject(int id) async {
    final db = await getDB();
    return await db.delete(
      TABLE_SUBJECTS,
      where: '$COL_SUB_ID = ?',
      whereArgs: [id],
    );
  }

  Future<int> insertAttendanceRecord(Map<String, dynamic> data) async {
    final db = await getDB();
    return await db.insert(
      TABLE_ATTENDANCE,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getAttendanceRecordsBySubject(
    int subjectId,
  ) async {
    final db = await getDB();
    return await db.query(
      TABLE_ATTENDANCE,
      where: '$COL_ATT_SUBJECT_ID = ?',
      whereArgs: [subjectId],
      orderBy: '$COL_ATT_DATE DESC',
    );
  }

  Future<int> deleteAttendanceRecord(int id) async {
    final db = await getDB();
    return await db.delete(
      TABLE_ATTENDANCE,
      where: '$COL_ATT_ID = ?',
      whereArgs: [id],
    );
  }

  Future<List<Map<String, dynamic>>> getAllAttendanceRecords() async {
    final db = await getDB();
    return await db.query(TABLE_ATTENDANCE, orderBy: '$COL_ATT_DATE ASC');
  }

  Future<int> countAttendanceRecordsForSubject(int subjectId) async {
    final db = await getDB();
    final List<Map<String, dynamic>> result = await db.query(
      TABLE_ATTENDANCE,
      columns: ['COUNT(*)'],
      where: '$COL_ATT_SUBJECT_ID = ?',
      whereArgs: [subjectId],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<List<Map<String, dynamic>>> getLowAttendanceSubjects({
    double thresholdPercentage = 75.0,
  }) async {
    final db = await getDB();
    final String query = '''
      SELECT
        s.${DBHelper.COL_SUB_ID},
        s.${DBHelper.COL_SUB_NAME},
        s.${DBHelper.COL_SUB_CODE},
        s.${DBHelper.COL_SUB_TOTAL_CLASSES},
        s.${DBHelper.COL_SUB_ATTENDED_CLASSES},
        s.${DBHelper.COL_SUB_CREDITS},
        CAST(SUM(CASE WHEN ar.${DBHelper.COL_ATT_IS_PRESENT} = 1 THEN 1 ELSE 0 END) AS REAL) AS actualAttendedClasses,
        CAST(COUNT(ar.${DBHelper.COL_ATT_ID}) AS REAL) AS actualTotalClasses
      FROM
        ${DBHelper.TABLE_SUBJECTS} AS s
      LEFT JOIN
        ${DBHelper.TABLE_ATTENDANCE} AS ar
      ON
        s.${DBHelper.COL_SUB_ID} = ar.${DBHelper.COL_ATT_SUBJECT_ID}
      GROUP BY
        s.${DBHelper.COL_SUB_ID},
        s.${DBHelper.COL_SUB_NAME},
        s.${DBHelper.COL_SUB_CODE},
        s.${DBHelper.COL_SUB_TOTAL_CLASSES},
        s.${DBHelper.COL_SUB_ATTENDED_CLASSES},
        s.${DBHelper.COL_SUB_CREDITS}
      HAVING
        (actualTotalClasses > 0 AND (actualAttendedClasses * 100.0 / actualTotalClasses) < ?)
        OR
        (actualTotalClasses = 0 AND s.${DBHelper.COL_SUB_TOTAL_CLASSES} > 0 AND (s.${DBHelper.COL_SUB_ATTENDED_CLASSES} * 100.0 / s.${DBHelper.COL_SUB_TOTAL_CLASSES}) < ?)
    ''';

    if (kDebugMode) {
      print('DBHelper: Executing getLowAttendanceSubjects query:');
      print(query);
      print(
        'DBHelper: Query arguments: [$thresholdPercentage, $thresholdPercentage]',
      );
    }

    final List<Map<String, dynamic>> result = await db.rawQuery(query, [
      thresholdPercentage,
      thresholdPercentage,
    ]);

    List<Map<String, dynamic>> lowAttendanceSubjects = [];
    for (var row in result) {
      double actualTotalClasses = row['actualTotalClasses'] ?? 0.0;
      double actualAttendedClasses = row['actualAttendedClasses'] ?? 0.0;
      double percentage = 0.0;

      if (actualTotalClasses > 0) {
        percentage = (actualAttendedClasses / actualTotalClasses) * 100.0;
      } else if (row[DBHelper.COL_SUB_TOTAL_CLASSES] != null &&
          row[DBHelper.COL_SUB_TOTAL_CLASSES] > 0) {
        percentage =
            (row[DBHelper.COL_SUB_ATTENDED_CLASSES] /
                row[DBHelper.COL_SUB_TOTAL_CLASSES]) *
            100.0;
      }

      if (percentage < thresholdPercentage ||
          (actualTotalClasses == 0 &&
              row[DBHelper.COL_SUB_TOTAL_CLASSES] > 0 &&
              (row[DBHelper.COL_SUB_ATTENDED_CLASSES] *
                      100.0 /
                      row[DBHelper.COL_SUB_TOTAL_CLASSES]) <
                  thresholdPercentage)) {
        lowAttendanceSubjects.add({
          ...row,
          'attendancePercentage': percentage.round(),
        });
      }
    }

    if (kDebugMode) {
      print('DBHelper: Low attendance subjects found: $lowAttendanceSubjects');
    }
    return lowAttendanceSubjects;
  }

  Future<Map<String, dynamic>?> getLowestAttendanceSubject() async {
    final db = await getDB();
    final String query = '''
      SELECT
        s.${DBHelper.COL_SUB_ID},
        s.${DBHelper.COL_SUB_NAME},
        s.${DBHelper.COL_SUB_CODE},
        s.${DBHelper.COL_SUB_TOTAL_CLASSES},
        s.${DBHelper.COL_SUB_ATTENDED_CLASSES},
        s.${DBHelper.COL_SUB_CREDITS},
        CAST(SUM(CASE WHEN ar.${DBHelper.COL_ATT_IS_PRESENT} = 1 THEN 1 ELSE 0 END) AS REAL) AS actualAttendedClasses,
        CAST(COUNT(ar.${DBHelper.COL_ATT_ID}) AS REAL) AS actualTotalClasses
      FROM
        ${DBHelper.TABLE_SUBJECTS} AS s
      LEFT JOIN
        ${DBHelper.TABLE_ATTENDANCE} AS ar
      ON
        s.${DBHelper.COL_SUB_ID} = ar.${DBHelper.COL_ATT_SUBJECT_ID}
      GROUP BY
        s.${DBHelper.COL_SUB_ID},
        s.${DBHelper.COL_SUB_NAME},
        s.${DBHelper.COL_SUB_CODE},
        s.${DBHelper.COL_SUB_TOTAL_CLASSES},
        s.${DBHelper.COL_SUB_ATTENDED_CLASSES},
        s.${DBHelper.COL_SUB_CREDITS}
    ''';

    if (kDebugMode) {
      print('DBHelper: Executing getLowestAttendanceSubject query:');
      print(query);
    }

    final List<Map<String, dynamic>> allSubjectsAttendance = await db.rawQuery(
      query,
    );

    if (allSubjectsAttendance.isEmpty) {
      if (kDebugMode) {
        print('DBHelper: No subjects found in getLowestAttendanceSubject.');
      }
      return null;
    }

    Map<String, dynamic>? lowestAttendanceSubject;
    double minPercentage = 101.0;

    for (var row in allSubjectsAttendance) {
      double actualTotalClasses = row['actualTotalClasses'] ?? 0.0;
      double actualAttendedClasses = row['actualAttendedClasses'] ?? 0.0;
      double currentPercentage = 0.0;

      if (actualTotalClasses > 0) {
        currentPercentage =
            (actualAttendedClasses / actualTotalClasses) * 100.0;
      } else if (row[DBHelper.COL_SUB_TOTAL_CLASSES] != null &&
          row[DBHelper.COL_SUB_TOTAL_CLASSES] > 0) {
        currentPercentage =
            (row[DBHelper.COL_SUB_ATTENDED_CLASSES] /
                row[DBHelper.COL_SUB_TOTAL_CLASSES]) *
            100.0;
      } else {
        currentPercentage = 0.0;
      }

      if (currentPercentage < minPercentage) {
        minPercentage = currentPercentage;
        lowestAttendanceSubject = {
          ...row,
          'attendancePercentage': currentPercentage.round(),
        };
      }
    }
    if (kDebugMode) {
      print('DBHelper: Lowest attendance subject: $lowestAttendanceSubject');
    }
    return lowestAttendanceSubject;
  }

  Future<int> insertTask(Map<String, dynamic> data) async {
    final db = await getDB();
    return await db.insert(
      TABLE_TASKS,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getAllTasks() async {
    final db = await getDB();
    return await db.query(TABLE_TASKS, orderBy: '${COL_TASK_DUE_DATE} ASC');
  }

  Future<int> updateTask(Map<String, dynamic> data, int id) async {
    final db = await getDB();
    return await db.update(
      TABLE_TASKS,
      data,
      where: '$COL_TASK_ID = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteTask(int id) async {
    final db = await getDB();
    return await db.delete(
      TABLE_TASKS,
      where: '$COL_TASK_ID = ?',
      whereArgs: [id],
    );
  }

  Future<int> insertGradeSubject(Map<String, dynamic> data) async {
    final db = await getDB();
    return await db.insert(
      TABLE_GRADE_SUBJECTS,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getAllGradeSubjects() async {
    final db = await getDB();
    return await db.query(TABLE_GRADE_SUBJECTS);
  }

  Future<Map<String, dynamic>?> getGradeSubjectById(int id) async {
    final db = await getDB();
    final List<Map<String, dynamic>> result = await db.query(
      TABLE_GRADE_SUBJECTS,
      where: '$COL_GRADE_SUB_ID = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<int> updateGradeSubject(Map<String, dynamic> data, int id) async {
    final db = await getDB();
    return await db.update(
      TABLE_GRADE_SUBJECTS,
      data,
      where: '$COL_GRADE_SUB_ID = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteGradeSubject(int id) async {
    final db = await getDB();
    return await db.delete(
      TABLE_GRADE_SUBJECTS,
      where: '$COL_GRADE_SUB_ID = ?',
      whereArgs: [id],
    );
  }

  Future<int> insertGrade(Map<String, dynamic> data) async {
    final db = await getDB();
    return await db.insert(
      TABLE_GRADES,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getGradesBySubjectId(
    int gradeSubjectId,
  ) async {
    final db = await getDB();
    return await db.query(
      TABLE_GRADES,
      where: '$COL_GRADE_SUBJECT_ID = ?',
      whereArgs: [gradeSubjectId],
      orderBy: '$COL_GRADE_ID ASC',
    );
  }

  Future<int> updateGrade(Map<String, dynamic> data, int id) async {
    final db = await getDB();
    return await db.update(
      TABLE_GRADES,
      data,
      where: '$COL_GRADE_ID = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteGrade(int id) async {
    final db = await getDB();
    return await db.delete(
      TABLE_GRADES,
      where: '$COL_GRADE_ID = ?',
      whereArgs: [id],
    );
  }

  Future<List<Map<String, dynamic>>> getAverageGradeForGradeSubjects() async {
    final db = await getDB();
    final String query = '''
      SELECT
        gs.${DBHelper.COL_GRADE_SUB_ID},
        gs.${DBHelper.COL_GRADE_SUB_NAME},
        gs.${DBHelper.COL_GRADE_SUB_TEACHER},
        SUM(g.${DBHelper.COL_GRADE_MARKS_OBTAINED} * g.${DBHelper.COL_GRADE_WEIGHTAGE} / 100.0) AS weightedMarksObtained,
        SUM(g.${DBHelper.COL_GRADE_TOTAL_MARKS} * g.${DBHelper.COL_GRADE_WEIGHTAGE} / 100.0) AS weightedTotalMarks
      FROM
        $TABLE_GRADE_SUBJECTS AS gs
      LEFT JOIN
        $TABLE_GRADES AS g
      ON
        gs.${DBHelper.COL_GRADE_SUB_ID} = g.${DBHelper.COL_GRADE_SUBJECT_ID}
      GROUP BY
        gs.${DBHelper.COL_GRADE_SUB_ID},
        gs.${DBHelper.COL_GRADE_SUB_NAME},
        gs.${DBHelper.COL_GRADE_SUB_TEACHER}
      ORDER BY
        gs.${DBHelper.COL_GRADE_SUB_NAME} ASC;
    ''';

    if (kDebugMode) {
      print("DBHelper: Executing getAverageGradeForGradeSubjects query:");
      print(query);
    }

    final List<Map<String, dynamic>> result = await db.rawQuery(query);

    if (kDebugMode) {
      print("DBHelper: Raw query result for average grades: $result");
    }

    List<Map<String, dynamic>> gradeSubjectAverageGrades = [];

    for (var row in result) {
      double weightedMarksObtained = row['weightedMarksObtained'] ?? 0.0;
      double weightedTotalMarks = row['weightedTotalMarks'] ?? 0.0;
      double averagePercentage = 0.0;

      if (weightedTotalMarks > 0) {
        averagePercentage =
            (weightedMarksObtained / weightedTotalMarks) * 100.0;
      }

      gradeSubjectAverageGrades.add({
        DBHelper.COL_GRADE_SUB_ID: row[DBHelper.COL_GRADE_SUB_ID],
        DBHelper.COL_GRADE_SUB_NAME: row[DBHelper.COL_GRADE_SUB_NAME],
        DBHelper.COL_GRADE_SUB_TEACHER: row[DBHelper.COL_GRADE_SUB_TEACHER],
        'averagePercentage': averagePercentage.round(),
      });
    }

    if (kDebugMode) {
      print(
        "DBHelper: Processed average grades for graph: $gradeSubjectAverageGrades",
      );
    }
    return gradeSubjectAverageGrades;
  }

  Future<List<Map<String, dynamic>>> getAllScheduleEvents() async {
    final db = await getDB();
    return await db.query(TABLE_SCHEDULE_EVENTS);
  }
}
