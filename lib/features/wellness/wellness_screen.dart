import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../models/models.dart';
import '../../shared/widgets/gradient_card.dart';
import '../../viewmodels/wellness_viewmodel.dart';

class WellnessScreen extends StatefulWidget {
  const WellnessScreen({super.key});

  @override
  State<WellnessScreen> createState() => _WellnessScreenState();
}

class _WellnessScreenState extends State<WellnessScreen> {
  Mood? _selectedMood;

  void _logMood() {
    if (_selectedMood == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih mood kamu dulu yuk')),
      );
      return;
    }
    final vm = context.read<WellnessViewModel>();
    vm.selectMood(_selectedMood!);
    vm.logSelectedMood();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Mood tercatat. Terima kasih sudah jujur dengan diri sendiri ❤️'),
        backgroundColor: AppColors.success,
      ),
    );
    setState(() => _selectedMood = null);
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<WellnessViewModel>();
    final content = vm.wellnessContent;
    final avg = vm.averageScore;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wellness Corner'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart_rounded),
            onPressed: () => context.push('/mood-history'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          GradientCard(
            gradient: AppColors.accentGradient,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'CHECK-IN HARIAN',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const Text(
                  'Hai, gimana perasaanmu hari ini?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: Mood.values.map((m) => _moodButton(m)).toList(),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _logMood,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.accent,
                    ),
                    child: const Text('Catat Mood'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: AppColors.successGradient,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.trending_up_rounded, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Rata-rata mood 7 hari',
                          style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                        ),
                        Text(
                          '${avg.toStringAsFixed(1)} / 5.0',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.push('/mood-history'),
                    child: const Text('Lihat Grafik'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const SectionHeader(title: 'Praktik Wellness'),
          const SizedBox(height: 12),
          ...content.map((c) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _WellnessTile(content: c),
              )),
          const SizedBox(height: 20),
          GradientCard(
            gradient: AppColors.infoGradient,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.phone_in_talk_rounded, color: Colors.white),
                    const SizedBox(width: 8),
                    const Text(
                      'Bantuan Profesional',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Jika kamu merasa kewalahan, kamu tidak sendirian. Hubungi:',
                  style: TextStyle(color: Colors.white, fontSize: 13, height: 1.5),
                ),
                const SizedBox(height: 12),
                _infoRow('📞', 'Hotline Kesehatan Mental', '119 ext. 8'),
                const SizedBox(height: 6),
                _infoRow('🏥', 'Konselor Kampus', 'Buka Senin-Jumat, 09:00-16:00'),
                const SizedBox(height: 6),
                _infoRow('💬', 'Riliv Premium', 'Gratis untuk mahasiswa UC'),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _moodButton(Mood mood) {
    final log = MoodLog(loggedAt: DateTime.now(), mood: mood);
    final active = _selectedMood == mood;
    return GestureDetector(
      onTap: () => setState(() => _selectedMood = mood),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: active ? Colors.white : Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: active ? Colors.white : Colors.transparent,
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            log.emoji,
            style: TextStyle(fontSize: active ? 28 : 24),
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String emoji, String label, String value) {
    return Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 16)),
        const SizedBox(width: 8),
        SizedBox(
          width: 130,
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}

class _WellnessTile extends StatelessWidget {
  final Map<String, dynamic> content;
  const _WellnessTile({required this.content});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (ctx) => Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.divider,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(child: Text(content['icon'], style: const TextStyle(fontSize: 56))),
                  const SizedBox(height: 12),
                  Center(
                    child: Text(
                      content['title'],
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    content['description'],
                    style: const TextStyle(fontSize: 14, height: 1.6),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Sesi dimulai. Selamat menikmati! 🌿')),
                      );
                    },
                    child: const Text('Mulai Sesi'),
                  ),
                ],
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.bg,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(child: Text(content['icon'], style: const TextStyle(fontSize: 28))),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        content['category'],
                        style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      content['title'],
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.access_time_rounded, size: 11, color: AppColors.textHint),
                        const SizedBox(width: 4),
                        Text(
                          content['duration'],
                          style: const TextStyle(fontSize: 11, color: AppColors.textHint),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: AppColors.textHint),
            ],
          ),
        ),
      ),
    );
  }
}
