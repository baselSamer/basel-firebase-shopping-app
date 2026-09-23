import 'package:firebase_auth/firebase_auth.dart';

/// Wraps all FirebaseAuth calls in one place so screens never talk to
/// FirebaseAuth directly. Each method returns null on success or a
/// human-readable error message on failure, which keeps the UI code
/// free of try/catch and FirebaseAuthException handling.
class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  /// The currently signed-in user, or null if no one is signed in.
  User? get currentUser => _firebaseAuth.currentUser;

  /// Signs an existing user in with email and password.
  Future<String?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return null; // null means "no error"
    } on FirebaseAuthException catch (e) {
      return _mapAuthErrorToMessage(e);
    }
  }

  /// Registers a brand new user with email and password.
  Future<String?> signUp({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      return _mapAuthErrorToMessage(e);
    }
  }

  /// Signs the current user out.
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  /// Turns Firebase's error codes into short, user-facing messages.
  String _mapAuthErrorToMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'That email address looks invalid.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'user-not-found':
        return 'No account found for that email.';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect email or password.';
      case 'email-already-in-use':
        return 'An account already exists for that email.';
      case 'weak-password':
        return 'Password should be at least 6 characters.';
      default:
        return e.message ?? 'Something went wrong. Please try again.';
    }
  }
}
