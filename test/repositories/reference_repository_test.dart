// ============================================================================
// UNIT TEST: ReferenceRepository
// ============================================================================
//
// Menguji CRUD + logic pencarian dan filtering referensi.
// Fokus: search() multi-parameter (query + tag) yang merupakan critical path
//        untuk fitur Reference Vault.
//
// Pola: Arrange-Act-Assert (AAA)
// ============================================================================

import 'package:flutter_test/flutter_test.dart';
import 'package:skripsikita/models/reference_item.dart';
import 'package:skripsikita/repositories/reference_repository.dart';

void main() {
  group('ReferenceRepository — READ', () {
    test('getAll() mengembalikan seed references dari MockData', () {
      // ARRANGE
      final repo = ReferenceRepository();

      // ACT
      final all = repo.getAll();

      // ASSERT
      expect(all, isNotEmpty);
      expect(all.length, greaterThanOrEqualTo(5));
    });

    test('getAllTags() selalu menyertakan "Semua" sebagai opsi pertama', () {
      // ARRANGE
      final repo = ReferenceRepository();

      // ACT
      final tags = repo.getAllTags();

      // ASSERT
      expect(tags.first, equals('Semua'));
    });

    test('getAllTags() menyertakan tag unik dari semua referensi', () {
      // ARRANGE
      final repo = ReferenceRepository();

      // ACT
      final tags = repo.getAllTags();
      final tagsFromItems = repo.getAll().map((r) => r.tag).toSet();

      // ASSERT — semua tag dari item harus muncul di getAllTags
      for (final t in tagsFromItems) {
        expect(tags.contains(t), isTrue, reason: 'Tag "$t" tidak muncul di getAllTags');
      }
    });
  });

  group('ReferenceRepository — search(query, tag)', () {
    test('search() tanpa parameter mengembalikan semua referensi', () {
      // ARRANGE
      final repo = ReferenceRepository();

      // ACT
      final results = repo.search();

      // ASSERT
      expect(results.length, equals(repo.getAll().length));
    });

    test('search(query: "consumer") menemukan referensi dengan kata "consumer"', () {
      // ARRANGE
      final repo = ReferenceRepository();

      // ACT
      final results = repo.search(query: 'consumer');

      // ASSERT
      expect(results, isNotEmpty);
      for (final r in results) {
        final matched = r.title.toLowerCase().contains('consumer') ||
            r.authors.toLowerCase().contains('consumer');
        expect(matched, isTrue);
      }
    });

    test('search() bersifat case-insensitive', () {
      // ARRANGE
      final repo = ReferenceRepository();

      // ACT
      final lowercase = repo.search(query: 'consumer');
      final uppercase = repo.search(query: 'CONSUMER');

      // ASSERT
      expect(lowercase.length, equals(uppercase.length));
    });

    test('search() bisa mencari di field authors', () {
      // ARRANGE
      final repo = ReferenceRepository();
      final firstAuthor = repo.getAll().first.authors.split(',').first;

      // ACT
      final results = repo.search(query: firstAuthor);

      // ASSERT
      expect(results, isNotEmpty);
    });

    test('search(tag: "BAB 1") mengembalikan hanya referensi tag BAB 1', () {
      // ARRANGE
      final repo = ReferenceRepository();

      // ACT
      final results = repo.search(tag: 'BAB 1');

      // ASSERT
      for (final r in results) {
        expect(r.tag, equals('BAB 1'));
      }
    });

    test('search(tag: "Semua") tidak melakukan filter tag', () {
      // ARRANGE
      final repo = ReferenceRepository();

      // ACT
      final all = repo.search(tag: 'Semua');

      // ASSERT
      expect(all.length, equals(repo.getAll().length));
    });

    test('search() kombinasi query + tag bekerja sebagai AND', () {
      // ARRANGE
      final repo = ReferenceRepository();
      // Tambah referensi yang pasti match kombinasi
      repo.add(ReferenceItem(
        id: 'specific-1',
        title: 'XYZSPESIFIK Marketing Study',
        authors: 'Test',
        year: 2024,
        tag: 'BAB 2',
        fileName: 't.pdf',
        summary: 's',
      ));

      // ACT
      final results = repo.search(query: 'XYZSPESIFIK', tag: 'BAB 2');

      // ASSERT
      expect(results.length, equals(1));
      expect(results.first.id, equals('specific-1'));
    });

    test('search() query yang tidak ada mengembalikan list kosong', () {
      // ARRANGE
      final repo = ReferenceRepository();

      // ACT
      final results = repo.search(query: 'kata-yang-pasti-tidak-ada-xyzqwerty');

      // ASSERT
      expect(results, isEmpty);
    });
  });

  group('ReferenceRepository — CREATE / UPDATE / DELETE', () {
    test('add() menambah referensi di posisi pertama (most recent)', () {
      // ARRANGE
      final repo = ReferenceRepository();
      final newRef = ReferenceItem(
        id: 'newest',
        title: 'Newest Reference',
        authors: 'Author',
        year: 2025,
        tag: 'BAB 1',
        fileName: 'newest.pdf',
        summary: 'Newest summary',
      );

      // ACT
      repo.add(newRef);

      // ASSERT — referensi baru harus muncul di indeks 0
      expect(repo.getAll().first.id, equals('newest'));
    });

    test('toggleStar() membalik nilai starred dari false ke true', () {
      // ARRANGE
      final repo = ReferenceRepository();
      final ref = repo.getAll().firstWhere((r) => !r.starred);

      // ACT
      repo.toggleStar(ref.id);

      // ASSERT
      final updated = repo.getAll().firstWhere((r) => r.id == ref.id);
      expect(updated.starred, isTrue);
    });

    test('toggleStar() dipanggil 2x kembali ke nilai semula', () {
      // ARRANGE
      final repo = ReferenceRepository();
      final ref = repo.getAll().first;
      final originalStarred = ref.starred;

      // ACT
      repo.toggleStar(ref.id);
      repo.toggleStar(ref.id);

      // ASSERT
      final finalState = repo.getAll().firstWhere((r) => r.id == ref.id);
      expect(finalState.starred, equals(originalStarred));
    });

    test('delete() menghapus referensi sesuai ID', () {
      // ARRANGE
      final repo = ReferenceRepository();
      final ref = repo.getAll().first;
      final initialCount = repo.getAll().length;

      // ACT
      repo.delete(ref.id);

      // ASSERT
      expect(repo.getAll().length, equals(initialCount - 1));
      expect(repo.getAll().any((r) => r.id == ref.id), isFalse);
    });
  });
}
