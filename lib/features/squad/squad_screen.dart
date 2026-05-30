import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../models/models.dart';
import '../../shared/widgets/gradient_card.dart';
import '../../viewmodels/squad_viewmodel.dart';

class SquadScreen extends StatelessWidget {
  const SquadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SquadViewModel>();
    final squad = vm.squad;
    final checkedToday = vm.checkedInCount;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Squad Saya'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_alt_rounded),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Undang anggota baru (demo)')),
              );
            },
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
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.groups_rounded, color: Colors.white, size: 26),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            squad.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${squad.members.length} anggota • Target sidang ${squad.defenseWindow} minggu',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  squad.description,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.95),
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.local_fire_department_rounded, color: Colors.white),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '$checkedToday/${squad.members.length} anggota check-in hari ini',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const SectionHeader(title: 'Check-in Hari Ini'),
          const SizedBox(height: 12),
          _DailyCheckInCard(),
          const SizedBox(height: 20),
          const SectionHeader(title: 'Anggota Squad'),
          const SizedBox(height: 12),
          ...squad.members.map((m) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _MemberTile(member: m),
              )),
          const SizedBox(height: 20),
          const SectionHeader(title: 'Aktivitas Squad'),
          const SizedBox(height: 12),
          ..._mockActivities.map((a) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _ActivityTile(activity: a),
              )),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

final _mockActivities = [
  _Activity(
    name: 'Dimas A.',
    avatar: 'D',
    color: const Color(0xFF06B6D4),
    action: 'menyelesaikan milestone "Revisi BAB 1" 🎉',
    timeAgo: '10 menit yang lalu',
  ),
  _Activity(
    name: 'Sari W.',
    avatar: 'S',
    color: const Color(0xFFFB7185),
    action: 'menambahkan 3 referensi baru ke vault',
    timeAgo: '1 jam yang lalu',
  ),
  _Activity(
    name: 'Bayu R.',
    avatar: 'B',
    color: const Color(0xFFF59E0B),
    action: 'menjadwalkan bimbingan untuk besok pagi',
    timeAgo: '3 jam yang lalu',
  ),
  _Activity(
    name: 'Naya M.',
    avatar: 'N',
    color: const Color(0xFF10B981),
    action: 'check-in: "Hari ini akan tulis BAB 2 sub-bab 2.1"',
    timeAgo: 'kemarin',
  ),
];

class _Activity {
  final String name;
  final String avatar;
  final Color color;
  final String action;
  final String timeAgo;
  const _Activity({
    required this.name,
    required this.avatar,
    required this.color,
    required this.action,
    required this.timeAgo,
  });
}

class _DailyCheckInCard extends StatefulWidget {
  @override
  State<_DailyCheckInCard> createState() => _DailyCheckInCardState();
}

class _DailyCheckInCardState extends State<_DailyCheckInCard> {
  final _controller = TextEditingController();
  bool _submitted = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: _submitted
              ? Column(
                  key: const ValueKey('done'),
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(Icons.check_rounded,
                          color: AppColors.success, size: 32),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Kamu sudah check-in hari ini! 🔥',
                      style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _controller.text,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                )
              : Column(
                  key: const ValueKey('input'),
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Apa yang akan kamu kerjakan hari ini?',
                      style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _controller,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        hintText: 'mis. Tulis sub-bab 2.1 sampai jam 5 sore',
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          if (_controller.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Tulis target hari ini dulu yuk')),
                            );
                            return;
                          }
                          setState(() => _submitted = true);
                        },
                        icon: const Icon(Icons.check_rounded, color: Colors.white, size: 18),
                        label: const Text('Check-in'),
                        style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(44)),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class _MemberTile extends StatelessWidget {
  final SquadMember member;
  const _MemberTile({required this.member});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Stack(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      member.avatar,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                if (member.checkedInToday)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    member.name,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                  Text(
                    member.prodi,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: member.checkedInToday
                    ? AppColors.success.withValues(alpha: 0.12)
                    : AppColors.divider,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                member.checkedInToday ? 'Check-in ✓' : 'Belum',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: member.checkedInToday ? AppColors.success : AppColors.textHint,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivityTile extends StatelessWidget {
  final _Activity activity;
  const _ActivityTile({required this.activity});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: activity.color,
              child: Text(
                activity.avatar,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(color: AppColors.textPrimary, fontSize: 13),
                      children: [
                        TextSpan(
                          text: activity.name,
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                        TextSpan(text: ' ${activity.action}'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    activity.timeAgo,
                    style: const TextStyle(fontSize: 11, color: AppColors.textHint),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
