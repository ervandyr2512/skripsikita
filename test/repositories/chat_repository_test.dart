// ============================================================================
// UNIT TEST: ChatRepository
// ============================================================================
//
// Menguji rule-based AI reply generation (SkripsiBot).
// Logic ini critical karena menentukan jawaban yang tepat ke mahasiswa.
//
// Pola: Arrange-Act-Assert (AAA)
// ============================================================================

import 'package:flutter_test/flutter_test.dart';
import 'package:skripsikita/repositories/chat_repository.dart';

void main() {
  group('ChatRepository — Message storage', () {
    test('getAll() mengembalikan initial greeting dari SkripsiBot', () {
      // ARRANGE
      final repo = ChatRepository();

      // ACT
      final messages = repo.getAll();

      // ASSERT
      expect(messages, isNotEmpty);
      expect(messages.first.fromBot, isTrue);
    });

    test('addUserMessage() menambah pesan dari user', () {
      // ARRANGE
      final repo = ChatRepository();
      final initialCount = repo.getAll().length;

      // ACT
      repo.addUserMessage('Halo bot');

      // ASSERT
      expect(repo.getAll().length, equals(initialCount + 1));
      expect(repo.getAll().last.content, equals('Halo bot'));
      expect(repo.getAll().last.fromBot, isFalse);
    });

    test('addBotMessage() menambah pesan dari bot', () {
      // ARRANGE
      final repo = ChatRepository();

      // ACT
      repo.addBotMessage('Halo balik!');

      // ASSERT
      expect(repo.getAll().last.fromBot, isTrue);
      expect(repo.getAll().last.content, equals('Halo balik!'));
    });

    test('clearAll() mengosongkan semua pesan', () {
      // ARRANGE
      final repo = ChatRepository();
      repo.addUserMessage('test');

      // ACT
      repo.clearAll();

      // ASSERT
      expect(repo.getAll(), isEmpty);
    });
  });

  group('ChatRepository — generateReply (rule-based AI logic)', () {
    test('keyword "BAB 1" → reply tentang struktur BAB 1', () {
      // ARRANGE
      final repo = ChatRepository();

      // ACT
      final reply = repo.generateReply('Bantu saya BAB 1 dong');

      // ASSERT
      expect(reply.toLowerCase(), contains('latar belakang'));
      expect(reply.toLowerCase(), contains('rumusan masalah'));
    });

    test('keyword "latar belakang" → reply tentang struktur BAB 1', () {
      // ARRANGE
      final repo = ChatRepository();

      // ACT
      final reply = repo.generateReply('Cara menulis latar belakang?');

      // ASSERT
      expect(reply.toLowerCase(), contains('latar belakang'));
    });

    test('keyword "gap" → reply tentang gap penelitian', () {
      // ARRANGE
      final repo = ChatRepository();

      // ACT
      final reply = repo.generateReply('Bagaimana cari gap penelitian?');

      // ASSERT
      expect(reply.toLowerCase(), contains('gap'));
      expect(reply.toLowerCase(), contains('tabel sintesis'));
    });

    test('keyword "metode" → reply tentang metodologi', () {
      // ARRANGE
      final repo = ChatRepository();

      // ACT
      final reply = repo.generateReply('Pilih metode apa ya?');

      // ASSERT
      expect(reply.toLowerCase(), contains('kuantitatif'));
      expect(reply.toLowerCase(), contains('kualitatif'));
    });

    test('keyword "metodologi" juga menghasilkan reply tentang metodologi', () {
      // ARRANGE
      final repo = ChatRepository();
      // NOTE: hindari kata "penelitian" yang akan trigger rule "gap" lebih dulu
      // karena evaluasi rule dilakukan top-to-bottom.

      // ACT
      final reply = repo.generateReply('Bingung pilih metodologi yang tepat');

      // ASSERT
      expect(reply.toLowerCase(), contains('kuantitatif'));
    });

    test('keyword "halo" → reply menyapa dengan daftar bantuan', () {
      // ARRANGE
      final repo = ChatRepository();

      // ACT
      final reply = repo.generateReply('halo');

      // ASSERT
      expect(reply.toLowerCase(), contains('halo'));
      expect(reply, contains('BAB'));
    });

    test('keyword "hai" juga menghasilkan reply sapaan', () {
      // ARRANGE
      final repo = ChatRepository();

      // ACT
      final reply = repo.generateReply('hai');

      // ASSERT
      expect(reply.toLowerCase(), contains('halo'));
    });

    test('input tanpa keyword khusus → reply default umum', () {
      // ARRANGE
      final repo = ChatRepository();

      // ACT
      final reply = repo.generateReply('xyz random tidak relevan');

      // ASSERT
      // Default reply mengandung saran umum
      expect(reply.toLowerCase(), contains('saya menyarankan'));
    });

    test('generateReply() bersifat case-insensitive', () {
      // ARRANGE
      final repo = ChatRepository();

      // ACT
      final lower = repo.generateReply('bab 1');
      final upper = repo.generateReply('BAB 1');
      final mixed = repo.generateReply('Bab 1');

      // ASSERT
      expect(lower, equals(upper));
      expect(lower, equals(mixed));
    });
  });
}
