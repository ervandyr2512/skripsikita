// REPOSITORY: AuthRepository
// Bertanggung jawab atas operasi terkait autentikasi & profil user.
// Saat ini menggunakan in-memory + SharedPreferences sebagai backing store.
// Bisa di-swap ke API backend nanti tanpa mengubah ViewModel.

import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_profile.dart';

class AuthRepository {
  static const _keyIsAuthenticated = 'is_authenticated';
  static const _keyHasOnboarded = 'has_onboarded';

  UserProfile? _currentUser;

  UserProfile? get currentUser => _currentUser;

  Future<bool> isAuthenticated() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsAuthenticated) ?? false;
  }

  Future<bool> hasCompletedOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyHasOnboarded) ?? false;
  }

  Future<void> setOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyHasOnboarded, true);
  }

  Future<UserProfile?> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 800));
    if (email.isEmpty || password.isEmpty) return null;
    final user = UserProfile.demo().copyWith(email: email);
    _currentUser = user;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsAuthenticated, true);
    return user;
  }

  Future<UserProfile?> register({
    required String name,
    required String email,
    required String password,
    required String nim,
    required String prodi,
    required int semester,
    required DateTime targetDefenseDate,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    final user = UserProfile(
      name: name,
      email: email,
      nim: nim,
      prodi: prodi,
      semester: semester,
      supervisor: 'Dr. Andi Wijaya, M.Cs.',
      targetDefenseDate: targetDefenseDate,
      avatarSeed: name.isNotEmpty ? name[0].toUpperCase() : 'U',
    );
    _currentUser = user;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsAuthenticated, true);
    return user;
  }

  Future<void> logout() async {
    _currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsAuthenticated, false);
  }

  Future<void> restoreSession() async {
    final auth = await isAuthenticated();
    if (auth && _currentUser == null) {
      _currentUser = UserProfile.demo();
    }
  }

  void updateProfile({String? name, String? supervisor}) {
    if (_currentUser == null) return;
    if (name != null && name.isNotEmpty) {
      _currentUser = _currentUser!.copyWith(
        name: name,
        avatarSeed: name[0].toUpperCase(),
      );
    }
    if (supervisor != null && supervisor.isNotEmpty) {
      _currentUser = _currentUser!.copyWith(supervisor: supervisor);
    }
  }
}
