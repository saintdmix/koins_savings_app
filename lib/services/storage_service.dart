import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants.dart';
import '../models/savings_plan.dart';
import '../models/user_model.dart';

class StorageService {
  StorageService(this._prefs);

  final SharedPreferences _prefs;

  UserModel? readUser() {
    final raw = _prefs.getString(AppConstants.userStorageKey);
    if (raw == null) return null;
    try {
      return UserModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  Future<void> saveUser(UserModel user) =>
      _prefs.setString(AppConstants.userStorageKey, jsonEncode(user.toJson()));

  Future<void> clearUser() => _prefs.remove(AppConstants.userStorageKey);

  List<SavingsPlan> readPlans() {
    final raw = _prefs.getString(AppConstants.plansStorageKey);
    if (raw == null) return [];
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) => SavingsPlan.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> savePlans(List<SavingsPlan> plans) => _prefs.setString(
        AppConstants.plansStorageKey,
        jsonEncode(plans.map((p) => p.toJson()).toList()),
      );

  bool get biometricEnabled =>
      _prefs.getBool(AppConstants.biometricStorageKey) ?? false;

  Future<void> setBiometricEnabled(bool value) =>
      _prefs.setBool(AppConstants.biometricStorageKey, value);
}
