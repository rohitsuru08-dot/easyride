// User provider for managing current user data
import 'package:flutter/foundation.dart';
import 'package:easy_ride/models/user_model.dart';
import 'package:easy_ride/services/firebase_service.dart';
import 'package:easy_ride/services/local_storage_service.dart';

class UserProvider with ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get userRole => _currentUser?.role;
  String get language => _currentUser?.language ?? 'en';

  // Load user data
  Future<void> loadUser(String userId) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _currentUser = await _firebaseService.getUser(userId);
      
      if (_currentUser != null) {
        // Save to local storage
        await LocalStorageService.saveUserData(
          userId: _currentUser!.userId,
          role: _currentUser!.role,
          name: _currentUser!.name,
          phone: _currentUser!.phone,
        );
        await LocalStorageService.saveLanguage(_currentUser!.language);
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // Create or update user
  Future<void> saveUser(UserModel user) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _firebaseService.saveUser(user);
      _currentUser = user;

      // Save to local storage
      await LocalStorageService.saveUserData(
        userId: user.userId,
        role: user.role,
        name: user.name,
        phone: user.phone,
      );
      await LocalStorageService.saveLanguage(user.language);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // Update language
  Future<void> updateLanguage(String language) async {
    try {
      if (_currentUser == null) return;

      _isLoading = true;
      notifyListeners();

      await _firebaseService.updateUserLanguage(_currentUser!.userId, language);
      _currentUser = _currentUser!.copyWith(language: language);
      await LocalStorageService.saveLanguage(language);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // Load user from local storage (offline)
  Future<void> loadUserFromLocal() async {
    try {
      final userId = await LocalStorageService.getUserId();
      final role = await LocalStorageService.getUserRole();
      final name = await LocalStorageService.getUserName();
      final phone = await LocalStorageService.getUserPhone();
      final language = await LocalStorageService.getLanguage();

      if (userId != null && role != null && name != null && phone != null) {
        _currentUser = UserModel(
          userId: userId,
          name: name,
          phone: phone,
          role: role,
          language: language,
          createdAt: DateTime.now(),
        );
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = e.toString();
    }
  }

  // Clear user data
  void clearUser() {
    _currentUser = null;
    _errorMessage = null;
    notifyListeners();
  }

  // Check if user is passenger
  bool get isPassenger => _currentUser?.role == 'passenger';

  // Check if user is conductor
  bool get isConductor => _currentUser?.role == 'conductor';

  // Check if user is admin
  bool get isAdmin => _currentUser?.role == 'admin';
}
