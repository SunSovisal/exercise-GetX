import 'dart:developer';

import 'package:cafe_frontend/views/home_screen.dart';
import 'package:cafe_frontend/views/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/instance_manager.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> register({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      Get.offAll(() => LoginScreen());
    } catch (e) {
      log("$e");
    }
  }

  Future<void> login({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Get.offAll(() => HomeScreen());
    } catch (e) {
      log("$e");
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
      Get.offAll(() => LoginScreen());
    } catch (e) {
      log("$e");
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      // 1. Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // 2. Handle user cancellation early
      if (googleUser == null) {
        log("Google Sign-In canceled by user.");
        return null;
      }

      // 3. Obtain the auth details
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // 4. Create a new credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 5. Sign in to Firebase and return credential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e, stackTrace) {
      log("Error during Google Sign-In: $e", stackTrace: stackTrace);
      return null; 
    }
  }

  Future<void> signInWithPhoneNumber(
    String phoneNumber, {
    required Function(String verificationId) onCodeSent,
    required Function(FirebaseAuthException e) onError,
  }) async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber:
            phoneNumber, // Must include country code, e.g., "+14155552671"
        // Auto-retrieval or instant verification (Android only)
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance.signInWithCredential(credential);
          log("Auto-verification successful.");
        },

        // Verification failed (e.g., invalid phone number)
        verificationFailed: (FirebaseAuthException e) {
          log("Phone verification failed: ${e.message}");
          onError(e);
        },

        // SMS code sent successfully -> save verificationId and prompt user for OTP
        codeSent: (String verificationId, int? resendToken) {
          log("Verification code sent to $phoneNumber");
          onCodeSent(verificationId);
        },

        codeAutoRetrievalTimeout: (String verificationId) {
          log("Auto retrieval timeout.");
        },
      );
    } catch (e, stackTrace) {
      log("Error starting phone authentication: $e", stackTrace: stackTrace);
    }
  }

  Future<UserCredential?> verifySMSCode({
    required String verificationId,
    required String smsCode,
  }) async {
    try {
      // 1. Create a PhoneAuthCredential with the ID and OTP code
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      // 2. Sign in to Firebase and return credential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e, stackTrace) {
      log("Error verifying SMS code: $e", stackTrace: stackTrace);
      return null;
    }
  }

  Future<void> forgotpassword({required String email}) async{
    try{
      await _auth.sendPasswordResetEmail(email: email);
    }catch (e){
      log("$e");
    }
  }
}
