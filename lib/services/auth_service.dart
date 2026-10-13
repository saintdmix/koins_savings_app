import '../core/app_exception.dart';
import '../core/constants.dart';
import '../models/user_model.dart';

class AuthService {
  AuthService({this.latency = const Duration(milliseconds: 900)});

  final Duration latency;

  static const _mockUser = UserModel(
    id: 'usr_001',
    fullName: 'John Doe',
    email: AppConstants.mockEmail,
    phone: '+234 801 234 5678',
  );

  Future<UserModel> login(String email, String password) async {
    await Future<void>.delayed(latency);
    final validEmail = email.trim().toLowerCase() == AppConstants.mockEmail;
    final validPassword = password == AppConstants.mockPassword;
    if (validEmail && validPassword) return _mockUser;
    throw const AppException('Invalid email or password');
  }
}
