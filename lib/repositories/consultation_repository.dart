// REPOSITORY: ConsultationRepository
// Operasi CRUD untuk sesi bimbingan dengan dosen pembimbing.

import '../data/mock_data.dart';
import '../models/consultation.dart';

class ConsultationRepository {
  late final List<Consultation> _items;

  ConsultationRepository() {
    _items = MockData.consultations();
  }

  // READ - All
  List<Consultation> getAll() => List.unmodifiable(_items);

  List<Consultation> getUpcoming() =>
      _items.where((c) => !c.completed).toList()
        ..sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));

  List<Consultation> getPast() =>
      _items.where((c) => c.completed).toList()
        ..sort((a, b) => b.scheduledAt.compareTo(a.scheduledAt));

  // CREATE
  void add(Consultation consultation) {
    _items.add(consultation);
    _items.sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
  }

  // UPDATE
  void completeWithNotes(String id, String notes) {
    final idx = _items.indexWhere((c) => c.id == id);
    if (idx == -1) return;
    _items[idx].completed = true;
    _items[idx].notes = notes;
  }

  // DELETE
  void delete(String id) {
    _items.removeWhere((c) => c.id == id);
  }
}
