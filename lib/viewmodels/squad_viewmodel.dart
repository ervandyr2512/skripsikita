// VIEWMODEL: SquadViewModel
// Mengelola state & logic terkait Squad (komunitas mahasiswa).

import 'package:flutter/foundation.dart';

import '../models/squad.dart';
import '../repositories/squad_repository.dart';

class SquadViewModel extends ChangeNotifier {
  final SquadRepository _repository;

  SquadViewModel(this._repository);

  // ====== STATE ======
  String? _todayCheckIn;
  bool get hasCheckedInToday => _todayCheckIn != null;
  String? get todayCheckIn => _todayCheckIn;

  // ====== READS ======
  Squad get squad => _repository.getCurrentSquad();
  int get checkedInCount => _repository.getCheckedInCount();
  List<SquadMember> get members => squad.members;

  // ====== ACTIONS ======
  void submitCheckIn(String target) {
    _todayCheckIn = target;
    notifyListeners();
  }

  void resetCheckIn() {
    _todayCheckIn = null;
    notifyListeners();
  }

  void addMember(SquadMember member) {
    _repository.addMember(member);
    notifyListeners();
  }

  void removeMember(String name) {
    _repository.removeMember(name);
    notifyListeners();
  }
}
