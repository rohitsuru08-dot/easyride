// Authentication provider using Provider package
// NOTE: Phone OTP auth is temporarily commented out — email/password is active.
//       To restore OTP: uncomment the [PHONE OTP] blocks, comment the [EMAIL] blocks,
//       and revert auth_service.dart and login_screen.dart similarly.

import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:easy_ride/services/auth_service.dart';
import 'package:easy_ride/services/local_storage_service.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();

  AuthStatus _status = AuthStatus.initial;
  String? _errorMessage;
  User? _currentUser;

  // ─── PHONE OTP FIELDS — temporarily disabled ──────────────────────────────
  // String? _verificationId;
  // String? get verificationId => _verificationId;
  // ─────────────────────────────────────────────────────────────────────────────

  AuthStatus get status => _status;
  String? get errorMessage => _errorMessage;
  User? get currentUser => _currentUser;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  Future<void> initialize() async {
    _currentUser = _authService.currentUser;
    _status = _currentUser != null
        ? AuthStatus.authenticated
        : AuthStatus.unauthenticated;
    notifyListeners();
  }

  // ─── EMAIL / PASSWORD AUTH (active) ──────────────────────────────────────────

  Future<bool> signInWithEmail(String email, String password) async {
    try {
      _status = AuthStatus.loading;
      _errorMessage = null;
      notifyListeners();

      final userCredential = await _authService.signInWithEmail(email, password);
      _currentUser = userCredential.user;
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  Future<bool> registerWithEmail(String email, String password) async {
    try {
      _status = AuthStatus.loading;
      _errorMessage = null;
      notifyListeners();

      final userCredential = await _authService.registerWithEmail(email, password);
      _currentUser = userCredential.user;
      
      if (_currentUser != null && !_currentUser!.emailVerified) {
        await _currentUser!.sendEmailVerification();
      }

      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      _status = AuthStatus.loading;
      _errorMessage = null;
      notifyListeners();

      await _authService.sendPasswordResetEmail(email);

      _status = AuthStatus.initial;
      notifyListeners();
      return true;
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    try {
      _status = AuthStatus.loading;
      _errorMessage = null;
      notifyListeners();

      final userCredential = await _authService.signInWithGoogle();
      _currentUser = userCredential.user;
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  // ─────────────────────────────────────────────────────────────────────────────

  // ─── PHONE OTP AUTH — temporarily disabled ────────────────────────────────
  // To restore: uncomment this block and revert auth_service.dart and
  // login_screen.dart. Also uncomment _verificationId field above.
  //
  // Future<void> sendOtp(String phoneNumber) async {
  //   _status = AuthStatus.loading;
  //   _errorMessage = null;
  //   notifyListeners();
  //   await _authService.sendOtp(
  //     phoneNumber: phoneNumber,
  //     onCodeSent: (verificationId) {
  //       _verificationId = verificationId;
  //       _status = AuthStatus.unauthenticated;
  //       _errorMessage = null;
  //       notifyListeners();
  //     },
  //     onError: (error) {
  //       _status = AuthStatus.error;
  //       _errorMessage = error;
  //       notifyListeners();
  //     },
  //     onAutoVerify: (credential) async {
  //       try {
  //         final userCredential = await _authService.signInWithCredential(credential);
  //         _currentUser = userCredential.user;
  //         _status = AuthStatus.authenticated;
  //         _errorMessage = null;
  //         notifyListeners();
  //       } catch (e) {
  //         _status = AuthStatus.error;
  //         _errorMessage = e.toString();
  //         notifyListeners();
  //       }
  //     },
  //   );
  // }
  //
  // Future<bool> verifyOtp(String otp) async {
  //   try {
  //     _status = AuthStatus.loading;
  //     _errorMessage = null;
  //     notifyListeners();
  //     final userCredential = await _authService.verifyOtp(
  //       otp: otp,
  //       verificationId: _verificationId,
  //     );
  //     if (userCredential != null) {
  //       _currentUser = userCredential.user;
  //       _status = AuthStatus.authenticated;
  //       _errorMessage = null;
  //       notifyListeners();
  //       return true;
  //     }
  //     return false;
  //   } catch (e) {
  //     _status = AuthStatus.error;
  //     _errorMessage = e.toString();
  //     notifyListeners();
  //     return false;
  //   }
  // }
  //
  // Future<void> resendOtp(String phoneNumber) async {
  //   await sendOtp(phoneNumber);
  // }
  // ─────────────────────────────────────────────────────────────────────────────

  Future<void> signOut() async {
    try {
      await _authService.signOut();
      await LocalStorageService.clearUserData();
      _currentUser = null;
      _status = AuthStatus.unauthenticated;
      _errorMessage = null;
      // _verificationId = null; // uncomment with OTP
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}