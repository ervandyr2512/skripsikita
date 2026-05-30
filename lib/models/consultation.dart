// MODEL: Consultation
// Mewakili satu sesi bimbingan dengan dosen pembimbing.

class Consultation {
  final String id;
  DateTime scheduledAt;
  int durationMinutes;
  String agenda;
  String supervisorName;
  String? notes;
  bool completed;

  Consultation({
    required this.id,
    required this.scheduledAt,
    required this.durationMinutes,
    required this.agenda,
    required this.supervisorName,
    this.notes,
    this.completed = false,
  });
}
