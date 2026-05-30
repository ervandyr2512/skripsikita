// REPOSITORY: WellnessRepository
// Operasi CRUD untuk mood log + akses konten wellness.

import '../data/mock_data.dart';
import '../models/mood_log.dart';

class WellnessRepository {
  late final List<MoodLog> _moodLogs;

  WellnessRepository() {
    _moodLogs = [...MockData.moodHistory()];
  }

  // READ
  List<MoodLog> getAll() => List.unmodifiable(_moodLogs);

  List<MoodLog> getLast(int days) {
    final cutoff = DateTime.now().subtract(Duration(days: days));
    return _moodLogs.where((m) => m.loggedAt.isAfter(cutoff)).toList();
  }

  double getAverageScore({int lastDays = 7}) {
    final list = getLast(lastDays);
    if (list.isEmpty) return 3.0;
    return list.map((m) => m.score).reduce((a, b) => a + b) / list.length;
  }

  List<Map<String, dynamic>> getWellnessContent() => MockData.wellnessContent();

  // CREATE
  void logMood(Mood mood, {String? note}) {
    _moodLogs.add(MoodLog(loggedAt: DateTime.now(), mood: mood, note: note));
  }

  // DELETE
  void deleteLog(DateTime loggedAt) {
    _moodLogs.removeWhere((m) => m.loggedAt == loggedAt);
  }
}
