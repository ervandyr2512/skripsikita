// VIEWMODEL: AuthViewModel
// Mengelola state & logic terkait autentikasi pengguna.
// View memanggil method di sini, ViewModel berkomunikasi dengan Repository.

import 'package:flutter/foundation.dart';

import '../models/user_profile.dart';
import '../repositories/auth_repository.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _repository;

  AuthViewModel(this._repository) {
    _bootstrap();
  }

  // ====== STATE ======
  bool _isAuthenticated = false;
  bool _hasCompletedOnboarding = false;
  bool _isLoading = false;
  String? _errorMessage;

  bool get isAuthenticated => _isAuthenticated;
  bool get hasCompletedOnboarding => _hasCompletedOnboarding;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  UserProfile? get user => _repository.currentUser;

  // ====== INITIALIZATION ======
  Future<void> _bootstrap() async {
    _isAuthenticated = await _repository.isAuthenticated();
    _hasCompletedOnboarding = await _repository.hasCompletedOnboarding();
    await _repository.restoreSession();
    notifyListeners();
  }

  // ====== ACTIONS ======
  Future<void> completeOnboarding() async {
    await _repository.setOnboardingCompleted();
    _hasCompletedOnboarding = true;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final user = await _repository.login(email, password);
    _isLoading = false;

    if (user == null) {
      _errorMessage = 'Login gagal. Cek email & password kamu.';
      notifyListeners();
      return false;
    }

    _isAuthenticated = true;
    notifyListeners();
    return true;
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String nim,
    required String prodi,
    required int semester,
    required DateTime targetDefenseDate,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final user = await _repository.register(
      name: name,
      email: email,
      password: password,
      nim: nim,
      prodi: prodi,
      semester: semester,
      targetDefenseDate: targetDefenseDate,
    );

    _isLoading = false;
    if (user == null) {
      _errorMessage = 'Registrasi gagal.';
      notifyListeners();
      return false;
    }

    _isAuthenticated = true;
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    await _repository.logout();
    _isAuthenticated = false;
    notifyListeners();
  }

  void updateProfile({String? name, String? supervisor}) {
    _repository.updateProfile(name: name, supervisor: supervisor);
    notifyListeners();
  }

  // ====== COMPUTED PROPERTIES ======
  int get daysUntilDefense {
    if (user == null) return 0;
    return user!.targetDefenseDate.difference(DateTime.now()).inDays;
  }
}
