// MODEL: MoodLog
// Mewakili satu pencatatan mood mahasiswa pada satu waktu tertentu.

enum Mood { veryHappy, happy, neutral, sad, verySad }

class MoodLog {
  final DateTime loggedAt;
  final Mood mood;
  final String? note;

  const MoodLog({
    required this.loggedAt,
    required this.mood,
    this.note,
  });

  String get emoji {
    switch (mood) {
      case Mood.veryHappy:
        return '😄';
      case Mood.happy:
        return '🙂';
      case Mood.neutral:
        return '😐';
      case Mood.sad:
        return '😟';
      case Mood.verySad:
        return '😢';
    }
  }

  String get label {
    switch (mood) {
      case Mood.veryHappy:
        return 'Sangat senang';
      case Mood.happy:
        return 'Senang';
      case Mood.neutral:
        return 'Biasa saja';
      case Mood.sad:
        return 'Sedih';
      case Mood.verySad:
        return 'Sangat sedih';
    }
  }

  int get score {
    switch (mood) {
      case Mood.veryHappy:
        return 5;
      case Mood.happy:
        return 4;
      case Mood.neutral:
        return 3;
      case Mood.sad:
        return 2;
      case Mood.verySad:
        return 1;
    }
  }
}
