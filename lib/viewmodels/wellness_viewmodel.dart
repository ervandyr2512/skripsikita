// VIEWMODEL: WellnessViewModel
// Mengelola state & logic terkait kesejahteraan mental (mood, konten).

import 'package:flutter/foundation.dart';

import '../models/mood_log.dart';
import '../repositories/wellness_repository.dart';

class WellnessViewModel extends ChangeNotifier {
  final WellnessRepository _repository;

  WellnessViewModel(this._repository);

  // ====== STATE ======
  Mood? _selectedMood;
  Mood? get selectedMood => _selectedMood;

  // ====== READS ======
  List<MoodLog> get moodHistory => _repository.getAll();
  double get averageScore => _repository.getAverageScore(lastDays: 7);
  List<Map<String, dynamic>> get wellnessContent =>
      _repository.getWellnessContent();

  // ====== ACTIONS ======
  void selectMood(Mood mood) {
    _selectedMood = mood;
    notifyListeners();
  }

  bool logSelectedMood({String? note}) {
    if (_selectedMood == null) return false;
    _repository.logMood(_selectedMood!, note: note);
    _selectedMood = null;
    notifyListeners();
    return true;
  }
}
