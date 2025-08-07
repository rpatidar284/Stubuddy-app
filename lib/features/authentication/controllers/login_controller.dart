import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stu_buddy/data/repositories/authentication_repository.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  final email = TextEditingController();
  final password = TextEditingController();
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  Future<void> login() async {
    try {
      if (loginFormKey.currentState!.validate()) {
        final authRepo = Get.find<AuthenticationRepository>();
        await authRepo.loginWithEmailAndPassword(email.text, password.text);
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
