// MODEL: Squad & SquadMember
// Mewakili kelompok mahasiswa (squad) dan anggotanya.

class SquadMember {
  final String name;
  final String prodi;
  final String avatar;
  final bool checkedInToday;

  const SquadMember({
    required this.name,
    required this.prodi,
    required this.avatar,
    this.checkedInToday = false,
  });
}

class Squad {
  final String name;
  final String description;
  final List<SquadMember> members;
  final int defenseWindow; // weeks from now

  const Squad({
    required this.name,
    required this.description,
    required this.members,
    required this.defenseWindow,
  });
}
