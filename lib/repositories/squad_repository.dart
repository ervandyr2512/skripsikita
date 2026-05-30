// REPOSITORY: SquadRepository
// Operasi CRUD untuk data Squad (kelompok mahasiswa).

import '../data/mock_data.dart';
import '../models/squad.dart';

class SquadRepository {
  late Squad _currentSquad;

  SquadRepository() {
    _currentSquad = MockData.currentSquad();
  }

  // READ
  Squad getCurrentSquad() => _currentSquad;

  int getCheckedInCount() =>
      _currentSquad.members.where((m) => m.checkedInToday).length;

  // CREATE - join squad (placeholder for future)
  void joinSquad(Squad squad) {
    _currentSquad = squad;
  }

  // UPDATE
  void addMember(SquadMember member) {
    _currentSquad = Squad(
      name: _currentSquad.name,
      description: _currentSquad.description,
      defenseWindow: _currentSquad.defenseWindow,
      members: [..._currentSquad.members, member],
    );
  }

  // DELETE
  void removeMember(String memberName) {
    _currentSquad = Squad(
      name: _currentSquad.name,
      description: _currentSquad.description,
      defenseWindow: _currentSquad.defenseWindow,
      members: _currentSquad.members.where((m) => m.name != memberName).toList(),
    );
  }
}
