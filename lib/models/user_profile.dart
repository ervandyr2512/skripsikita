// MODEL: UserProfile
// Mewakili entitas pengguna (mahasiswa) dengan atribut akademik.

class UserProfile {
  String name;
  String email;
  String nim;
  String prodi;
  int semester;
  String supervisor;
  DateTime targetDefenseDate;
  String avatarSeed;

  UserProfile({
    required this.name,
    required this.email,
    required this.nim,
    required this.prodi,
    required this.semester,
    required this.supervisor,
    required this.targetDefenseDate,
    this.avatarSeed = 'R',
  });

  factory UserProfile.demo() => UserProfile(
        name: 'Rina Pratiwi',
        email: 'rina.pratiwi@student.uc.ac.id',
        nim: '0240301234',
        prodi: 'S1 Manajemen',
        semester: 8,
        supervisor: 'Dr. Andi Wijaya, M.Cs.',
        targetDefenseDate: DateTime.now().add(const Duration(days: 120)),
        avatarSeed: 'R',
      );

  UserProfile copyWith({
    String? name,
    String? email,
    String? nim,
    String? prodi,
    int? semester,
    String? supervisor,
    DateTime? targetDefenseDate,
    String? avatarSeed,
  }) {
    return UserProfile(
      name: name ?? this.name,
      email: email ?? this.email,
      nim: nim ?? this.nim,
      prodi: prodi ?? this.prodi,
      semester: semester ?? this.semester,
      supervisor: supervisor ?? this.supervisor,
      targetDefenseDate: targetDefenseDate ?? this.targetDefenseDate,
      avatarSeed: avatarSeed ?? this.avatarSeed,
    );
  }
}
