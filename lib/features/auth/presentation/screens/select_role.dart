import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../widgets/role_card.dart';

class SelectRoleScreen extends StatelessWidget {
  const SelectRoleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 80),

            /// Logo
            Icon(Icons.shopping_cart, size: 60, color: AppColors.primary),

            const SizedBox(height: 20),

            /// Title
            const Text(
              "Welcome to HisabApp",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            /// Subtitle
            const Text(
              "you're logged in. How will you use the app today?",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 30),

            /// Section title
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Select your role.", style: TextStyle(fontSize: 18)),
            ),

            const SizedBox(height: 20),

            /// Owner Card
            RoleCard(
              title: "Owner",
              description:
                  "View all branches, manage operational costs, and profitability.",
              icon: Icons.store,
              onTap: () {
                context.go('/business');
              },
            ),

            const SizedBox(height: 20),

            /// Cashier Card
            RoleCard(
              title: "Cashier",
              description:
                  "Record daily sales, manage inventory, and export daily report.",
              icon: Icons.shopping_cart_checkout,
              onTap: () {
                // Future navigation
              },
            ),

            const SizedBox(height: 30),

            /// 🔥 UPDATED: Login Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  context.go('/login');
                },
                child: const Text("Go to Login"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}