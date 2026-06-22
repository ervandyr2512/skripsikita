// ============================================================================
// UNIT TEST: UserProfile Model
// ============================================================================
//
// Menguji:
//  - Konstruktor
//  - Factory method demo()
//  - copyWith pattern (immutable update)
//
// Pola: Arrange-Act-Assert (AAA)
// ============================================================================

import 'package:flutter_test/flutter_test.dart';
import 'package:skripsikita/models/user_profile.dart';

void main() {
  group('UserProfile — Konstruktor', () {
    test('membuat UserProfile dengan field wajib', () {
      // ARRANGE
      final targetDate = DateTime(2026, 9, 15);

      // ACT
      final user = UserProfile(
        name: 'Ervandy',
        email: 'ervandy@uc.ac.id',
        nim: '12345',
        prodi: 'S1 Informatika',
        semester: 8,
        supervisor: 'Dr. X',
        targetDefenseDate: targetDate,
      );

      // ASSERT
      expect(user.name, equals('Ervandy'));
      expect(user.email, equals('ervandy@uc.ac.id'));
      expect(user.targetDefenseDate, equals(targetDate));
    });

    test('avatarSeed default-nya "R"', () {
      // ARRANGE & ACT
      final user = UserProfile(
        name: 'Test',
        email: 'test@test.com',
        nim: '1',
        prodi: 'P',
        semester: 7,
        supervisor: 'S',
        targetDefenseDate: DateTime.now(),
      );

      // ASSERT
      expect(user.avatarSeed, equals('R'));
    });
  });

  group('UserProfile — Factory demo()', () {
    test('demo() menghasilkan user dengan email format kampus', () {
      // ARRANGE & ACT
      final demo = UserProfile.demo();

      // ASSERT
      expect(demo.email, contains('@student.uc.ac.id'));
    });

    test('demo() target sidang ~120 hari dari sekarang', () {
      // ARRANGE
      final now = DateTime.now();

      // ACT
      final demo = UserProfile.demo();
      final daysUntilDefense = demo.targetDefenseDate.difference(now).inDays;

      // ASSERT — boleh selisih 1 hari karena waktu eksekusi
      expect(daysUntilDefense, greaterThanOrEqualTo(119));
      expect(daysUntilDefense, lessThanOrEqualTo(121));
    });

    test('demo() memiliki nama default Rina Pratiwi', () {
      // ARRANGE & ACT
      final demo = UserProfile.demo();

      // ASSERT
      expect(demo.name, equals('Rina Pratiwi'));
      expect(demo.semester, equals(8));
    });
  });

  group('UserProfile — copyWith (immutable update pattern)', () {
    test('copyWith tanpa argumen menghasilkan instance identik', () {
      // ARRANGE
      final original = UserProfile.demo();

      // ACT
      final copy = original.copyWith();

      // ASSERT
      expect(copy.name, equals(original.name));
      expect(copy.email, equals(original.email));
      expect(copy.nim, equals(original.nim));
      expect(copy.semester, equals(original.semester));
    });

    test('copyWith dengan nama baru hanya mengubah nama', () {
      // ARRANGE
      final original = UserProfile.demo();
      const newName = 'Ervandy R';

      // ACT
      final copy = original.copyWith(name: newName);

      // ASSERT
      expect(copy.name, equals(newName));
      expect(copy.email, equals(original.email));  // tetap sama
      expect(copy.nim, equals(original.nim));      // tetap sama
    });

    test('copyWith dapat mengubah beberapa field sekaligus', () {
      // ARRANGE
      final original = UserProfile.demo();

      // ACT
      final copy = original.copyWith(
        name: 'New Name',
        semester: 10,
        avatarSeed: 'N',
      );

      // ASSERT
      expect(copy.name, equals('New Name'));
      expect(copy.semester, equals(10));
      expect(copy.avatarSeed, equals('N'));
      expect(copy.email, equals(original.email)); // tidak diubah
    });

    test('copyWith tidak memutasi instance original', () {
      // ARRANGE
      final original = UserProfile.demo();
      final originalName = original.name;

      // ACT
      original.copyWith(name: 'Changed');

      // ASSERT — original tidak berubah
      expect(original.name, equals(originalName));
    });
  });
}
