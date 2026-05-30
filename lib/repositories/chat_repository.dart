// REPOSITORY: ChatRepository
// Mengelola pesan chat dengan SkripsiBot (mock AI assistant).

import '../data/mock_data.dart';
import '../models/chat_message.dart';

class ChatRepository {
  late final List<ChatMessage> _messages;

  ChatRepository() {
    _messages = [...MockData.initialChatMessages()];
  }

  // READ
  List<ChatMessage> getAll() => List.unmodifiable(_messages);

  // CREATE - user message
  void addUserMessage(String content) {
    _messages.add(ChatMessage(
      content: content,
      fromBot: false,
      timestamp: DateTime.now(),
    ));
  }

  // CREATE - bot message (simulated AI reply)
  void addBotMessage(String content) {
    _messages.add(ChatMessage(
      content: content,
      fromBot: true,
      timestamp: DateTime.now(),
    ));
  }

  // BUSINESS LOGIC - generate bot reply (rule-based)
  String generateReply(String userMessage) {
    final msg = userMessage.toLowerCase();
    if (msg.contains('bab 1') || msg.contains('latar belakang')) {
      return 'Untuk BAB 1, pastikan kamu mengikuti struktur:\n\n1. Latar Belakang — fenomena & data terkini\n2. Rumusan Masalah — 2-3 pertanyaan penelitian\n3. Tujuan Penelitian — sejajar dengan rumusan masalah\n4. Manfaat Penelitian — teoritis & praktis\n5. Batasan Penelitian — scope yang jelas\n\nTip: mulai dari yang umum ke spesifik (piramida terbalik). Ingat untuk menjaga integritas akademik — gunakan bantuan ini sebagai panduan, bukan untuk menulis untuk kamu.';
    }
    if (msg.contains('gap') || msg.contains('penelitian')) {
      return 'Untuk menemukan gap penelitian dari referensi kamu, coba langkah ini:\n\n• Buat tabel sintesis: judul, tahun, metode, temuan, limitation\n• Cari pola: variabel apa yang sering diteliti? Konteks mana yang belum?\n• Identifikasi: ada metode yang belum dicoba? Populasi yang belum diteliti?\n\nBerdasarkan referensi di Reference Vault kamu, gap potensial: studi tentang konsumen Gen-Z di kota tier-2 Indonesia masih jarang.';
    }
    if (msg.contains('metode') || msg.contains('metodologi')) {
      return 'Pilih metodologi berdasarkan pertanyaan penelitianmu:\n\n• Kuantitatif → untuk uji hipotesis & generalisasi\n• Kualitatif → untuk eksplorasi makna & pengalaman\n• Mixed-method → untuk pertanyaan kompleks\n\nKonsultasikan dengan dosen sebelum finalisasi, ya!';
    }
    if (msg.contains('halo') || msg.contains('hai') || msg.contains('hi')) {
      return 'Halo! 👋 Ada yang bisa saya bantu? Saya bisa membantu mendiskusikan:\n\n• Struktur BAB 1-5\n• Mencari gap penelitian\n• Pemilihan metodologi\n• Tips manajemen waktu skripsi\n\nSilakan tanya apa saja!';
    }
    return 'Pertanyaan menarik! Berdasarkan referensi yang kamu simpan dan progres skripsimu saat ini, saya menyarankan:\n\n1. Fokus dulu pada penyelesaian BAB 2 sesuai timeline\n2. Jadwalkan bimbingan minggu ini untuk diskusi metodologi\n3. Jangan lupa kelola kesehatan mental — burnout itu nyata\n\nIngat: saya hanya pendukung. Pemikiran kritis dan tulisan akhir tetap milikmu. 💪';
  }

  // DELETE
  void clearAll() {
    _messages.clear();
  }
}
