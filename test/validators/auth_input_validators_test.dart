import 'package:cafe_frontend/validators/auth_input_validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('validateEmail', () {
    test('rejects an empty value', () {
      expect(validateEmail(null), 'Please enter your email');
      expect(validateEmail('   '), 'Please enter your email');
    });

    test('rejects a malformed email', () {
      expect(validateEmail('coffee@example'), 'Please enter a valid email');
    });

    test('accepts a valid email and trims surrounding whitespace', () {
      expect(validateEmail(' coffee@example.com '), isNull);
    });
  });

  group('validateLoginPassword', () {
    test('rejects an empty password', () {
      expect(validateLoginPassword(null), 'Please enter your password');
      expect(validateLoginPassword(''), 'Please enter your password');
    });

    test('accepts a non-empty password', () {
      expect(validateLoginPassword('password'), isNull);
    });
  });

  group('validateRegistrationPassword', () {
    test('rejects an empty password', () {
      expect(validateRegistrationPassword(null), 'Please enter your password');
    });

    test('rejects a seven-character password', () {
      expect(
        validateRegistrationPassword('1234567'),
        'Password must be at least 8 characters',
      );
    });

    test('accepts an eight-character password', () {
      expect(validateRegistrationPassword('12345678'), isNull);
    });
  });

  group('validatePhoneNumber', () {
    test('rejects an empty phone number', () {
      expect(validatePhoneNumber(null), 'Please enter your phone number');
      expect(validatePhoneNumber('   '), 'Please enter your phone number');
    });

    test('rejects an invalid phone number', () {
      expect(
        validatePhoneNumber('+855 12 345 678'),
        'Please enter a valid phone number with country code '
        '(e.g. +14155552671)',
      );
      expect(
        validatePhoneNumber('1234567'),
        'Please enter a valid phone number with country code '
        '(e.g. +14155552671)',
      );
    });

    test('accepts 8 to 15 digits with an optional country-code prefix', () {
      expect(validatePhoneNumber('12345678'), isNull);
      expect(validatePhoneNumber(' +14155552671 '), isNull);
      expect(validatePhoneNumber('123456789012345'), isNull);
    });
  });
}
