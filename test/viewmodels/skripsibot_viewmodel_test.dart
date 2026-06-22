// ============================================================================
// UNIT TEST: SkripsiBotViewModel
// ============================================================================
//
// Menguji:
//  - sendMessage() menambah pesan user + reply bot
//  - isTyping state berubah selama proses
//  - clearConversation()
//
// Pola: Arrange-Act-Assert (AAA)
// ============================================================================

import 'package:flutter_test/flutter_test.dart';
import 'package:skripsikita/repositories/chat_repository.dart';
import 'package:skripsikita/viewmodels/skripsibot_viewmodel.dart';

void main() {
  group('SkripsiBotViewModel — Initial state', () {
    test('messages awal berisi greeting bot', () {
      // ARRANGE & ACT
      final vm = SkripsiBotViewModel(ChatRepository());

      // ASSERT
      expect(vm.messages, isNotEmpty);
      expect(vm.messages.first.fromBot, isTrue);
    });

    test('isTyping awalnya false', () {
      // ARRANGE & ACT
      final vm = SkripsiBotViewModel(ChatRepository());

      // ASSERT
      expect(vm.isTyping, isFalse);
    });
  });

  group('SkripsiBotViewModel — sendMessage()', () {
    test('sendMessage() pesan kosong tidak diproses', () async {
      // ARRANGE
      final vm = SkripsiBotViewModel(ChatRepository());
      final initialCount = vm.messages.length;

      // ACT
      await vm.sendMessage('');

      // ASSERT
      expect(vm.messages.length, equals(initialCount));
    });

    test('sendMessage() whitespace-only tidak diproses', () async {
      // ARRANGE
      final vm = SkripsiBotViewModel(ChatRepository());
      final initialCount = vm.messages.length;

      // ACT
      await vm.sendMessage('   ');

      // ASSERT
      expect(vm.messages.length, equals(initialCount));
    });

    test('sendMessage() menambah pesan user lalu reply bot', () async {
      // ARRANGE
      final vm = SkripsiBotViewModel(ChatRepository());
      final initialCount = vm.messages.length;

      // ACT
      await vm.sendMessage('halo');

      // ASSERT — bertambah 2: user message + bot reply
      expect(vm.messages.length, equals(initialCount + 2));
      // Pesan kedua dari belakang adalah user, terakhir adalah bot
      expect(vm.messages[vm.messages.length - 2].fromBot, isFalse);
      expect(vm.messages.last.fromBot, isTrue);
    });

    test('sendMessage("halo") menghasilkan reply yang mengandung "halo"', () async {
      // ARRANGE
      final vm = SkripsiBotViewModel(ChatRepository());

      // ACT
      await vm.sendMessage('halo');

      // ASSERT
      expect(vm.messages.last.content.toLowerCase(), contains('halo'));
    });

    test('isTyping kembali ke false setelah sendMessage selesai', () async {
      // ARRANGE
      final vm = SkripsiBotViewModel(ChatRepository());

      // ACT
      await vm.sendMessage('halo');

      // ASSERT
      expect(vm.isTyping, isFalse);
    });

    test('sendMessage memicu notifyListeners minimal 2x (user + bot)', () async {
      // ARRANGE
      final vm = SkripsiBotViewModel(ChatRepository());
      int notifyCount = 0;
      vm.addListener(() => notifyCount++);

      // ACT
      await vm.sendMessage('halo');

      // ASSERT — minimal 2 notify: setelah add user msg + isTyping=true,
      //                              dan setelah add bot reply + isTyping=false
      expect(notifyCount, greaterThanOrEqualTo(2));
    });
  });

  group('SkripsiBotViewModel — clearConversation()', () {
    test('clearConversation() menghapus semua pesan', () {
      // ARRANGE
      final vm = SkripsiBotViewModel(ChatRepository());

      // ACT
      vm.clearConversation();

      // ASSERT
      expect(vm.messages, isEmpty);
    });

    test('clearConversation() memicu notifyListeners()', () {
      // ARRANGE
      final vm = SkripsiBotViewModel(ChatRepository());
      int notifyCount = 0;
      vm.addListener(() => notifyCount++);

      // ACT
      vm.clearConversation();

      // ASSERT
      expect(notifyCount, equals(1));
    });
  });
}
