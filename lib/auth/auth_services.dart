import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  //Instance of Auth
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Login
  Future<UserCredential> signinWithEmailPassword(String email, password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // Signup
  Future<UserCredential> signupWithEmailPassword(String email, password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // Logout
  Future<void> signOut() async {
    return await _auth.signOut();
  }
  // Error Handling
}
