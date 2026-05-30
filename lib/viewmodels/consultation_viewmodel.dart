// VIEWMODEL: ConsultationViewModel
// Mengelola state & logic terkait sesi bimbingan dengan dosen pembimbing.

import 'package:flutter/foundation.dart';

import '../models/consultation.dart';
import '../repositories/consultation_repository.dart';

class ConsultationViewModel extends ChangeNotifier {
  final ConsultationRepository _repository;

  ConsultationViewModel(this._repository);

  // ====== STATE / READS ======
  List<Consultation> get allConsultations => _repository.getAll();
  List<Consultation> get upcoming => _repository.getUpcoming();
  List<Consultation> get past => _repository.getPast();

  // ====== CRUD ======
  void scheduleConsultation(Consultation consultation) {
    _repository.add(consultation);
    notifyListeners();
  }

  void completeConsultation(String id, String notes) {
    _repository.completeWithNotes(id, notes);
    notifyListeners();
  }

  void deleteConsultation(String id) {
    _repository.delete(id);
    notifyListeners();
  }
}
