import 'dart:async';

// Simple Auth service that emulates HSBC authentication
class AuthService {
  // Singleton pattern
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();
  
  // Auth state - simple boolean for now
  bool _isLoggedIn = false;
  
  // Stream controller to broadcast authentication state changes
  final _authStateController = StreamController<bool>.broadcast();
  
  // Stream getter
  Stream<bool> get authStateStream => _authStateController.stream;
  
  // Get current auth state
  bool get isLoggedIn => _isLoggedIn;
  
  // Emulate login process with multiple steps
  Future<bool> login() async {
    // Simulate secure connection establishment
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Simulate credential verification
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Simulate account status check
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Simulate profile loading
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Set login state to true
    _isLoggedIn = true;
    
    // Notify listeners
    _authStateController.add(_isLoggedIn);
    
    return _isLoggedIn;
  }
  
  // Logout
  Future<void> logout() async {
    // Simulate network request
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Set login state to false
    _isLoggedIn = false;
    
    // Notify listeners
    _authStateController.add(_isLoggedIn);
  }
  
  // Dispose resources
  void dispose() {
    _authStateController.close();
  }
} 