// ============================================================================
// UNIT TEST: MoodLog Model
// ============================================================================
//
// Menguji mapping enum Mood ke representasi UI:
//  - emoji (untuk display)
//  - label (Bahasa Indonesia)
//  - score (1-5 untuk grafik & rata-rata)
//
// Pola: Arrange-Act-Assert (AAA)
// ============================================================================

import 'package:flutter_test/flutter_test.dart';
import 'package:skripsikita/models/mood_log.dart';

void main() {
  group('MoodLog — emoji mapping', () {
    test('Mood.veryHappy → emoji 😄', () {
      // ARRANGE
      final log = MoodLog(loggedAt: DateTime.now(), mood: Mood.veryHappy);

      // ACT
      final emoji = log.emoji;

      // ASSERT
      expect(emoji, equals('😄'));
    });

    test('Mood.happy → emoji 🙂', () {
      // ARRANGE
      final log = MoodLog(loggedAt: DateTime.now(), mood: Mood.happy);

      // ACT
      final emoji = log.emoji;

      // ASSERT
      expect(emoji, equals('🙂'));
    });

    test('Mood.neutral → emoji 😐', () {
      // ARRANGE
      final log = MoodLog(loggedAt: DateTime.now(), mood: Mood.neutral);

      // ACT
      final emoji = log.emoji;

      // ASSERT
      expect(emoji, equals('😐'));
    });

    test('Mood.sad → emoji 😟', () {
      // ARRANGE
      final log = MoodLog(loggedAt: DateTime.now(), mood: Mood.sad);

      // ACT
      final emoji = log.emoji;

      // ASSERT
      expect(emoji, equals('😟'));
    });

    test('Mood.verySad → emoji 😢', () {
      // ARRANGE
      final log = MoodLog(loggedAt: DateTime.now(), mood: Mood.verySad);

      // ACT
      final emoji = log.emoji;

      // ASSERT
      expect(emoji, equals('😢'));
    });
  });

  group('MoodLog — score mapping (untuk perhitungan rata-rata)', () {
    test('Mood.veryHappy memiliki score 5 (skor tertinggi)', () {
      // ARRANGE & ACT
      final score = MoodLog(loggedAt: DateTime.now(), mood: Mood.veryHappy).score;

      // ASSERT
      expect(score, equals(5));
    });

    test('Mood.happy memiliki score 4', () {
      // ARRANGE & ACT
      final score = MoodLog(loggedAt: DateTime.now(), mood: Mood.happy).score;

      // ASSERT
      expect(score, equals(4));
    });

    test('Mood.neutral memiliki score 3 (tengah)', () {
      // ARRANGE & ACT
      final score = MoodLog(loggedAt: DateTime.now(), mood: Mood.neutral).score;

      // ASSERT
      expect(score, equals(3));
    });

    test('Mood.sad memiliki score 2', () {
      // ARRANGE & ACT
      final score = MoodLog(loggedAt: DateTime.now(), mood: Mood.sad).score;

      // ASSERT
      expect(score, equals(2));
    });

    test('Mood.verySad memiliki score 1 (skor terendah)', () {
      // ARRANGE & ACT
      final score = MoodLog(loggedAt: DateTime.now(), mood: Mood.verySad).score;

      // ASSERT
      expect(score, equals(1));
    });

    test('semua score berada di rentang valid 1-5', () {
      // ARRANGE
      final allMoods = Mood.values;

      // ACT
      final scores = allMoods.map(
        (m) => MoodLog(loggedAt: DateTime.now(), mood: m).score,
      );

      // ASSERT
      for (final score in scores) {
        expect(score, greaterThanOrEqualTo(1));
        expect(score, lessThanOrEqualTo(5));
      }
    });
  });

  group('MoodLog — label mapping (Bahasa Indonesia)', () {
    test('Mood.veryHappy → "Sangat senang"', () {
      // ARRANGE & ACT
      final label = MoodLog(loggedAt: DateTime.now(), mood: Mood.veryHappy).label;

      // ASSERT
      expect(label, equals('Sangat senang'));
    });

    test('Mood.happy → "Senang"', () {
      expect(
        MoodLog(loggedAt: DateTime.now(), mood: Mood.happy).label,
        equals('Senang'),
      );
    });

    test('Mood.neutral → "Biasa saja"', () {
      expect(
        MoodLog(loggedAt: DateTime.now(), mood: Mood.neutral).label,
        equals('Biasa saja'),
      );
    });

    test('Mood.sad → "Sedih"', () {
      expect(
        MoodLog(loggedAt: DateTime.now(), mood: Mood.sad).label,
        equals('Sedih'),
      );
    });

    test('Mood.verySad → "Sangat sedih"', () {
      expect(
        MoodLog(loggedAt: DateTime.now(), mood: Mood.verySad).label,
        equals('Sangat sedih'),
      );
    });
  });

  group('MoodLog — konsistensi score & ordinal', () {
    test('score lebih tinggi mencerminkan mood lebih positif', () {
      // ARRANGE
      final happy = MoodLog(loggedAt: DateTime.now(), mood: Mood.happy);
      final sad = MoodLog(loggedAt: DateTime.now(), mood: Mood.sad);

      // ACT & ASSERT
      expect(happy.score, greaterThan(sad.score));
    });

    test('MoodLog dapat menyimpan catatan opsional', () {
      // ARRANGE
      const note = 'Hari ini lelah karena begadang revisi';

      // ACT
      final log = MoodLog(
        loggedAt: DateTime.now(),
        mood: Mood.sad,
        note: note,
      );

      // ASSERT
      expect(log.note, equals(note));
    });

    test('note bisa null', () {
      // ARRANGE & ACT
      final log = MoodLog(loggedAt: DateTime.now(), mood: Mood.happy);

      // ASSERT
      expect(log.note, isNull);
    });
  });
}
