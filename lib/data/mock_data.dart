import 'package:uuid/uuid.dart';
import '../models/models.dart';

const _uuid = Uuid();

class MockData {
  static List<Milestone> milestones() {
    final now = DateTime.now();
    return [
      Milestone(
        id: _uuid.v4(),
        title: 'Selesaikan revisi BAB 1',
        chapter: 'BAB 1',
        description:
            'Revisi pendahuluan: latar belakang, rumusan masalah, dan tujuan penelitian sesuai feedback Dr. Andi.',
        dueDate: now.subtract(const Duration(days: 2)),
        status: MilestoneStatus.done,
        priority: 1,
      ),
      Milestone(
        id: _uuid.v4(),
        title: 'Tinjauan pustaka teori X',
        chapter: 'BAB 2',
        description:
            'Cari minimal 10 jurnal internasional (Q2 ke atas) tentang teori X publikasi 5 tahun terakhir.',
        dueDate: now.add(const Duration(days: 3)),
        status: MilestoneStatus.inProgress,
        priority: 1,
      ),
      Milestone(
        id: _uuid.v4(),
        title: 'Draft kerangka teori',
        chapter: 'BAB 2',
        description:
            'Susun kerangka pemikiran berdasarkan tinjauan pustaka yang sudah dibaca.',
        dueDate: now.add(const Duration(days: 7)),
        status: MilestoneStatus.todo,
        priority: 2,
      ),
      Milestone(
        id: _uuid.v4(),
        title: 'Konsultasi metodologi penelitian',
        chapter: 'BAB 3',
        description:
            'Diskusi dengan dosen pembimbing terkait pendekatan kualitatif vs kuantitatif.',
        dueDate: now.add(const Duration(days: 14)),
        status: MilestoneStatus.todo,
        priority: 1,
      ),
      Milestone(
        id: _uuid.v4(),
        title: 'Susun instrumen kuesioner',
        chapter: 'BAB 3',
        description:
            'Adopsi instrumen dari paper rujukan, sesuaikan dengan konteks Indonesia.',
        dueDate: now.add(const Duration(days: 21)),
        status: MilestoneStatus.todo,
        priority: 2,
      ),
      Milestone(
        id: _uuid.v4(),
        title: 'Pilot test instrumen',
        chapter: 'BAB 3',
        description: 'Uji coba instrumen ke 30 responden untuk validitas & reliabilitas.',
        dueDate: now.add(const Duration(days: 35)),
        status: MilestoneStatus.todo,
        priority: 3,
      ),
      Milestone(
        id: _uuid.v4(),
        title: 'Pengumpulan data lapangan',
        chapter: 'BAB 4',
        description: 'Sebarkan kuesioner ke target 200 responden.',
        dueDate: now.add(const Duration(days: 50)),
        status: MilestoneStatus.todo,
        priority: 2,
      ),
      Milestone(
        id: _uuid.v4(),
        title: 'Analisis data SPSS',
        chapter: 'BAB 4',
        description: 'Olah data dengan SPSS: uji validitas, reliabilitas, regresi.',
        dueDate: now.add(const Duration(days: 70)),
        status: MilestoneStatus.todo,
        priority: 1,
      ),
      Milestone(
        id: _uuid.v4(),
        title: 'Draft pembahasan & kesimpulan',
        chapter: 'BAB 5',
        description: 'Sintesis hasil dengan teori, buat kesimpulan dan saran.',
        dueDate: now.add(const Duration(days: 90)),
        status: MilestoneStatus.todo,
        priority: 2,
      ),
      Milestone(
        id: _uuid.v4(),
        title: 'Sidang skripsi',
        chapter: 'BAB 5',
        description: 'Final defense! Persiapkan PPT dan latihan presentasi.',
        dueDate: now.add(const Duration(days: 115)),
        status: MilestoneStatus.todo,
        priority: 1,
      ),
    ];
  }

  static List<Consultation> consultations() {
    final now = DateTime.now();
    return [
      Consultation(
        id: _uuid.v4(),
        scheduledAt: now.subtract(const Duration(days: 5, hours: 2)),
        durationMinutes: 30,
        agenda:
            '1. Review revisi BAB 1\n2. Diskusi gap penelitian\n3. Rencana BAB 2',
        supervisorName: 'Dr. Andi Wijaya, M.Cs.',
        notes:
            'Dosen menyarankan untuk memperdalam latar belakang dengan data terbaru. Tinjauan pustaka harus min. 10 jurnal Q2.',
        completed: true,
      ),
      Consultation(
        id: _uuid.v4(),
        scheduledAt: now.add(const Duration(days: 2, hours: 4)),
        durationMinutes: 45,
        agenda:
            '1. Progres tinjauan pustaka\n2. Konfirmasi kerangka teori\n3. Diskusi metodologi awal',
        supervisorName: 'Dr. Andi Wijaya, M.Cs.',
        completed: false,
      ),
      Consultation(
        id: _uuid.v4(),
        scheduledAt: now.add(const Duration(days: 9, hours: 3)),
        durationMinutes: 30,
        agenda: '1. Review draft BAB 2\n2. Diskusi instrumen penelitian',
        supervisorName: 'Dr. Andi Wijaya, M.Cs.',
        completed: false,
      ),
    ];
  }

  static List<ReferenceItem> references() {
    return [
      ReferenceItem(
        id: _uuid.v4(),
        title:
            'The Impact of Digital Marketing on Consumer Purchase Decisions: A Systematic Review',
        authors: 'Setiawan, B., & Kusuma, A.',
        year: 2023,
        tag: 'BAB 2',
        fileName: 'setiawan_2023_digital_marketing.pdf',
        summary:
            'Systematic review terhadap 47 paper tentang pengaruh digital marketing pada keputusan pembelian Gen-Z.',
        starred: true,
      ),
      ReferenceItem(
        id: _uuid.v4(),
        title:
            'Social Media Engagement and Brand Loyalty in Indonesian E-commerce',
        authors: 'Wibowo, R., et al.',
        year: 2022,
        tag: 'BAB 1',
        fileName: 'wibowo_2022_social_media.pdf',
        summary:
            'Studi empiris terhadap 500 konsumen e-commerce Indonesia, menunjukkan korelasi positif engagement dan loyalty.',
      ),
      ReferenceItem(
        id: _uuid.v4(),
        title:
            'Consumer Behavior Theory in the Age of Digital Disruption',
        authors: 'Kotler, P., & Keller, K.',
        year: 2024,
        tag: 'BAB 2',
        fileName: 'kotler_2024_consumer_behavior.pdf',
        summary:
            'Buku referensi utama tentang perilaku konsumen, edisi terbaru dengan konteks digital.',
        starred: true,
      ),
      ReferenceItem(
        id: _uuid.v4(),
        title:
            'Quantitative Research Methods for Marketing Students',
        authors: 'Hair, J., et al.',
        year: 2023,
        tag: 'BAB 3',
        fileName: 'hair_2023_quantitative_methods.pdf',
        summary:
            'Panduan praktis metode penelitian kuantitatif khusus untuk mahasiswa pemasaran.',
      ),
      ReferenceItem(
        id: _uuid.v4(),
        title:
            'TAM Model Application in Indonesian Mobile Banking',
        authors: 'Pramudita, S.',
        year: 2022,
        tag: 'Metodologi',
        fileName: 'pramudita_2022_tam_indonesia.pdf',
        summary:
            'Aplikasi model Technology Acceptance Model di konteks mobile banking Indonesia. Cocok jadi rujukan instrumen.',
      ),
    ];
  }

  static Squad currentSquad() {
    return const Squad(
      name: 'Squad Senja',
      description: 'Squad mahasiswa Manajemen target sidang Q3 2026.',
      defenseWindow: 16,
      members: [
        SquadMember(name: 'Rina P.', prodi: 'Manajemen', avatar: 'R', checkedInToday: true),
        SquadMember(name: 'Dimas A.', prodi: 'Manajemen', avatar: 'D', checkedInToday: true),
        SquadMember(name: 'Sari W.', prodi: 'Akuntansi', avatar: 'S', checkedInToday: false),
        SquadMember(name: 'Bayu R.', prodi: 'Manajemen', avatar: 'B', checkedInToday: true),
        SquadMember(name: 'Naya M.', prodi: 'Bisnis', avatar: 'N', checkedInToday: false),
      ],
    );
  }

  static List<MoodLog> moodHistory() {
    final now = DateTime.now();
    final moods = [
      Mood.happy,
      Mood.neutral,
      Mood.sad,
      Mood.neutral,
      Mood.happy,
      Mood.veryHappy,
      Mood.happy,
      Mood.neutral,
      Mood.sad,
      Mood.happy,
    ];
    return List.generate(
      moods.length,
      (i) => MoodLog(
        loggedAt: now.subtract(Duration(days: moods.length - 1 - i)),
        mood: moods[i],
      ),
    );
  }

  static List<Map<String, dynamic>> wellnessContent() {
    return [
      {
        'title': 'Box Breathing 4-4-4-4',
        'duration': '5 menit',
        'category': 'Pernapasan',
        'description':
            'Teknik pernapasan kotak untuk menenangkan sistem saraf. Tarik napas 4 detik, tahan 4 detik, hembuskan 4 detik, tahan 4 detik.',
        'icon': '🌬️',
      },
      {
        'title': 'Journaling: 3 hal positif hari ini',
        'duration': '10 menit',
        'category': 'Refleksi',
        'description':
            'Tulis 3 hal positif yang terjadi hari ini, sekecil apapun. Terbukti meningkatkan kebahagiaan jangka panjang.',
        'icon': '📓',
      },
      {
        'title': 'Body scan meditation',
        'duration': '15 menit',
        'category': 'Meditasi',
        'description':
            'Pemindaian tubuh dari ujung kepala hingga kaki untuk melepaskan ketegangan.',
        'icon': '🧘',
      },
      {
        'title': 'Hubungi Konselor Kampus',
        'duration': 'sesuai kebutuhan',
        'category': 'Profesional',
        'description':
            'Akses gratis untuk mahasiswa aktif. Hotline mental health nasional: 119 ext. 8.',
        'icon': '📞',
      },
    ];
  }

  static List<ChatMessage> initialChatMessages() {
    return [
      ChatMessage(
        content:
            'Halo Rina! Saya SkripsiBot 🤖. Saya siap bantu kamu mendiskusikan ide, mencari gap penelitian, atau menyusun kerangka BAB. Apa yang bisa saya bantu hari ini?',
        fromBot: true,
        timestamp: DateTime.now().subtract(const Duration(minutes: 1)),
      ),
    ];
  }
}
