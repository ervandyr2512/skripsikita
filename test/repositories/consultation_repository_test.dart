// ============================================================================
// UNIT TEST: ConsultationRepository
// ============================================================================
//
// Menguji CRUD operasi untuk bimbingan dengan dosen, terutama logic
// pemisahan upcoming vs past dan sorting.
//
// Pola: Arrange-Act-Assert (AAA)
// ============================================================================

import 'package:flutter_test/flutter_test.dart';
import 'package:skripsikita/models/consultation.dart';
import 'package:skripsikita/repositories/consultation_repository.dart';

void main() {
  group('ConsultationRepository — READ', () {
    test('getAll() mengembalikan seed consultations', () {
      // ARRANGE
      final repo = ConsultationRepository();

      // ACT
      final all = repo.getAll();

      // ASSERT
      expect(all, isNotEmpty);
    });

    test('getUpcoming() hanya konsultasi yang belum selesai', () {
      // ARRANGE
      final repo = ConsultationRepository();

      // ACT
      final upcoming = repo.getUpcoming();

      // ASSERT
      for (final c in upcoming) {
        expect(c.completed, isFalse);
      }
    });

    test('getPast() hanya konsultasi yang sudah selesai', () {
      // ARRANGE
      final repo = ConsultationRepository();

      // ACT
      final past = repo.getPast();

      // ASSERT
      for (final c in past) {
        expect(c.completed, isTrue);
      }
    });

    test('getUpcoming() ter-sort ascending (terdekat dulu)', () {
      // ARRANGE
      final repo = ConsultationRepository();

      // ACT
      final upcoming = repo.getUpcoming();

      // ASSERT
      for (int i = 0; i < upcoming.length - 1; i++) {
        expect(
          upcoming[i].scheduledAt.isBefore(upcoming[i + 1].scheduledAt) ||
              upcoming[i].scheduledAt.isAtSameMomentAs(upcoming[i + 1].scheduledAt),
          isTrue,
        );
      }
    });

    test('getPast() ter-sort descending (terbaru dulu)', () {
      // ARRANGE
      final repo = ConsultationRepository();

      // ACT
      final past = repo.getPast();

      // ASSERT
      for (int i = 0; i < past.length - 1; i++) {
        expect(
          past[i].scheduledAt.isAfter(past[i + 1].scheduledAt) ||
              past[i].scheduledAt.isAtSameMomentAs(past[i + 1].scheduledAt),
          isTrue,
        );
      }
    });

    test('jumlah getAll() = jumlah getUpcoming() + getPast()', () {
      // ARRANGE
      final repo = ConsultationRepository();

      // ACT
      final total = repo.getAll().length;
      final upcoming = repo.getUpcoming().length;
      final past = repo.getPast().length;

      // ASSERT
      expect(total, equals(upcoming + past));
    });
  });

  group('ConsultationRepository — CREATE (add)', () {
    test('add() menambah konsultasi baru ke list', () {
      // ARRANGE
      final repo = ConsultationRepository();
      final initialCount = repo.getAll().length;
      final newConsultation = _buildConsultation();

      // ACT
      repo.add(newConsultation);

      // ASSERT
      expect(repo.getAll().length, equals(initialCount + 1));
    });

    test('add() menjaga sorted by scheduledAt', () {
      // ARRANGE
      final repo = ConsultationRepository();
      // Tambah satu di masa depan jauh
      repo.add(_buildConsultation(
        id: 'far-future',
        scheduledAt: DateTime.now().add(const Duration(days: 60)),
      ));

      // ACT
      final all = repo.getAll();

      // ASSERT
      for (int i = 0; i < all.length - 1; i++) {
        expect(
          all[i].scheduledAt.isBefore(all[i + 1].scheduledAt) ||
              all[i].scheduledAt.isAtSameMomentAs(all[i + 1].scheduledAt),
          isTrue,
        );
      }
    });
  });

  group('ConsultationRepository — UPDATE (completeWithNotes)', () {
    test('completeWithNotes() menandai konsultasi selesai', () {
      // ARRANGE
      final repo = ConsultationRepository();
      final upcoming = repo.getUpcoming().first;

      // ACT
      repo.completeWithNotes(upcoming.id, 'Bagus, lanjut BAB 2');

      // ASSERT
      final found = repo.getAll().firstWhere((c) => c.id == upcoming.id);
      expect(found.completed, isTrue);
      expect(found.notes, equals('Bagus, lanjut BAB 2'));
    });

    test('completeWithNotes() membuat konsultasi pindah dari upcoming ke past', () {
      // ARRANGE
      final repo = ConsultationRepository();
      final upcoming = repo.getUpcoming().first;
      final upcomingCountBefore = repo.getUpcoming().length;
      final pastCountBefore = repo.getPast().length;

      // ACT
      repo.completeWithNotes(upcoming.id, 'notes');

      // ASSERT
      expect(repo.getUpcoming().length, equals(upcomingCountBefore - 1));
      expect(repo.getPast().length, equals(pastCountBefore + 1));
    });

    test('completeWithNotes() pada ID yang tidak ada tidak crash', () {
      // ARRANGE
      final repo = ConsultationRepository();

      // ACT & ASSERT
      expect(
        () => repo.completeWithNotes('non-existent', 'notes'),
        returnsNormally,
      );
    });
  });

  group('ConsultationRepository — DELETE', () {
    test('delete() menghapus konsultasi sesuai ID', () {
      // ARRANGE
      final repo = ConsultationRepository();
      final consultation = repo.getAll().first;
      final initialCount = repo.getAll().length;

      // ACT
      repo.delete(consultation.id);

      // ASSERT
      expect(repo.getAll().length, equals(initialCount - 1));
    });
  });
}

Consultation _buildConsultation({
  String id = 'test-c',
  DateTime? scheduledAt,
}) {
  return Consultation(
    id: id,
    scheduledAt: scheduledAt ?? DateTime.now().add(const Duration(days: 5)),
    durationMinutes: 30,
    agenda: 'Agenda test',
    supervisorName: 'Dr. Test',
  );
}
