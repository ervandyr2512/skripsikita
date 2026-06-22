// ============================================================================
// UNIT TEST: WellnessViewModel
// ============================================================================
//
// Menguji state management untuk mood selector:
//  - selectMood() menyimpan mood yang dipilih sebelum di-commit
//  - logSelectedMood() commit mood ke repository
//  - notifyListeners() pattern
//
// Pola: Arrange-Act-Assert (AAA)
// ============================================================================

import 'package:flutter_test/flutter_test.dart';
import 'package:skripsikita/models/mood_log.dart';
import 'package:skripsikita/repositories/wellness_repository.dart';
import 'package:skripsikita/viewmodels/wellness_viewmodel.dart';

void main() {
  group('WellnessViewModel — Initial state', () {
    test('selectedMood awalnya null (belum ada mood yang dipilih)', () {
      // ARRANGE & ACT
      final vm = WellnessViewModel(WellnessRepository());

      // ASSERT
      expect(vm.selectedMood, isNull);
    });

    test('moodHistory ter-load dari repository', () {
      // ARRANGE & ACT
      final vm = WellnessViewModel(WellnessRepository());

      // ASSERT
      expect(vm.moodHistory, isNotEmpty);
    });
  });

  group('WellnessViewModel — selectMood()', () {
    test('selectMood() mengubah state selectedMood', () {
      // ARRANGE
      final vm = WellnessViewModel(WellnessRepository());

      // ACT
      vm.selectMood(Mood.happy);

      // ASSERT
      expect(vm.selectedMood, equals(Mood.happy));
    });

    test('selectMood() memicu notifyListeners()', () {
      // ARRANGE
      final vm = WellnessViewModel(WellnessRepository());
      int notifyCount = 0;
      vm.addListener(() => notifyCount++);

      // ACT
      vm.selectMood(Mood.veryHappy);

      // ASSERT
      expect(notifyCount, equals(1));
    });

    test('selectMood() bisa dipanggil berkali-kali (ganti pilihan)', () {
      // ARRANGE
      final vm = WellnessViewModel(WellnessRepository());

      // ACT
      vm.selectMood(Mood.happy);
      vm.selectMood(Mood.sad);
      vm.selectMood(Mood.neutral);

      // ASSERT — selectedMood = pilihan terakhir
      expect(vm.selectedMood, equals(Mood.neutral));
    });
  });

  group('WellnessViewModel — logSelectedMood()', () {
    test('logSelectedMood() kembalikan false kalau belum ada mood dipilih', () {
      // ARRANGE
      final vm = WellnessViewModel(WellnessRepository());

      // ACT
      final result = vm.logSelectedMood();

      // ASSERT
      expect(result, isFalse);
    });

    test('logSelectedMood() commit mood ke history & return true', () {
      // ARRANGE
      final vm = WellnessViewModel(WellnessRepository());
      final initialHistoryCount = vm.moodHistory.length;
      vm.selectMood(Mood.happy);

      // ACT
      final result = vm.logSelectedMood();

      // ASSERT
      expect(result, isTrue);
      expect(vm.moodHistory.length, equals(initialHistoryCount + 1));
      expect(vm.moodHistory.last.mood, equals(Mood.happy));
    });

    test('logSelectedMood() reset selectedMood ke null setelah commit', () {
      // ARRANGE
      final vm = WellnessViewModel(WellnessRepository());
      vm.selectMood(Mood.happy);

      // ACT
      vm.logSelectedMood();

      // ASSERT
      expect(vm.selectedMood, isNull);
    });

    test('logSelectedMood() memicu notifyListeners() saat sukses', () {
      // ARRANGE
      final vm = WellnessViewModel(WellnessRepository());
      vm.selectMood(Mood.happy);
      int notifyCount = 0;
      vm.addListener(() => notifyCount++);

      // ACT
      vm.logSelectedMood();

      // ASSERT
      expect(notifyCount, equals(1));
    });
  });

  group('WellnessViewModel — averageScore', () {
    test('averageScore berada di rentang valid 1.0 - 5.0', () {
      // ARRANGE
      final vm = WellnessViewModel(WellnessRepository());

      // ACT
      final avg = vm.averageScore;

      // ASSERT
      expect(avg, greaterThanOrEqualTo(1.0));
      expect(avg, lessThanOrEqualTo(5.0));
    });

    test('averageScore berubah setelah commit mood baru', () {
      // ARRANGE — pakai repo fresh tanpa seed agar deterministik
      final repo = WellnessRepository();
      for (final log in [...repo.getAll()]) {
        repo.deleteLog(log.loggedAt);
      }
      final vm = WellnessViewModel(repo);

      // ACT — log mood very sad (skor 1)
      vm.selectMood(Mood.verySad);
      vm.logSelectedMood();

      // ASSERT
      expect(vm.averageScore, equals(1.0));
    });
  });

  group('WellnessViewModel — wellnessContent', () {
    test('wellnessContent ter-expose dari repository', () {
      // ARRANGE
      final vm = WellnessViewModel(WellnessRepository());

      // ACT
      final content = vm.wellnessContent;

      // ASSERT
      expect(content, isNotEmpty);
    });
  });
}
