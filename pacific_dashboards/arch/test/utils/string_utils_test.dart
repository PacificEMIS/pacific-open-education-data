import 'package:flutter_test/flutter_test.dart';

import 'package:arch/arch.dart';

void main() {
  group('isNullOrEmpty', () {
    test('isNullOrEmpty true when null', () {
      expect(StringUtils.isNullOrEmpty(null), true);
    });
    test('isNullOrEmpty true when empty string passed', () {
      expect(StringUtils.isNullOrEmpty(''), true);
    });
    test('isNullOrEmpty false when non-empty string passed', () {
      expect(StringUtils.isNullOrEmpty('test'), false);
    });
  });

  group('isValidEmail', () {
    test('isValidEmail returns true when email valid', () {
      final validEmails = [
        'email@example.com',
        'firstname.lastname@example.com',
        'email@subdomain.example.com',
        'firstname+lastname@example.com',
        '"email"@example.com',
        '1234567890@example.com',
        'email@example-one.com',
        '_______@example.com',
        'email@example.name',
        'email@example.museum',
        'email@example.co.jp',
        'firstname-lastname@example.com',
        'あいうえお@example.com',
      ];
      for (var email in validEmails) {
        expect(
          email.isValidEmail(),
          true,
          reason: 'email $email is not valid!',
        );
      }
    });
    test('isValidEmail returns false when email invalid', () {
      final invalidEmails = [
        'plainaddress',
        '#@%^%#\$@#\$@#.com',
        '@example.com',
        'Joe Smith <email@example.com>',
        'email.example.com',
        'email@example@example.com',
        '.email@example.com',
        'email.@example.com',
        'email..email@example.com',
        'email@example.com (Joe Smith)',
        'email@example',
        'email@111.222.333.44444',
        'email@example..com',
        'Abc..123@example.com',
        '”(),:;<>[\\]@example.com',
        'this\\ is"really"not\\allowed@example.com',
      ];
      for (var email in invalidEmails) {
        expect(email.isValidEmail(), false, reason: 'email $email is valid!');
      }
    });
  });
}
