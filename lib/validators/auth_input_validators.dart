String? validateEmail(String? value) {
  final email = value?.trim() ?? '';

  if (email.isEmpty) {
    return 'Please enter your email';
  }

  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(email)) {
    return 'Please enter a valid email';
  }

  return null;
}

String? validateLoginPassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your password';
  }

  return null;
}

String? validateRegistrationPassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your password';
  }

  if (value.length < 8) {
    return 'Password must be at least 8 characters';
  }

  return null;
}

String? validatePhoneNumber(String? value) {
  final phoneNumber = value?.trim() ?? '';

  if (phoneNumber.isEmpty) {
    return 'Please enter your phone number';
  }

  if (!RegExp(r'^\+?[0-9]{8,15}$').hasMatch(phoneNumber)) {
    return 'Please enter a valid phone number with country code '
        '(e.g. +14155552671)';
  }

  return null;
}
