// Firebase Authentication service
// NOTE: Phone OTP auth is temporarily commented out — email/password is active.
//       To restore OTP: uncomment the [PHONE OTP] block, comment the [EMAIL] block,
//       and revert auth_provider.dart and login_screen.dart similarly.

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ─── PHONE OTP AUTH — temporarily disabled ────────────────────────────────
  // To restore: uncomment this block and add:
  //   import 'package:flutter/foundation.dart';
  //
  // String? _verificationId;
  // int? _resendToken;
  // ConfirmationResult? _webConfirmationResult;
  //
  // Future<void> sendOtp({
  //   required String phoneNumber,
  //   required Function(String) onCodeSent,
  //   required Function(String) onError,
  //   required Function(PhoneAuthCredential) onAutoVerify,
  // }) async {
  //   final String formattedPhone =
  //       phoneNumber.startsWith('+') ? phoneNumber : '+91$phoneNumber';
  //   if (kIsWeb) {
  //     try {
  //       _webConfirmationResult = await _auth.signInWithPhoneNumber(formattedPhone);
  //       onCodeSent('web');
  //     } on FirebaseAuthException catch (e) {
  //       if (e.code == 'invalid-phone-number') {
  //         onError('Invalid phone number format');
  //       } else if (e.code == 'too-many-requests') {
  //         onError('Too many requests. Please try again later');
  //       } else if (e.code == 'operation-not-allowed') {
  //         onError('Phone sign-in is not enabled in Firebase Console.');
  //       } else {
  //         onError('[${e.code}] ${e.message}');
  //       }
  //     } catch (e) {
  //       onError('Failed to send OTP: $e');
  //     }
  //     return;
  //   }
  //   try {
  //     await _auth.verifyPhoneNumber(
  //       phoneNumber: formattedPhone,
  //       timeout: const Duration(seconds: 60),
  //       verificationCompleted: (PhoneAuthCredential credential) async {
  //         onAutoVerify(credential);
  //       },
  //       verificationFailed: (FirebaseAuthException e) {
  //         if (e.code == 'invalid-phone-number') {
  //           onError('Invalid phone number format');
  //         } else if (e.code == 'too-many-requests') {
  //           onError('Too many requests. Please try again later');
  //         } else {
  //           onError('Verification failed: ${e.message}');
  //         }
  //       },
  //       codeSent: (String verificationId, int? resendToken) {
  //         _verificationId = verificationId;
  //         _resendToken = resendToken;
  //         onCodeSent(verificationId);
  //       },
  //       codeAutoRetrievalTimeout: (String verificationId) {
  //         _verificationId = verificationId;
  //       },
  //       forceResendingToken: _resendToken,
  //     );
  //   } catch (e) {
  //     onError('Failed to send OTP: $e');
  //   }
  // }
  //
  // Future<UserCredential?> verifyOtp({
  //   required String otp,
  //   String? verificationId,
  // }) async {
  //   try {
  //     if (kIsWeb) {
  //       if (_webConfirmationResult == null) {
  //         throw Exception('No pending OTP verification. Please request OTP again.');
  //       }
  //       final userCredential = await _webConfirmationResult!.confirm(otp);
  //       _webConfirmationResult = null;
  //       return userCredential;
  //     }
  //     final String vidToUse = verificationId ?? _verificationId ?? '';
  //     if (vidToUse.isEmpty) throw Exception('Verification ID not found');
  //     final PhoneAuthCredential credential = PhoneAuthProvider.credential(
  //       verificationId: vidToUse,
  //       smsCode: otp,
  //     );
  //     return await _auth.signInWithCredential(credential);
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'invalid-verification-code') {
  //       throw Exception('Invalid OTP. Please try again');
  //     } else if (e.code == 'session-expired') {
  //       throw Exception('OTP expired. Please request a new code');
  //     } else {
  //       throw Exception('Verification failed: ${e.message}');
  //     }
  //   } catch (e) {
  //     throw Exception('Failed to verify OTP: $e');
  //   }
  // }
  //
  // Future<UserCredential> signInWithCredential(PhoneAuthCredential credential) async {
  //   try {
  //     return await _auth.signInWithCredential(credential);
  //   } catch (e) {
  //     throw Exception('Auto sign-in failed: $e');
  //   }
  // }
  //
  // Future<void> resendOtp({
  //   required String phoneNumber,
  //   required Function(String) onCodeSent,
  //   required Function(String) onError,
  // }) async {
  //   await sendOtp(
  //     phoneNumber: phoneNumber,
  //     onCodeSent: onCodeSent,
  //     onError: onError,
  //     onAutoVerify: (credential) async {
  //       await signInWithCredential(credential);
  //     },
  //   );
  // }
  // ─────────────────────────────────────────────────────────────────────────────

  // ─── EMAIL / PASSWORD AUTH (active) ──────────────────────────────────────────

  Future<UserCredential> signInWithEmail(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('No account found for this email.');
      } else if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
        throw Exception('Incorrect password. Please try again.');
      } else if (e.code == 'invalid-email') {
        throw Exception('Invalid email address.');
      } else if (e.code == 'user-disabled') {
        throw Exception('This account has been disabled.');
      } else if (e.code == 'too-many-requests') {
        throw Exception('Too many attempts. Please try again later.');
      } else {
        throw Exception('[${e.code}] ${e.message}');
      }
    } catch (e) {
      throw Exception('Sign-in failed: $e');
    }
  }

  Future<UserCredential> registerWithEmail(String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw Exception('An account already exists for this email.');
      } else if (e.code == 'weak-password') {
        throw Exception('Password is too weak. Use at least 6 characters.');
      } else if (e.code == 'invalid-email') {
        throw Exception('Invalid email address.');
      } else {
        throw Exception('[${e.code}] ${e.message}');
      }
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  // ─── GOOGLE SIGN-IN ──────────────────────────────────────────────────────────

  Future<UserCredential> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        throw Exception('Google sign-in aborted.');
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      return await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw Exception('[${e.code}] ${e.message}');
    } catch (e) {
      throw Exception('Google sign-in failed: $e');
    }
  }

  // ─────────────────────────────────────────────────────────────────────────────

  User? get currentUser => _auth.currentUser;
  String? get currentUserId => _auth.currentUser?.uid;
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  bool isSignedIn() => _auth.currentUser != null;
  String? getCurrentUserPhone() => _auth.currentUser?.phoneNumber;

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await GoogleSignIn().signOut();
      // _verificationId = null;       // uncomment with OTP
      // _resendToken = null;           // uncomment with OTP
      // _webConfirmationResult = null; // uncomment with OTP
    } catch (e) {
      throw Exception('Sign out failed: $e');
    }
  }

  Future<void> deleteAccount() async {
    try {
      await _auth.currentUser?.delete();
      // _verificationId = null;       // uncomment with OTP
      // _resendToken = null;           // uncomment with OTP
      // _webConfirmationResult = null; // uncomment with OTP
    } catch (e) {
      throw Exception('Failed to delete account: $e');
    }
  }
}