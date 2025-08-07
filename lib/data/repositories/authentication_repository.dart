import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:stu_buddy/data/repositories/user_repository.dart';
import 'package:stu_buddy/features/authentication/screens/signup/verifyEmail.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  final _auth = FirebaseAuth.instance;
  final _userRepo = Get.find<UserRepository>();
  final Rx<User?> firebaseUser = Rx<User?>(null);

  @override
  void onInit() {
    super.onInit();
    firebaseUser.bindStream(_auth.authStateChanges());
  }

  Future<void> loginWithEmailAndPassword(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;
      if (user != null) {
        // After login, check if the user exists in the local database.
        final localUser = await _userRepo.fetchUserDetails(user.uid);
        if (localUser == null) {
          // If not, save a basic record from Firebase Auth.
          final displayNameParts = user.displayName?.split(' ') ?? [];
          final userData = {
            'id': user.uid,
            'firstName':
                displayNameParts.isNotEmpty ? displayNameParts.first : '',
            'lastName':
                displayNameParts.length > 1
                    ? displayNameParts.sublist(1).join(' ')
                    : '',
            'username': '', // Placeholder, will be set during signup
            'email': user.email ?? '',
            'phoneNum': '', // Placeholder, will be set during signup
            'profilePicture': user.photoURL ?? '',
          };
          await _userRepo.saveUserRecord(userData);
        }
      }
    } on FirebaseAuthException catch (e) {
      throw e.message ?? 'An unknown error occurred.';
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }

  Future<void> signupWithEmailAndPassword(
    String email,
    String password,
    String firstName,
    String lastName,
    String username,
    String phoneNum,
  ) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;
      if (user != null) {
        await user.updateDisplayName(
          '$firstName $lastName',
        ); // Update display name on Firebase Auth
        final userData = {
          'id': user.uid,
          'firstName': firstName,
          'lastName': lastName,
          'username': username,
          'email': email,
          'phoneNum': phoneNum,
          'profilePicture': '',
        };
        await _userRepo.saveUserRecord(userData);
        Get.to(() => const VerifyEmailScreen());
      }
    } on FirebaseAuthException catch (e) {
      throw e.message ?? 'An unknown error occurred.';
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }

  /// Updates the user's profile with a new display name and/or photo URL.
  Future<void> updateProfile(String? name, String? photoUrl) async {
    try {
      await _auth.currentUser?.updateProfile(
        displayName: name,
        photoURL: photoUrl,
      );
    } on FirebaseAuthException catch (e) {
      throw e.message ?? 'An unknown error occurred.';
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
