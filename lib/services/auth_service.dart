import 'dart:developer';

import 'package:cafe_frontend/views/home_screen.dart';
import 'package:cafe_frontend/views/login-screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/instance_manager.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> register({required email, required password}) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      Get.to(LoginScreen());
    } catch (e) {
      log("$e");
    }
  }

  Future<void> login({required email, required password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Get.to(HomeScreen());
    } catch (e) {
      log("$e");
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
      Get.offAll(LoginScreen());
    } catch (e) {
      log("$e");
    }
  }
}
