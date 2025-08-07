import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:stu_buddy/data/repositories/authentication_repository.dart';
import 'package:stu_buddy/data/repositories/user_repository.dart';
import 'package:stu_buddy/features/authentication/screens/Attendance/widget/attendance_analytics_controller.dart';
import 'package:stu_buddy/features/authentication/screens/Attendance/widget/attendance_controller.dart';
import 'package:stu_buddy/features/authentication/screens/Attendance/widget/subject_controller.dart';
import 'package:stu_buddy/features/authentication/screens/MyGrade/widget/grade_repository.dart';
import 'package:stu_buddy/features/authentication/screens/login/login.dart';
import 'package:stu_buddy/features/authentication/screens/onboarding/onBoarding.dart';
import 'package:stu_buddy/utils/local_storage/SQLite.dart';
import 'package:stu_buddy/utils/firebase_options.dart';
import 'package:stu_buddy/utils/navigation_menu.dart';
import 'package:stu_buddy/utils/theme/customTheme/theme.dart';
import 'package:sizer/sizer.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize App Check with a provider for your platform
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.playIntegrity,
  );

  await DBHelper.getInstance.getDB(); // Initialize the database

  // Initialize and put all controllers/repositories
  Get.lazyPut(() => GradeRepository());
  Get.lazyPut(() => UserRepository());
  Get.lazyPut(() => AuthenticationRepository());

  Get.put(SubjectController());
  Get.put(AttendanceController());
  Get.put(AttendanceAnalyticsController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authRepo = Get.find<AuthenticationRepository>();

    return Sizer(
      builder: (context, orientation, deviceType) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: SAppTheme.lightTheme,

          home: Obx(() {
            if (authRepo.firebaseUser.value == null) {
              return const OnboardingScreen();
            } else {
              return const NavigationMenu();
            }
          }),
        );
      },
    );
  }
}
