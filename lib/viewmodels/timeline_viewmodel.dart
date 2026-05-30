// VIEWMODEL: TimelineViewModel
// Mengelola state & logic terkait Timeline / Milestone skripsi.

import 'package:flutter/foundation.dart';

import '../models/milestone.dart';
import '../repositories/milestone_repository.dart';

class TimelineViewModel extends ChangeNotifier {
  final MilestoneRepository _repository;

  TimelineViewModel(this._repository);

  // ====== STATE ======
  String _filterChapter = 'Semua';

  String get filterChapter => _filterChapter;

  List<Milestone> get allMilestones => _repository.getAll();

  List<Milestone> get filteredMilestones {
    if (_filterChapter == 'Semua') return allMilestones;
    return _repository.getByChapter(_filterChapter);
  }

  List<Milestone> get upcomingMilestones => _repository.getUpcoming();

  // ====== FILTER ACTIONS ======
  void setFilter(String chapter) {
    _filterChapter = chapter;
    notifyListeners();
  }

  // ====== CRUD ACTIONS ======
  void addMilestone(Milestone milestone) {
    _repository.add(milestone);
    notifyListeners();
  }

  void updateStatus(String id, MilestoneStatus status) {
    _repository.updateStatus(id, status);
    notifyListeners();
  }

  void deleteMilestone(String id) {
    _repository.delete(id);
    notifyListeners();
  }

  // ====== COMPUTED PROPERTIES ======
  int get totalCount => allMilestones.length;

  int get doneCount =>
      allMilestones.where((m) => m.status == MilestoneStatus.done).length;

  double get overallProgress {
    if (totalCount == 0) return 0;
    return doneCount / totalCount;
  }

  Map<String, double> get chapterProgress {
    final chapters = ['BAB 1', 'BAB 2', 'BAB 3', 'BAB 4', 'BAB 5'];
    final result = <String, double>{};
    for (final ch in chapters) {
      final items = _repository.getByChapter(ch);
      if (items.isEmpty) {
        result[ch] = 0;
      } else {
        final done = items.where((m) => m.status == MilestoneStatus.done).length;
        result[ch] = done / items.length;
      }
    }
    return result;
  }
}
