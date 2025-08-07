import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stu_buddy/data/repositories/authentication_repository.dart';
import 'package:stu_buddy/features/authentication/screens/SplitBill/services/firebase_service.dart';
import 'package:stu_buddy/utils/constants/textString.dart';

import 'package:stu_buddy/utils/local_storage/SQLite.dart';

class SignupController extends GetxController {
  static SignupController get instance => Get.find();

  /// variables
  final email = TextEditingController();
  final firstname = TextEditingController();
  final lastname = TextEditingController();
  final password = TextEditingController();
  final username = TextEditingController();
  final phoneNum = TextEditingController();
  GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();
  final privacyPolicy = false.obs;

  /// Signup
  Future<void> signup() async {
    try {
      if (!privacyPolicy.value) {
        Get.snackbar(
          Stext.privacyPolicy,
          'You must agree to the Privacy Policy & Terms of use',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.1),
          colorText: Colors.red,
        );
        return;
      }
      if (signupFormKey.currentState!.validate()) {
        final authRepo = Get.find<AuthenticationRepository>();

        // 1. Authenticate user with Firebase
        await authRepo.signupWithEmailAndPassword(
          email.text,
          password.text,
          firstname.text,
          lastname.text,
          username.text,
          phoneNum.text,
        );

        final user = FirebaseService.getInstance.getCurrentUser();

        if (user != null) {
          // 2. Save user data to Firestore
          await FirebaseService.getInstance.saveUserToFirestore(
            user.uid,
            username.text.trim(),
            email.text.trim(),
          );

          // 3. Save user data to local SQLite database
          await DBHelper.getInstance.insertUser({
            'id': user.uid,
            'firstName': firstname.text.trim(),
            'lastName': lastname.text.trim(),
            'username': username.text.trim(),
            'email': email.text.trim(),
            'phoneNum': phoneNum.text.trim(),
            'profilePicture': '', // Changed to an empty string
          });

          Get.snackbar(
            'Success',
            'Your account has been created!',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green.withOpacity(0.1),
            colorText: Colors.green,
          );

          Get.toNamed('/navigation-menu');
        } else {
          Get.snackbar(
            'Error',
            'User was not signed in successfully.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.withOpacity(0.1),
            colorText: Colors.red,
          );
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    }
  }
}
