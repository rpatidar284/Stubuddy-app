import 'package:get/get.dart';

import 'package:stu_buddy/features/authentication/models/user_model.dart';
import 'package:stu_buddy/utils/local_storage/SQLite.dart';

/// Repository class for user-related operations.
/// Handles interactions with the local SQLite database.
class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final _dbHelper = DBHelper.getInstance;

  // Insert user data into the local SQLite database
  Future<void> saveUserRecord(Map<String, dynamic> user) async {
    try {
      await _dbHelper.insertUser(user);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not save user data to local database.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Fetch user details from the local SQLite database
  Future<UserModel?> fetchUserDetails(String userId) async {
    try {
      final userMap = await _dbHelper.getUserById(userId);
      if (userMap != null) {
        return UserModel.fromJson(userMap);
      }
      return null;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not fetch user data from local database.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return null;
    }
  }

  // Update user details in the local SQLite database
  Future<int> updateUser(Map<String, dynamic> data, String userId) async {
    try {
      return await _dbHelper.updateUser(data, userId);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not update user data in local database.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return 0;
    }
  }
}
