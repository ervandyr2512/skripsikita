// ============================================================================
// UNIT TEST: TimelineViewModel
// ============================================================================
//
// Menguji business logic ViewModel — state management & computed properties
// yang menggabungkan data dari Repository.
//
// Fokus utama:
//  - filter setFilter() & filteredMilestones
//  - overallProgress (perhitungan persentase selesai)
//  - chapterProgress (per BAB)
//  - notifyListeners() dipanggil saat state berubah
//
// Pola: Arrange-Act-Assert (AAA)
// ============================================================================

import 'package:flutter_test/flutter_test.dart';
import 'package:skripsikita/models/milestone.dart';
import 'package:skripsikita/repositories/milestone_repository.dart';
import 'package:skripsikita/viewmodels/timeline_viewmodel.dart';

void main() {
  group('TimelineViewModel — Initial state', () {
    test('filter default-nya "Semua"', () {
      // ARRANGE & ACT
      final vm = TimelineViewModel(MilestoneRepository());

      // ASSERT
      expect(vm.filterChapter, equals('Semua'));
    });

    test('allMilestones tidak kosong (ada seed data)', () {
      // ARRANGE & ACT
      final vm = TimelineViewModel(MilestoneRepository());

      // ASSERT
      expect(vm.allMilestones, isNotEmpty);
    });
  });

  group('TimelineViewModel — setFilter', () {
    test('setFilter("BAB 2") mengubah state filterChapter', () {
      // ARRANGE
      final vm = TimelineViewModel(MilestoneRepository());

      // ACT
      vm.setFilter('BAB 2');

      // ASSERT
      expect(vm.filterChapter, equals('BAB 2'));
    });

    test('setFilter() memicu notifyListeners() (untuk rebuild UI)', () {
      // ARRANGE
      final vm = TimelineViewModel(MilestoneRepository());
      int listenerCallCount = 0;
      vm.addListener(() => listenerCallCount++);

      // ACT
      vm.setFilter('BAB 3');

      // ASSERT
      expect(listenerCallCount, equals(1));
    });

    test('filteredMilestones dengan filter "Semua" = allMilestones', () {
      // ARRANGE
      final vm = TimelineViewModel(MilestoneRepository());

      // ACT
      vm.setFilter('Semua');

      // ASSERT
      expect(vm.filteredMilestones.length, equals(vm.allMilestones.length));
    });

    test('filteredMilestones dengan filter "BAB 2" hanya milestone BAB 2', () {
      // ARRANGE
      final vm = TimelineViewModel(MilestoneRepository());

      // ACT
      vm.setFilter('BAB 2');

      // ASSERT
      for (final m in vm.filteredMilestones) {
        expect(m.chapter, equals('BAB 2'));
      }
    });
  });

  group('TimelineViewModel — CRUD operations', () {
    test('addMilestone() menambah milestone & notify listeners', () {
      // ARRANGE
      final vm = TimelineViewModel(MilestoneRepository());
      final initialCount = vm.allMilestones.length;
      int notifyCount = 0;
      vm.addListener(() => notifyCount++);

      // ACT
      vm.addMilestone(_buildMilestone('new-1'));

      // ASSERT
      expect(vm.allMilestones.length, equals(initialCount + 1));
      expect(notifyCount, equals(1));
    });

    test('updateStatus() mengubah status & notify listeners', () {
      // ARRANGE
      final vm = TimelineViewModel(MilestoneRepository());
      final milestone = vm.allMilestones.first;
      int notifyCount = 0;
      vm.addListener(() => notifyCount++);

      // ACT
      vm.updateStatus(milestone.id, MilestoneStatus.done);

      // ASSERT
      expect(notifyCount, equals(1));
      final updated = vm.allMilestones.firstWhere((m) => m.id == milestone.id);
      expect(updated.status, equals(MilestoneStatus.done));
    });

    test('deleteMilestone() menghapus milestone & notify listeners', () {
      // ARRANGE
      final vm = TimelineViewModel(MilestoneRepository());
      final milestone = vm.allMilestones.first;
      final initialCount = vm.allMilestones.length;
      int notifyCount = 0;
      vm.addListener(() => notifyCount++);

      // ACT
      vm.deleteMilestone(milestone.id);

      // ASSERT
      expect(vm.allMilestones.length, equals(initialCount - 1));
      expect(notifyCount, equals(1));
    });
  });

  group('TimelineViewModel — Computed properties', () {
    test('overallProgress 0.0 ketika semua milestone TODO', () {
      // ARRANGE — buat repo kosong lalu isi semua TODO
      final repo = MilestoneRepository();
      // Hapus semua existing & tambah 3 baru semua todo
      for (final m in [...repo.getAll()]) {
        repo.delete(m.id);
      }
      repo.add(_buildMilestone('a', status: MilestoneStatus.todo));
      repo.add(_buildMilestone('b', status: MilestoneStatus.todo));
      repo.add(_buildMilestone('c', status: MilestoneStatus.todo));
      final vm = TimelineViewModel(repo);

      // ACT
      final progress = vm.overallProgress;

      // ASSERT
      expect(progress, equals(0.0));
    });

    test('overallProgress 1.0 ketika semua milestone DONE', () {
      // ARRANGE
      final repo = MilestoneRepository();
      for (final m in [...repo.getAll()]) {
        repo.delete(m.id);
      }
      repo.add(_buildMilestone('a', status: MilestoneStatus.done));
      repo.add(_buildMilestone('b', status: MilestoneStatus.done));
      final vm = TimelineViewModel(repo);

      // ACT
      final progress = vm.overallProgress;

      // ASSERT
      expect(progress, equals(1.0));
    });

    test('overallProgress 0.5 ketika setengah selesai', () {
      // ARRANGE — 2 done, 2 todo
      final repo = MilestoneRepository();
      for (final m in [...repo.getAll()]) {
        repo.delete(m.id);
      }
      repo.add(_buildMilestone('a', status: MilestoneStatus.done));
      repo.add(_buildMilestone('b', status: MilestoneStatus.done));
      repo.add(_buildMilestone('c', status: MilestoneStatus.todo));
      repo.add(_buildMilestone('d', status: MilestoneStatus.todo));
      final vm = TimelineViewModel(repo);

      // ACT
      final progress = vm.overallProgress;

      // ASSERT
      expect(progress, equals(0.5));
    });

    test('overallProgress 0 ketika tidak ada milestone (avoid div by zero)', () {
      // ARRANGE
      final repo = MilestoneRepository();
      for (final m in [...repo.getAll()]) {
        repo.delete(m.id);
      }
      final vm = TimelineViewModel(repo);

      // ACT
      final progress = vm.overallProgress;

      // ASSERT
      expect(progress, equals(0.0));
    });

    test('chapterProgress mengembalikan map untuk BAB 1-5', () {
      // ARRANGE
      final vm = TimelineViewModel(MilestoneRepository());

      // ACT
      final progress = vm.chapterProgress;

      // ASSERT
      expect(progress.keys, containsAll(['BAB 1', 'BAB 2', 'BAB 3', 'BAB 4', 'BAB 5']));
    });

    test('chapterProgress per BAB berada di rentang 0-1', () {
      // ARRANGE
      final vm = TimelineViewModel(MilestoneRepository());

      // ACT
      final progress = vm.chapterProgress;

      // ASSERT
      for (final value in progress.values) {
        expect(value, greaterThanOrEqualTo(0.0));
        expect(value, lessThanOrEqualTo(1.0));
      }
    });

    test('doneCount selalu <= totalCount', () {
      // ARRANGE
      final vm = TimelineViewModel(MilestoneRepository());

      // ACT & ASSERT
      expect(vm.doneCount, lessThanOrEqualTo(vm.totalCount));
    });
  });
}

Milestone _buildMilestone(String id, {MilestoneStatus status = MilestoneStatus.todo}) {
  return Milestone(
    id: id,
    title: 'Test $id',
    chapter: 'BAB 1',
    description: 'desc',
    dueDate: DateTime.now().add(const Duration(days: 7)),
    status: status,
  );
}
