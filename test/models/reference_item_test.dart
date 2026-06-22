// ============================================================================
// UNIT TEST: ReferenceItem Model
// ============================================================================
//
// Menguji:
//  - Konstruktor & default values
//  - Computed property: apaCitation (format sitasi APA)
//  - Mutability flag starred
//
// Pola: Arrange-Act-Assert (AAA)
// ============================================================================

import 'package:flutter_test/flutter_test.dart';
import 'package:skripsikita/models/reference_item.dart';

void main() {
  group('ReferenceItem — Konstruktor & Defaults', () {
    test('membuat ReferenceItem dengan field wajib', () {
      // ARRANGE & ACT
      final ref = ReferenceItem(
        id: 'r-1',
        title: 'Digital Marketing Effects',
        authors: 'Setiawan, B.',
        year: 2024,
        tag: 'BAB 2',
        fileName: 'setiawan_2024.pdf',
        summary: 'Studi tentang efek digital marketing.',
      );

      // ASSERT
      expect(ref.id, equals('r-1'));
      expect(ref.title, equals('Digital Marketing Effects'));
      expect(ref.year, equals(2024));
    });

    test('starred default-nya false (referensi baru tidak di-bookmark)', () {
      // ARRANGE & ACT
      final ref = _buildRef();

      // ASSERT
      expect(ref.starred, isFalse);
    });

    test('starred bisa diset true di konstruktor', () {
      // ARRANGE & ACT
      final ref = _buildRef(starred: true);

      // ASSERT
      expect(ref.starred, isTrue);
    });
  });

  group('ReferenceItem — apaCitation (format sitasi)', () {
    test('menghasilkan format sitasi APA standar', () {
      // ARRANGE
      final ref = ReferenceItem(
        id: 'r-1',
        title: 'Consumer Behavior in Digital Era',
        authors: 'Kotler, P., & Keller, K.',
        year: 2023,
        tag: 'BAB 2',
        fileName: 'kotler.pdf',
        summary: 'Buku referensi.',
      );

      // ACT
      final citation = ref.apaCitation;

      // ASSERT
      expect(
        citation,
        equals(
            'Kotler, P., & Keller, K. (2023). Consumer Behavior in Digital Era. Jurnal Akademik Indonesia.'),
      );
    });

    test('format sitasi mengandung tahun publikasi', () {
      // ARRANGE
      final ref = _buildRef(year: 2022);

      // ACT
      final citation = ref.apaCitation;

      // ASSERT
      expect(citation, contains('(2022)'));
    });

    test('format sitasi mengandung judul', () {
      // ARRANGE
      const judul = 'Judul Penelitian Khusus';
      final ref = _buildRef(title: judul);

      // ACT
      final citation = ref.apaCitation;

      // ASSERT
      expect(citation, contains(judul));
    });

    test('format sitasi mengandung nama penulis', () {
      // ARRANGE
      const penulis = 'Rangganata, E.';
      final ref = _buildRef(authors: penulis);

      // ACT
      final citation = ref.apaCitation;

      // ASSERT
      expect(citation, contains(penulis));
    });
  });

  group('ReferenceItem — Mutability', () {
    test('field starred bisa di-toggle', () {
      // ARRANGE
      final ref = _buildRef(starred: false);

      // ACT
      ref.starred = true;

      // ASSERT
      expect(ref.starred, isTrue);
    });

    test('field tag bisa diubah', () {
      // ARRANGE
      final ref = _buildRef();

      // ACT
      ref.tag = 'BAB 3';

      // ASSERT
      expect(ref.tag, equals('BAB 3'));
    });
  });
}

ReferenceItem _buildRef({
  String title = 'Test Title',
  String authors = 'Test Author',
  int year = 2024,
  bool starred = false,
}) {
  return ReferenceItem(
    id: 'test-id',
    title: title,
    authors: authors,
    year: year,
    tag: 'BAB 1',
    fileName: 'test.pdf',
    summary: 'Test summary',
    starred: starred,
  );
}
