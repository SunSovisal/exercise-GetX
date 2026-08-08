import 'package:cafe_frontend/services/auth_service.dart';
import 'package:cafe_frontend/theme/theme.dart';
import 'package:cafe_frontend/validators/auth_input_validators.dart';
import 'package:cafe_frontend/widgets/auth/auth_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();

  final AuthService authService = AuthService();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        title: Text(
          "Register Account",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.pagePadding),
          child: Column(
            children: [
              const SizedBox(height: 30),
              const AuthHeader(
                title: "Welcome To My Coffee",
                subtitle:
                    "Register in to continue enjoying your favorite coffee.",
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
                      validator: validateRegistrationPassword,
                      controller: passwordController,
                      hint: "Password",
                      icon: Icons.lock_outline,
                      obscureText: true,
                    ),

                    const SizedBox(height: 16),
                    AuthTextField(
                      validator: validatePhoneNumber,
                      controller: phoneController,
                      hint: "Phone Number",
                      icon: Icons.call,
                      keyboardType: TextInputType.phone,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              AuthPrimaryButton(
                text: "Register",
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await authService.register(
                      email: emailController.text.trim(),
                      password: passwordController.text.trim(),
                    );
                  }
                  emailController.clear();
                  passwordController.clear();
                  phoneController.clear();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
