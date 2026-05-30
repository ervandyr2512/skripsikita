// REPOSITORY: MilestoneRepository
// Operasi CRUD untuk Milestone (target/tugas skripsi).

import '../data/mock_data.dart';
import '../models/milestone.dart';

class MilestoneRepository {
  late final List<Milestone> _items;

  MilestoneRepository() {
    _items = MockData.milestones();
  }

  // READ - All
  List<Milestone> getAll() => List.unmodifiable(_items);

  // READ - By chapter
  List<Milestone> getByChapter(String chapter) =>
      _items.where((m) => m.chapter == chapter).toList();

  // READ - Upcoming
  List<Milestone> getUpcoming() {
    final now = DateTime.now();
    return _items
        .where((m) =>
            m.status != MilestoneStatus.done &&
            m.dueDate.isAfter(now.subtract(const Duration(days: 1))))
        .toList()
      ..sort((a, b) => a.dueDate.compareTo(b.dueDate));
  }

  // CREATE
  void add(Milestone milestone) {
    _items.add(milestone);
    _items.sort((a, b) => a.dueDate.compareTo(b.dueDate));
  }

  // UPDATE
  void updateStatus(String id, MilestoneStatus status) {
    final idx = _items.indexWhere((m) => m.id == id);
    if (idx == -1) return;
    _items[idx].status = status;
  }

  void update(Milestone milestone) {
    final idx = _items.indexWhere((m) => m.id == milestone.id);
    if (idx == -1) return;
    _items[idx] = milestone;
  }

  // DELETE
  void delete(String id) {
    _items.removeWhere((m) => m.id == id);
  }
}
