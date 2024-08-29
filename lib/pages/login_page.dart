import 'package:flutter/material.dart';
import 'package:zing/services/auth/auth_services.dart';
import 'package:zing/components/custom_button.dart';
import 'package:zing/components/custom_textfeild.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Toggle RegisterPage Function
  final void Function()? onTap;

  LoginPage({super.key, required this.onTap});

// Login Method
  void login(BuildContext context) async {
    // Get Auth service
    final authService = AuthService();

    // Try Login
    try {
      await authService.signinWithEmailPassword(
          _emailController.text, _passwordController.text);
      // Catch Errors
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Error:$e"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Icon(
              Icons.message_rounded,
              size: 60,
              color: Theme.of(context).colorScheme.primary,
            ),

            const SizedBox(height: 50),

            // Welcome Back Message
            Text(
              "Welcome Back!",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 25),

            // Email Textfeild
            CustomTextField(
              hintText: "Email",
              obscureText: false,
              controller: _emailController,
            ),

            const SizedBox(height: 10),

            // Password Textfeild
            CustomTextField(
              hintText: "Password",
              obscureText: true,
              controller: _passwordController,
            ),

            const SizedBox(height: 25),

            // Login Button
            CustomButton(
              text: "Login",
              onTap: () => login(context),
            ),

            const SizedBox(height: 15),

            // Register Button
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Not a user? ",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                GestureDetector(
                  onTap: onTap,
                  child: const Text(
                    "Register Now",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
