import 'dart:developer';

import 'package:cafe_frontend/services/auth_service.dart';
import 'package:cafe_frontend/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/route_manager.dart';
import 'package:get/state_manager.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();

  final AuthService authService = AuthService();

  final _formKey = GlobalKey<FormState>();

  String? _emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter your email";
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value.trim())) {
      return "Please enter a valid email";
    }
    return null;
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your password";
    }
    if (value.length < 7) {
      return "Password must be at least 8 characters";
    }
    return null;
  }

  String? _phoneNumberValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter your phone number";
    }

    // Strip whitespaces for validation
    final cleanValue = value.trim();

    // Regex to check if it's a valid phone number (optional leading +, followed by 8 to 15 digits)
    final phoneRegExp = RegExp(r'^\+?[0-9]{8,15}$');

    if (!phoneRegExp.hasMatch(cleanValue)) {
      return "Please enter a valid phone number with country code (e.g. +14155552671)";
    }

    return null;
  }

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
                    CustomTextField(
                      validator: _emailValidator,
                      controller: emailController,
                      hint: "Email",
                      icon: Icons.email_outlined,
                    ),

                    const SizedBox(height: 16),
                    CustomTextField(
                      validator: _passwordValidator,
                      controller: passwordController,
                      hint: "Password",
                      icon: Icons.lock_outline,
                      obscure: true,
                    ),

                    const SizedBox(height: 16),
                    CustomTextField(
                      validator: _phoneNumberValidator,
                      controller: phoneController,
                      hint: "Phone Number",
                      icon: Icons.call,
                      obscure: true,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              CustomButton(
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

class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const AuthHeader({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Column(
      children: [
        const Icon(Icons.coffee, size: 60, color: Color(0xFF25160E)),
        const SizedBox(height: 16),
        Text("The Brew", style: text.headlineMedium),
        const SizedBox(height: 24),
        Text(title, style: text.displayMedium, textAlign: TextAlign.center),
        const SizedBox(height: 10),
        Text(subtitle, style: text.bodyMedium, textAlign: TextAlign.center),
      ],
    );
  }
}

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool obscure;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hint,
    required this.icon,
    this.obscure = false,
    this.suffixIcon,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon),
        suffixIcon: suffixIcon,
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: Text(text),
      ),
    );
  }
}
