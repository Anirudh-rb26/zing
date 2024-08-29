import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zing/services/auth/login_or_register.dart';
import 'package:zing/pages/home_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // If user is LoggedIn
            return HomePage();
          } else {
            // If user hasn't LoggedIn
            return const LoginOrRegister();
          }
        },
      ),
    );
  }
}
