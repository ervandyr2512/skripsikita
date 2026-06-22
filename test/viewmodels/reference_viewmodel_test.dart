// ============================================================================
// UNIT TEST: ReferenceViewModel
// ============================================================================
//
// Menguji:
//  - setQuery() & setFilterTag() mengubah state
//  - filteredReferences mengikuti query/tag
//  - CRUD operations + notifyListeners
//
// Pola: Arrange-Act-Assert (AAA)
// ============================================================================

import 'package:flutter_test/flutter_test.dart';
import 'package:skripsikita/models/reference_item.dart';
import 'package:skripsikita/repositories/reference_repository.dart';
import 'package:skripsikita/viewmodels/reference_viewmodel.dart';

void main() {
  group('ReferenceViewModel — Initial state', () {
    test('query default kosong', () {
      // ARRANGE & ACT
      final vm = ReferenceViewModel(ReferenceRepository());

      // ASSERT
      expect(vm.query, equals(''));
    });

    test('filterTag default "Semua"', () {
      // ARRANGE & ACT
      final vm = ReferenceViewModel(ReferenceRepository());

      // ASSERT
      expect(vm.filterTag, equals('Semua'));
    });

    test('totalCount > 0 ada seed data', () {
      // ARRANGE & ACT
      final vm = ReferenceViewModel(ReferenceRepository());

      // ASSERT
      expect(vm.totalCount, greaterThan(0));
    });
  });

  group('ReferenceViewModel — Search & Filter', () {
    test('setQuery() update state & notify listeners', () {
      // ARRANGE
      final vm = ReferenceViewModel(ReferenceRepository());
      int notifyCount = 0;
      vm.addListener(() => notifyCount++);

      // ACT
      vm.setQuery('marketing');

      // ASSERT
      expect(vm.query, equals('marketing'));
      expect(notifyCount, equals(1));
    });

    test('setFilterTag() update state & notify listeners', () {
      // ARRANGE
      final vm = ReferenceViewModel(ReferenceRepository());
      int notifyCount = 0;
      vm.addListener(() => notifyCount++);

      // ACT
      vm.setFilterTag('BAB 2');

      // ASSERT
      expect(vm.filterTag, equals('BAB 2'));
      expect(notifyCount, equals(1));
    });

    test('filteredReferences menyaring sesuai query', () {
      // ARRANGE
      final vm = ReferenceViewModel(ReferenceRepository());
      vm.setQuery('consumer');

      // ACT
      final filtered = vm.filteredReferences;

      // ASSERT
      for (final r in filtered) {
        final matched = r.title.toLowerCase().contains('consumer') ||
            r.authors.toLowerCase().contains('consumer');
        expect(matched, isTrue);
      }
    });

    test('filteredReferences menyaring sesuai tag', () {
      // ARRANGE
      final vm = ReferenceViewModel(ReferenceRepository());
      vm.setFilterTag('BAB 1');

      // ACT
      final filtered = vm.filteredReferences;

      // ASSERT
      for (final r in filtered) {
        expect(r.tag, equals('BAB 1'));
      }
    });

    test('availableTags mengandung "Semua" sebagai opsi pertama', () {
      // ARRANGE
      final vm = ReferenceViewModel(ReferenceRepository());

      // ACT
      final tags = vm.availableTags;

      // ASSERT
      expect(tags.first, equals('Semua'));
    });
  });

  group('ReferenceViewModel — CRUD', () {
    test('addReference() menambah referensi & notify listeners', () {
      // ARRANGE
      final vm = ReferenceViewModel(ReferenceRepository());
      final initialCount = vm.totalCount;
      int notifyCount = 0;
      vm.addListener(() => notifyCount++);

      // ACT
      vm.addReference(_buildRef('new'));

      // ASSERT
      expect(vm.totalCount, equals(initialCount + 1));
      expect(notifyCount, equals(1));
    });

    test('toggleStar() mengubah status starred', () {
      // ARRANGE
      final vm = ReferenceViewModel(ReferenceRepository());
      final ref = vm.allReferences.firstWhere((r) => !r.starred);

      // ACT
      vm.toggleStar(ref.id);

      // ASSERT
      final updated = vm.allReferences.firstWhere((r) => r.id == ref.id);
      expect(updated.starred, isTrue);
    });

    test('deleteReference() menghapus referensi', () {
      // ARRANGE
      final vm = ReferenceViewModel(ReferenceRepository());
      final ref = vm.allReferences.first;
      final initialCount = vm.totalCount;

      // ACT
      vm.deleteReference(ref.id);

      // ASSERT
      expect(vm.totalCount, equals(initialCount - 1));
    });
  });
}

ReferenceItem _buildRef(String id) {
  return ReferenceItem(
    id: id,
    title: 'Test $id',
    authors: 'Author',
    year: 2024,
    tag: 'BAB 1',
    fileName: 't.pdf',
    summary: 's',
  );
}
