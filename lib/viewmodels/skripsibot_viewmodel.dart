// VIEWMODEL: SkripsiBotViewModel
// Mengelola state & logic untuk chat dengan SkripsiBot AI.

import 'package:flutter/foundation.dart';

import '../models/chat_message.dart';
import '../repositories/chat_repository.dart';

class SkripsiBotViewModel extends ChangeNotifier {
  final ChatRepository _repository;

  SkripsiBotViewModel(this._repository);

  // ====== STATE ======
  bool _isTyping = false;
  bool get isTyping => _isTyping;

  // ====== READS ======
  List<ChatMessage> get messages => _repository.getAll();

  // ====== ACTIONS ======
  Future<void> sendMessage(String content) async {
    if (content.trim().isEmpty) return;

    _repository.addUserMessage(content);
    _isTyping = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1200));

    final reply = _repository.generateReply(content);
    _repository.addBotMessage(reply);
    _isTyping = false;
    notifyListeners();
  }

  void clearConversation() {
    _repository.clearAll();
    notifyListeners();
  }
}
