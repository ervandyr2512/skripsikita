// MODEL: ChatMessage
// Mewakili satu pesan dalam percakapan dengan SkripsiBot.

class ChatMessage {
  final String content;
  final bool fromBot;
  final DateTime timestamp;

  const ChatMessage({
    required this.content,
    required this.fromBot,
    required this.timestamp,
  });
}
