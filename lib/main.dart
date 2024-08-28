import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:zing/auth/auth_gate.dart';
import 'package:zing/firebase_options.dart';
import 'themes/light_mode.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AuthGate(),
      theme: lightmode,
    );
  }
}
