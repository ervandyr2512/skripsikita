// ============================================================================
// UNIT TEST: MilestoneRepository
// ============================================================================
//
// Menguji operasi CRUD untuk Milestone:
//  - CREATE: add() — milestone baru harus masuk ke list dan ter-sort by date
//  - READ:   getAll(), getByChapter(), getUpcoming()
//  - UPDATE: updateStatus(), update()
//  - DELETE: delete()
//
// Pola: Arrange-Act-Assert (AAA)
// ============================================================================

import 'package:flutter_test/flutter_test.dart';
import 'package:skripsikita/models/milestone.dart';
import 'package:skripsikita/repositories/milestone_repository.dart';

void main() {
  group('MilestoneRepository — READ operations', () {
    test('getAll() mengembalikan seed milestone dari MockData', () {
      // ARRANGE
      final repo = MilestoneRepository();

      // ACT
      final all = repo.getAll();

      // ASSERT
      expect(all, isNotEmpty);
      expect(all.length, greaterThanOrEqualTo(10));
    });

    test('getAll() mengembalikan unmodifiable list', () {
      // ARRANGE
      final repo = MilestoneRepository();
      final all = repo.getAll();

      // ACT & ASSERT
      // Memodifikasi list hasil getAll() harus throw exception.
      expect(
        () => all.add(_buildMilestone()),
        throwsUnsupportedError,
      );
    });

    test('getByChapter("BAB 1") hanya mengembalikan milestone BAB 1', () {
      // ARRANGE
      final repo = MilestoneRepository();

      // ACT
      final bab1Items = repo.getByChapter('BAB 1');

      // ASSERT
      expect(bab1Items, isNotEmpty);
      for (final m in bab1Items) {
        expect(m.chapter, equals('BAB 1'));
      }
    });

    test('getByChapter("BAB 9") mengembalikan list kosong', () {
      // ARRANGE
      final repo = MilestoneRepository();

      // ACT
      final items = repo.getByChapter('BAB 9');

      // ASSERT
      expect(items, isEmpty);
    });

    test('getUpcoming() tidak menyertakan milestone yang sudah selesai', () {
      // ARRANGE
      final repo = MilestoneRepository();

      // ACT
      final upcoming = repo.getUpcoming();

      // ASSERT
      for (final m in upcoming) {
        expect(m.status, isNot(equals(MilestoneStatus.done)));
      }
    });

    test('getUpcoming() ter-sort dari due date terdekat ke terjauh', () {
      // ARRANGE
      final repo = MilestoneRepository();

      // ACT
      final upcoming = repo.getUpcoming();

      // ASSERT
      for (int i = 0; i < upcoming.length - 1; i++) {
        expect(
          upcoming[i].dueDate.isBefore(upcoming[i + 1].dueDate) ||
              upcoming[i].dueDate.isAtSameMomentAs(upcoming[i + 1].dueDate),
          isTrue,
          reason: 'Urutan dueDate tidak sorted ascending',
        );
      }
    });
  });

  group('MilestoneRepository — CREATE (add)', () {
    test('add() menambah milestone baru ke list', () {
      // ARRANGE
      final repo = MilestoneRepository();
      final initialCount = repo.getAll().length;
      final newMilestone = _buildMilestone(id: 'new-1');

      // ACT
      repo.add(newMilestone);

      // ASSERT
      expect(repo.getAll().length, equals(initialCount + 1));
    });

    test('add() menjaga urutan sorted by dueDate', () {
      // ARRANGE
      final repo = MilestoneRepository();
      final earlyDate = DateTime.now().add(const Duration(days: 1));
      final earlyMilestone = _buildMilestone(id: 'early', dueDate: earlyDate);

      // ACT
      repo.add(earlyMilestone);

      // ASSERT
      final all = repo.getAll();
      for (int i = 0; i < all.length - 1; i++) {
        expect(
          all[i].dueDate.isBefore(all[i + 1].dueDate) ||
              all[i].dueDate.isAtSameMomentAs(all[i + 1].dueDate),
          isTrue,
        );
      }
    });

    test('add() milestone bisa diambil kembali via getAll()', () {
      // ARRANGE
      final repo = MilestoneRepository();
      final milestone = _buildMilestone(id: 'unique-test-id-001');

      // ACT
      repo.add(milestone);

      // ASSERT
      final found = repo.getAll().firstWhere(
            (m) => m.id == 'unique-test-id-001',
            orElse: () => _buildMilestone(id: 'NOT-FOUND'),
          );
      expect(found.id, equals('unique-test-id-001'));
    });
  });

  group('MilestoneRepository — UPDATE', () {
    test('updateStatus() mengubah status milestone existing', () {
      // ARRANGE
      final repo = MilestoneRepository();
      final milestone = repo.getAll().first;
      final originalStatus = milestone.status;

      // ACT
      final newStatus = originalStatus == MilestoneStatus.done
          ? MilestoneStatus.todo
          : MilestoneStatus.done;
      repo.updateStatus(milestone.id, newStatus);

      // ASSERT
      final updated = repo.getAll().firstWhere((m) => m.id == milestone.id);
      expect(updated.status, equals(newStatus));
    });

    test('updateStatus() pada ID yang tidak ada tidak crash', () {
      // ARRANGE
      final repo = MilestoneRepository();
      final initialAll = repo.getAll().length;

      // ACT
      repo.updateStatus('non-existent-id', MilestoneStatus.done);

      // ASSERT — tidak ada crash, jumlah tetap sama
      expect(repo.getAll().length, equals(initialAll));
    });

    test('update() mengganti seluruh data milestone', () {
      // ARRANGE
      final repo = MilestoneRepository();
      final original = repo.getAll().first;
      final updated = Milestone(
        id: original.id,
        title: 'JUDUL BARU DIUBAH',
        chapter: 'BAB 5',
        description: 'desc baru',
        dueDate: original.dueDate,
        status: MilestoneStatus.inProgress,
      );

      // ACT
      repo.update(updated);

      // ASSERT
      final found = repo.getAll().firstWhere((m) => m.id == original.id);
      expect(found.title, equals('JUDUL BARU DIUBAH'));
      expect(found.chapter, equals('BAB 5'));
    });
  });

  group('MilestoneRepository — DELETE', () {
    test('delete() menghapus milestone dengan ID yang sesuai', () {
      // ARRANGE
      final repo = MilestoneRepository();
      final milestone = repo.getAll().first;
      final initialCount = repo.getAll().length;

      // ACT
      repo.delete(milestone.id);

      // ASSERT
      expect(repo.getAll().length, equals(initialCount - 1));
      final stillExists = repo.getAll().any((m) => m.id == milestone.id);
      expect(stillExists, isFalse);
    });

    test('delete() ID tidak ada tidak crash & tidak mengubah list', () {
      // ARRANGE
      final repo = MilestoneRepository();
      final initialCount = repo.getAll().length;

      // ACT
      repo.delete('id-yang-tidak-ada');

      // ASSERT
      expect(repo.getAll().length, equals(initialCount));
    });
  });
}

Milestone _buildMilestone({
  String id = 'test-id',
  DateTime? dueDate,
}) {
  return Milestone(
    id: id,
    title: 'Test',
    chapter: 'BAB 1',
    description: 'desc',
    dueDate: dueDate ?? DateTime.now().add(const Duration(days: 7)),
  );
}
