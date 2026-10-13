part of 'auth_cubit.dart';

enum AuthStatus { unknown, unauthenticated, authenticated, locked }

class AuthState extends Equatable {
  const AuthState({
    this.status = AuthStatus.unknown,
    this.user,
    this.isSubmitting = false,
    this.errorMessage,
    this.biometricEnabled = false,
    this.biometricAvailable = false,
  });

  final AuthStatus status;
  final UserModel? user;
  final bool isSubmitting;
  final String? errorMessage;
  final bool biometricEnabled;
  final bool biometricAvailable;

  AuthState copyWith({
    AuthStatus? status,
    UserModel? user,
    bool? isSubmitting,
    String? errorMessage,
    bool clearError = false,
    bool? biometricEnabled,
    bool? biometricAvailable,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      biometricAvailable: biometricAvailable ?? this.biometricAvailable,
    );
  }

  @override
  List<Object?> get props => [
        status,
        user,
        isSubmitting,
        errorMessage,
        biometricEnabled,
        biometricAvailable,
      ];
}
