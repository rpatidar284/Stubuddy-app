import 'package:stu_buddy/utils/local_storage/SQLite.dart';

class UserModel {
  final String id;
  String firstName;
  String lastName;
  String username;
  String email;
  String phoneNum;
  String profilePicture;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    required this.phoneNum,
    required this.profilePicture,
  });

  static UserModel fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json[DBHelper.COL_USER_ID] as String,
      firstName: json[DBHelper.COL_USER_FIRST_NAME] as String,
      lastName: json[DBHelper.COL_USER_LAST_NAME] as String,
      username: json[DBHelper.COL_USER_USERNAME] as String,
      email: json[DBHelper.COL_USER_EMAIL] as String,
      phoneNum: json[DBHelper.COL_USER_PHONE_NUM] as String,
      profilePicture: json[DBHelper.COL_USER_PROFILE_PICTURE] as String,
    );
  }
}
