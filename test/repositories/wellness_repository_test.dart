// ============================================================================
// UNIT TEST: WellnessRepository
// ============================================================================
//
// Menguji:
//  - CRUD mood log
//  - Calculation: getAverageScore(lastDays)
//  - Filter: getLast(days)
//  - getWellnessContent()
//
// Pola: Arrange-Act-Assert (AAA)
// ============================================================================

import 'package:flutter_test/flutter_test.dart';
import 'package:skripsikita/models/mood_log.dart';
import 'package:skripsikita/repositories/wellness_repository.dart';

void main() {
  group('WellnessRepository — READ', () {
    test('getAll() mengembalikan seed mood logs', () {
      // ARRANGE
      final repo = WellnessRepository();

      // ACT
      final logs = repo.getAll();

      // ASSERT
      expect(logs, isNotEmpty);
    });

    test('getWellnessContent() berisi minimal 1 konten wellness', () {
      // ARRANGE
      final repo = WellnessRepository();

      // ACT
      final content = repo.getWellnessContent();

      // ASSERT
      expect(content, isNotEmpty);
      // Setiap konten harus punya field title
      for (final c in content) {
        expect(c['title'], isNotNull);
        expect(c['title'], isA<String>());
      }
    });
  });

  group('WellnessRepository — CREATE (logMood)', () {
    test('logMood() menambah entry baru di history', () {
      // ARRANGE
      final repo = WellnessRepository();
      final initialCount = repo.getAll().length;

      // ACT
      repo.logMood(Mood.happy);

      // ASSERT
      expect(repo.getAll().length, equals(initialCount + 1));
    });

    test('logMood() menyimpan mood yang benar dengan timestamp sekarang', () {
      // ARRANGE
      final repo = WellnessRepository();
      final beforeLog = DateTime.now();

      // ACT
      repo.logMood(Mood.verySad);

      // ASSERT
      final lastLog = repo.getAll().last;
      expect(lastLog.mood, equals(Mood.verySad));
      expect(
        lastLog.loggedAt.isAfter(beforeLog.subtract(const Duration(seconds: 1))),
        isTrue,
      );
    });

    test('logMood() dengan note menyimpan note tersebut', () {
      // ARRANGE
      final repo = WellnessRepository();
      const note = 'Hari ini melelahkan';

      // ACT
      repo.logMood(Mood.sad, note: note);

      // ASSERT
      expect(repo.getAll().last.note, equals(note));
    });
  });

  group('WellnessRepository — getAverageScore (calculation)', () {
    test('rata-rata default 7 hari berada di rentang 1-5', () {
      // ARRANGE
      final repo = WellnessRepository();

      // ACT
      final avg = repo.getAverageScore();

      // ASSERT
      expect(avg, greaterThanOrEqualTo(1.0));
      expect(avg, lessThanOrEqualTo(5.0));
    });

    test('rata-rata dengan hanya Mood.veryHappy menghasilkan 5.0', () {
      // ARRANGE — buat repo baru dan log 3 mood semuanya veryHappy
      final repo = WellnessRepository();
      // Hapus seed agar perhitungan deterministik
      for (final log in [...repo.getAll()]) {
        repo.deleteLog(log.loggedAt);
      }
      repo.logMood(Mood.veryHappy);
      repo.logMood(Mood.veryHappy);
      repo.logMood(Mood.veryHappy);

      // ACT
      final avg = repo.getAverageScore(lastDays: 7);

      // ASSERT
      expect(avg, equals(5.0));
    });

    test('rata-rata dengan campuran mood menghasilkan rata-rata aritmatika', () {
      // ARRANGE
      final repo = WellnessRepository();
      for (final log in [...repo.getAll()]) {
        repo.deleteLog(log.loggedAt);
      }
      repo.logMood(Mood.veryHappy); // 5
      repo.logMood(Mood.neutral);   // 3
      repo.logMood(Mood.verySad);   // 1
      // Ekspektasi: (5+3+1)/3 = 3.0

      // ACT
      final avg = repo.getAverageScore(lastDays: 7);

      // ASSERT
      expect(avg, equals(3.0));
    });

    test('rata-rata default 3.0 kalau tidak ada log dalam rentang', () {
      // ARRANGE — repo kosong (tidak ada log dalam 7 hari terakhir)
      final repo = WellnessRepository();
      for (final log in [...repo.getAll()]) {
        repo.deleteLog(log.loggedAt);
      }

      // ACT
      final avg = repo.getAverageScore(lastDays: 7);

      // ASSERT
      expect(avg, equals(3.0));
    });
  });

  group('WellnessRepository — getLast (filter by days)', () {
    test('getLast(7) hanya mengembalikan log dalam 7 hari terakhir', () {
      // ARRANGE
      final repo = WellnessRepository();
      final cutoff = DateTime.now().subtract(const Duration(days: 7));

      // ACT
      final recent = repo.getLast(7);

      // ASSERT
      for (final log in recent) {
        expect(log.loggedAt.isAfter(cutoff), isTrue);
      }
    });

    test('getLast(0) mengembalikan list kosong', () {
      // ARRANGE
      final repo = WellnessRepository();

      // ACT
      final result = repo.getLast(0);

      // ASSERT
      expect(result, isEmpty);
    });

    test('getLast(365) mengembalikan log lebih banyak/sama dengan getLast(7)', () {
      // ARRANGE
      final repo = WellnessRepository();

      // ACT
      final week = repo.getLast(7);
      final year = repo.getLast(365);

      // ASSERT
      expect(year.length, greaterThanOrEqualTo(week.length));
    });
  });
}
