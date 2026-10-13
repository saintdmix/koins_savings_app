class Validators {
  Validators._();

  static final RegExp _emailRegex =
      RegExp(r'^[\w.+\-]+@([\w\-]+\.)+[\w\-]{2,}$');

  static String? email(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Email is required';
    if (!_emailRegex.hasMatch(v)) return 'Enter a valid email address';
    return null;
  }

  static String? password(String? value) {
    final v = value ?? '';
    if (v.isEmpty) return 'Password is required';
    if (v.length < 8) return 'Password must be at least 8 characters';
    return null;
  }

  static String? required(String? value, String label) {
    if (value == null || value.trim().isEmpty) return '$label is required';
    return null;
  }

  static String? positiveNumber(String? value, String label) {
    final requiredError = required(value, label);
    if (requiredError != null) return requiredError;
    final n = int.tryParse(value!.trim());
    if (n == null || n <= 0) return '$label must be greater than 0';
    return null;
  }

  static String? monthlyContribution(String? value, String? targetAmount) {
    final error = positiveNumber(value, 'Monthly contribution');
    if (error != null) return error;
    final target = int.tryParse(targetAmount?.trim() ?? '');
    final monthly = int.parse(value!.trim());
    if (target != null && monthly > target) {
      return 'Cannot be more than the target amount';
    }
    return null;
  }
}
