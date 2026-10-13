import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/app_exception.dart';
import '../../models/user_model.dart';
import '../../repositories/auth_repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._repository) : super(const AuthState());

  final AuthRepository _repository;

  Future<void> init() async {
    final user = _repository.currentUser();
    if (user == null) {
      emit(state.copyWith(status: AuthStatus.unauthenticated));
      return;
    }
    final enabled = _repository.isBiometricEnabled;
    final available = await _repository.isBiometricAvailable();
    emit(state.copyWith(
      status: enabled && available ? AuthStatus.locked : AuthStatus.authenticated,
      user: user,
      biometricEnabled: enabled,
      biometricAvailable: available,
    ));
  }

  Future<void> login(String email, String password) async {
    if (state.isSubmitting) return;
    emit(state.copyWith(isSubmitting: true, clearError: true));
    try {
      final user = await _repository.login(email, password);
      final available = await _repository.isBiometricAvailable();
      emit(state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
        isSubmitting: false,
        biometricAvailable: available,
      ));
    } on AppException catch (e) {
      emit(state.copyWith(isSubmitting: false, errorMessage: e.message));
    } catch (_) {
      emit(state.copyWith(
        isSubmitting: false,
        errorMessage: 'Something went wrong. Please try again.',
      ));
    }
  }

  Future<void> unlock() async {
    final ok = await _repository.authenticate();
    if (ok) {
      emit(state.copyWith(status: AuthStatus.authenticated, clearError: true));
    } else {
      emit(state.copyWith(errorMessage: 'Authentication failed. Please try again.'));
    }
  }

  Future<void> setBiometric(bool enable) async {
    if (!enable) {
      await _repository.setBiometricEnabled(false);
      emit(state.copyWith(biometricEnabled: false));
      return;
    }
    final ok = await _repository.authenticate();
    if (ok) {
      await _repository.setBiometricEnabled(true);
      emit(state.copyWith(biometricEnabled: true, clearError: true));
    } else {
      emit(state.copyWith(errorMessage: 'Could not verify your biometrics.'));
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    emit(AuthState(
      status: AuthStatus.unauthenticated,
      biometricAvailable: state.biometricAvailable,
    ));
  }
}
