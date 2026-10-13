import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/biometric_service.dart';
import '../services/storage_service.dart';

class AuthRepository {
  AuthRepository({
    required AuthService authService,
    required StorageService storage,
    required BiometricService biometrics,
  })  : _authService = authService,
        _storage = storage,
        _biometrics = biometrics;

  final AuthService _authService;
  final StorageService _storage;
  final BiometricService _biometrics;

  UserModel? currentUser() => _storage.readUser();

  Future<UserModel> login(String email, String password) async {
    final user = await _authService.login(email.trim(), password);
    await _storage.saveUser(user);
    return user;
  }

  Future<void> logout() async {
    await _storage.clearUser();
    await _storage.setBiometricEnabled(false);
  }

  bool get isBiometricEnabled => _storage.biometricEnabled;

  Future<void> setBiometricEnabled(bool value) =>
      _storage.setBiometricEnabled(value);

  Future<bool> isBiometricAvailable() => _biometrics.isAvailable();

  Future<bool> authenticate() =>
      _biometrics.authenticate('Unlock Koins Savings');
}
