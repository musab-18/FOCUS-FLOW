import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart' ;
import '../models/user_model.dart' ;

enum AuthState { initial, loading, authenticated, unauthenticated, error }

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  AuthState _state = AuthState.initial;
  UserModel? _user;
  String? _errorMessage;
  bool _initialized = false;

  AuthState get state => _state;
  UserModel? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _state == AuthState.authenticated;
  bool get isInitialized => _initialized;

  AuthProvider() {
    // Listen to Firebase auth state to handle app restarts / session restore
    _authService.authStateChanges.listen(_onAuthStateChanged);
  }

  Future<void> _onAuthStateChanged(User? firebaseUser) async {
    if (firebaseUser == null) {
      _state = AuthState.unauthenticated;
      _user = null;
    } else {
      // Only update from stream if we don't already have a user set
      // by signIn/signUp (to avoid the race condition)
      if (_user == null) {
        _state = AuthState.loading;
        notifyListeners();
        _user = await _authService.getCurrentUserModel();
        _state = _user != null ? AuthState.authenticated : AuthState.unauthenticated;
      } else {
        _state = AuthState.authenticated;
      }
    }
    _initialized = true;
    notifyListeners();
  }

  Future<bool> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    _state = AuthState.loading;
    _errorMessage = null;
    notifyListeners();
    try {
      _user = await _authService.signUp(name: name, email: email, password: password);
      _state = AuthState.authenticated;
      _initialized = true;
      notifyListeners();
      return true;
    } catch (e) {
      _state = AuthState.error;
      _user = null;
      _errorMessage = _parseError(e);
      notifyListeners();
      return false;
    }
  }

  Future<bool> signIn({required String email, required String password}) async {
    _state = AuthState.loading;
    _errorMessage = null;
    notifyListeners();
    try {
      _user = await _authService.signIn(email: email, password: password);
      _state = AuthState.authenticated;
      _initialized = true;
      notifyListeners();
      return true;
    } catch (e) {
      _state = AuthState.error;
      _user = null;
      _errorMessage = _parseError(e);
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _user = null;
    _state = AuthState.unauthenticated;
    notifyListeners();
  }

  Future<bool> resetPassword(String email) async {
    try {
      await _authService.resetPassword(email);
      return true;
    } catch (e) {
      _errorMessage = _parseError(e);
      notifyListeners();
      return false;
    }
  }

  Future<void> refreshUser() async {
    _user = await _authService.getCurrentUserModel();
    notifyListeners();
  }

  String _parseError(dynamic e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'email-already-in-use': return 'This email is already registered.';
        case 'invalid-email': return 'Please enter a valid email.';
        case 'weak-password': return 'Password must be at least 6 characters.';
        case 'user-not-found': return 'No account found with this email.';
        case 'wrong-password': return 'Incorrect password. Please try again.';
        case 'invalid-credential': return 'Incorrect email or password.';
        case 'too-many-requests': return 'Too many attempts. Please try later.';
        case 'network-request-failed': return 'No internet connection.';
        default: return e.message ?? 'An error occurred. Please try again.';
      }
    }
    return e.toString().contains('firebase')
        ? 'Authentication failed. Please try again.'
        : 'An error occurred. Please try again.';
  }
}
