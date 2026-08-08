import 'dart:developer';

import 'package:cafe_frontend/services/auth_service.dart';
import 'package:cafe_frontend/theme/theme.dart';
import 'package:cafe_frontend/validators/auth_input_validators.dart';
import 'package:cafe_frontend/views/home_screen.dart';
import 'package:cafe_frontend/views/register_screen.dart';
import 'package:cafe_frontend/widgets/auth/auth_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final AuthService authService = AuthService();

  void _showPhoneNumberBottomSheet(BuildContext context) {
    final TextEditingController phoneController = TextEditingController();

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Enter Phone Number",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                hintText: "+855 884533668 (with country code)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final phone = phoneController.text.trim();
                if (phone.isEmpty) return;

                Get.back(); // Close phone input sheet

                await authService.signInWithPhoneNumber(
                  phone,
                  onCodeSent: (String verificationId) {
                    // Show the OTP screen/dialog when SMS is sent
                    _showOtpDialog(context, verificationId);
                  },
                  onError: (FirebaseAuthException e) {
                    Get.snackbar(
                      "Error",
                      e.message ?? "Phone auth failed",
                      backgroundColor: AppTheme.primary,
                      colorText: Colors.white,
                      margin: const EdgeInsets.all(16),
                      borderRadius: 12,
                      duration: const Duration(seconds: 3),
                      icon: const Icon(
                        Icons.check_circle_outline,
                        color: Colors.white,
                      ),
                    );
                    log("$e");
                  },
                );
              },
              child: const Text("Send Verification Code"),
            ),
          ],
        ),
      ),
    );
  }

  void _showOtpDialog(BuildContext context, String verificationId) {
    final TextEditingController otpController = TextEditingController();

    Get.defaultDialog(
      title: "Enter OTP Code",
      content: Column(
        children: [
          TextField(
            controller: otpController,
            keyboardType: TextInputType.number,
            maxLength: 6,
            decoration: const InputDecoration(
              hintText: "6-digit SMS code",
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      textConfirm: "Verify",
      onConfirm: () async {
        final code = otpController.text.trim();
        if (code.length != 6) return;

        final user = await authService.verifySMSCode(
          verificationId: verificationId,
          smsCode: code,
        );

        if (user != null) {
          Get.back(); // Close OTP dialog
          Get.offAll(() => HomeScreen()); // Navigate to Home
        } else {
          Get.snackbar(
            "Error",
            "Invalid OTP code",
            backgroundColor: AppTheme.primary,
            colorText: Colors.white,
            margin: const EdgeInsets.all(16),
            borderRadius: 12,
            duration: const Duration(seconds: 3),
            icon: const Icon(Icons.check_circle_outline, color: Colors.white),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(
          "Login Account",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.pagePadding),
          child: Column(
            children: [
              const SizedBox(height: 10),
              const AuthHeader(
                title: "Welcome Back",
                subtitle: "Sign in to continue enjoying your favorite coffee.",
              ),

              const SizedBox(height: 40),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    AuthTextField(
                      validator: validateEmail,
                      controller: emailController,
                      hint: "Email",
                      icon: Icons.email_outlined,
                    ),

                    const SizedBox(height: 16),
                    AuthTextField(
                      validator: validateLoginPassword,
                      controller: passwordController,
                      hint: "Password",
                      icon: Icons.lock_outline,
                      obscureText: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text("Forgot Password?"),
                ),
              ),

              const SizedBox(height: 20),
              AuthPrimaryButton(
                text: "Login",
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await authService.login(
                      email: emailController.text.trim(),
                      password: passwordController.text.trim(),
                    );
                  }
                  emailController.clear();
                  passwordController.clear();
                },
              ),

              const SizedBox(height: 20),
              const Text("OR CONTINUE WITH"),
              const SizedBox(height: 20),
              Row(
                children: [
                  SocialButton(
                    text: "Google",
                    image:
                        "https://i.pinimg.com/1200x/45/20/dd/4520ddfc56208707045c56232e946f7f.jpg",
                    onPressed: () async {
                      try {
                        final user = await authService.signInWithGoogle();
                        if (user != null) {
                          Get.to(HomeScreen());
                        }
                      } catch (e) {
                        log("$e");
                      }
                    },
                  ),
                  SizedBox(width: 10),
                  SocialButton(
                    text: "PhoneNumber",
                    image:
                        "https://i.pinimg.com/736x/1c/12/83/1c1283c73d36bd99f04562c9178a589e.jpg",
                    onPressed: () {
                      _showPhoneNumberBottomSheet(context);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?"),
                  TextButton(
                    onPressed: () {
                      Get.to(() => RegisterScreen());
                    },
                    child: const Text("Register"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SocialButton extends StatelessWidget {
  final String text;
  final String image;
  final VoidCallback onPressed;

  const SocialButton({
    super.key,
    required this.text,
    required this.image,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: CircleAvatar(
          radius: 15,
          backgroundImage: NetworkImage(image.toString()),
        ),
        label: Text(text),
      ),
    );
  }
}
