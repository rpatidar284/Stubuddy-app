import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stu_buddy/data/repositories/authentication_repository.dart';
import 'package:stu_buddy/data/repositories/user_repository.dart';

import 'package:stu_buddy/features/authentication/models/user_model.dart';
import 'package:stu_buddy/utils/local_storage/SQLite.dart';

class ProfileController extends GetxController {
  static ProfileController get instance => Get.find();

  final _authRepo = Get.find<AuthenticationRepository>();
  final _userRepo = Get.find<UserRepository>();
  final Rx<UserModel?> user = Rx<UserModel?>(null);
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Fetch user details immediately on controller initialization
    fetchUserDetails();
  }

  /// Fetches the current user's details from Firebase and the local database.
  Future<void> fetchUserDetails() async {
    try {
      isLoading.value = true;
      final firebaseUser = _authRepo.firebaseUser.value;

      if (firebaseUser != null) {
        // Fetch remaining user details from local database
        final localUserData = await _userRepo.fetchUserDetails(
          firebaseUser.uid,
        );

        if (localUserData != null) {
          // Combine Firebase and local data
          final displayNameParts = firebaseUser.displayName?.split(' ') ?? [];
          localUserData.firstName =
              displayNameParts.isNotEmpty
                  ? displayNameParts.first
                  : localUserData.firstName;
          localUserData.lastName =
              displayNameParts.length > 1
                  ? displayNameParts.sublist(1).join(' ')
                  : localUserData.lastName;
          localUserData.email = firebaseUser.email ?? localUserData.email;

          user.value = localUserData;
        } else {
          // Fallback in case local data is not found (e.g., first login)
          final displayNameParts = firebaseUser.displayName?.split(' ') ?? [];
          user.value = UserModel(
            id: firebaseUser.uid,
            firstName:
                displayNameParts.isNotEmpty ? displayNameParts.first : '',
            lastName:
                displayNameParts.length > 1
                    ? displayNameParts.sublist(1).join(' ')
                    : '',
            username: '',
            email: firebaseUser.email ?? '',
            phoneNum: '',
            profilePicture: '',
          );
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load user details: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Handles selecting and saving a profile image to the local database.
  Future<void> selectAndSaveImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        isLoading.value = true;
        final userId = _authRepo.firebaseUser.value?.uid;
        if (userId != null) {
          final imageFile = File(image.path);
          final bytes = await imageFile.readAsBytes();
          final base64Image = base64Encode(bytes);

          // Update local SQLite database
          await _userRepo.updateUser({
            DBHelper.COL_USER_PROFILE_PICTURE: base64Image,
          }, userId);

          // Re-fetch user details to update the UI
          await fetchUserDetails();
        }
        Get.snackbar('Success', 'Profile picture updated successfully!');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update profile picture: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Updates the user's name in Firebase Auth and the local database.
  Future<void> updateName(String newFirstName, String newLastName) async {
    try {
      isLoading.value = true;
      final userId = _authRepo.firebaseUser.value?.uid;
      if (userId != null) {
        // Update Firebase Auth display name
        await _authRepo.updateProfile('$newFirstName $newLastName', null);
        // Update local SQLite database
        await _userRepo.updateUser({
          DBHelper.COL_USER_FIRST_NAME: newFirstName,
          DBHelper.COL_USER_LAST_NAME: newLastName,
        }, userId);

        // Re-fetch user details to update the UI
        await fetchUserDetails();
        Get.snackbar('Success', 'Profile name updated successfully!');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update name: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _authRepo.logout();
  }
}
