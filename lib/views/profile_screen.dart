import 'dart:developer';

import 'package:cafe_frontend/services/auth_service.dart';
import 'package:cafe_frontend/theme/theme.dart';
import 'package:cafe_frontend/views/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    final isLoggedIn = FirebaseAuth.instance.currentUser != null;

    final AuthService authService = AuthService();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        title: Text("Profile", style: text.headlineMedium),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.pagePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),

              /// User Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: AppTheme.cardShadow,
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 38,
                      backgroundColor: AppTheme.secondaryContainer,
                      child: Icon(
                        Icons.person,
                        size: 42,
                        color: AppTheme.primary,
                      ),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Coffee Lover", style: text.titleMedium),
                          const SizedBox(height: 4),
                          Text("coffee@gmail.com", style: text.bodyMedium),
                          const SizedBox(height: 8),
                          Text(
                            "Gold Member",
                            style: text.labelLarge?.copyWith(
                              color: AppTheme.honey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.edit, color: AppTheme.primary),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              Text("Account", style: text.titleMedium),

              const SizedBox(height: 12),

              _ProfileTile(
                icon: Icons.person_outline,
                title: "Personal Information",
              ),

              _ProfileTile(
                icon: Icons.location_on_outlined,
                title: "Delivery Address",
              ),

              _ProfileTile(
                icon: Icons.credit_card_outlined,
                title: "Payment Methods",
              ),

              _ProfileTile(icon: Icons.history, title: "Order History"),

              const SizedBox(height: 24),

              Text("Settings", style: text.titleMedium),

              const SizedBox(height: 12),

              _ProfileTile(
                icon: Icons.notifications_none,
                title: "Notifications",
              ),

              _ProfileTile(icon: Icons.lock_outline, title: "Privacy"),

              _ProfileTile(icon: Icons.help_outline, title: "Help Center"),

              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    log("$isLoggedIn");
                    if (isLoggedIn) {
                      log("signOut");
                      await authService.logout();
                    } else {
                      log("To LoginScreen");
                      Get.to(() => LoginScreen());
                    }
                  },
                  icon: isLoggedIn ? Icon(Icons.logout) : Icon(Icons.login),
                  label: isLoggedIn ? Text("Log out") : Text("Log in"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String title;

  const _ProfileTile({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: AppTheme.cardShadow,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          log("click on it");
        },
        splashColor: Colors.blue,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(18),
            boxShadow: AppTheme.cardShadow,
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: AppTheme.secondaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: AppTheme.primary),
              ),
              const SizedBox(width: 16),
              Expanded(child: Text(title, style: text.bodyLarge)),
              const Icon(Icons.chevron_right, color: AppTheme.secondary),
            ],
          ),
        ),
      ),
    );
  }
}
