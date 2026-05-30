// VIEW: DashboardScreen
// Menggunakan Consumer multi-VM untuk membaca state dari berbagai ViewModel.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../models/milestone.dart';
import '../../models/user_profile.dart';
import '../../shared/widgets/gradient_card.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/reference_viewmodel.dart';
import '../../viewmodels/timeline_viewmodel.dart';
import '../../viewmodels/wellness_viewmodel.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Membaca AuthViewModel — user profile + target sidang.
    final authVm = context.watch<AuthViewModel>();
    final user = authVm.user!;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          onRefresh: () async =>
              await Future.delayed(const Duration(milliseconds: 600)),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            children: [
              _buildHeader(context, user),
              const SizedBox(height: 20),

              // Hero card baca TimelineViewModel via Consumer.
              Consumer<TimelineViewModel>(
                builder: (_, timelineVm, __) => _buildHeroCard(
                  context,
                  user,
                  authVm.daysUntilDefense,
                  timelineVm.overallProgress,
                ),
              ),
              const SizedBox(height: 16),
              _buildStatsRow(context),
              const SizedBox(height: 24),
              SectionHeader(
                title: 'Milestone Berikutnya',
                action: 'Lihat semua',
                onAction: () => context.go('/timeline'),
              ),
              const SizedBox(height: 12),
              Consumer<TimelineViewModel>(
                builder: (_, timelineVm, __) {
                  final upcoming = timelineVm.upcomingMilestones.take(3).toList();
                  if (upcoming.isEmpty) {
                    return const Card(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Icon(Icons.celebration_rounded,
                                size: 36, color: AppColors.success),
                            SizedBox(height: 8),
                            Text('Yeay! Tidak ada milestone tertunda 🎉',
                                style: TextStyle(fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ),
                    );
                  }
                  return Column(
                    children: upcoming
                        .map((m) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _MilestonePreview(milestone: m),
                            ))
                        .toList(),
                  );
                },
              ),
              const SizedBox(height: 16),
              const SectionHeader(title: 'Akses Cepat'),
              const SizedBox(height: 12),
              _buildQuickActions(context),
              const SizedBox(height: 24),
              const SectionHeader(title: 'Wellness Hari Ini'),
              const SizedBox(height: 12),
              Consumer<WellnessViewModel>(
                builder: (_, wellnessVm, __) =>
                    _buildWellnessCard(context, wellnessVm.averageScore),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, UserProfile user) {
    final greeting = _greeting();
    return Row(
      children: [
        GestureDetector(
          onTap: () => context.push('/profile'),
          child: Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Text(
                user.avatarSeed,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                greeting,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '${user.name.split(' ').first} 👋',
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Tidak ada notifikasi baru')),
            );
          },
          icon: Stack(
            children: [
              const Icon(Icons.notifications_outlined, size: 28),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 11) return 'Selamat pagi,';
    if (h < 15) return 'Selamat siang,';
    if (h < 18) return 'Selamat sore,';
    return 'Selamat malam,';
  }

  Widget _buildHeroCard(BuildContext context, UserProfile user, int daysLeft,
      double progress) {
    return GradientCard(
      onTap: () => context.go('/timeline'),
      gradient: AppColors.primaryGradient,
      padding: const EdgeInsets.all(22),
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
                  'TARGET SIDANG',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              const Spacer(),
              const Icon(Icons.flag_rounded, color: Colors.white70, size: 20),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            DateFormat('d MMMM yyyy', 'id_ID').format(user.targetDefenseDate),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                '$daysLeft hari lagi',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 4,
                height: 4,
                decoration: const BoxDecoration(
                  color: Colors.white54,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                user.supervisor.split(',').first,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Progres keseluruhan',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${(progress * 100).toStringAsFixed(0)}%',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              valueColor: const AlwaysStoppedAnimation(Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Consumer<TimelineViewModel>(
            builder: (_, vm, __) => _StatCard(
              label: 'Milestone',
              value: '${vm.doneCount}/${vm.totalCount}',
              icon: Icons.check_circle_outline_rounded,
              color: AppColors.success,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Consumer<ReferenceViewModel>(
            builder: (_, vm, __) => _StatCard(
              label: 'Referensi',
              value: '${vm.totalCount}',
              icon: Icons.menu_book_outlined,
              color: AppColors.info,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Consumer<WellnessViewModel>(
            builder: (_, vm, __) => _StatCard(
              label: 'Mood 7H',
              value: vm.averageScore.toStringAsFixed(1),
              icon: Icons.favorite_outline_rounded,
              color: AppColors.accent,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final items = [
      _QuickAction(
        icon: Icons.add_task_rounded,
        label: 'Tambah\nMilestone',
        color: AppColors.primary,
        onTap: () => context.push('/add-milestone'),
      ),
      _QuickAction(
        icon: Icons.event_available_rounded,
        label: 'Jadwal\nBimbingan',
        color: AppColors.success,
        onTap: () => context.push('/schedule-consultation'),
      ),
      _QuickAction(
        icon: Icons.upload_file_rounded,
        label: 'Unggah\nReferensi',
        color: AppColors.warning,
        onTap: () => context.push('/add-reference'),
      ),
      _QuickAction(
        icon: Icons.smart_toy_rounded,
        label: 'SkripsiBot\nAI',
        color: AppColors.accent,
        onTap: () => context.push('/skripsibot'),
      ),
    ];
    return Row(
      children: items
          .map((a) => Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: a == items.last ? 0 : 10),
                  child: a,
                ),
              ))
          .toList(),
    );
  }

  Widget _buildWellnessCard(BuildContext context, double avg) {
    final emoji = avg >= 4
        ? '😊'
        : avg >= 3
            ? '🙂'
            : avg >= 2
                ? '😟'
                : '😢';
    final tone = avg >= 3.5
        ? 'Kamu lagi baik-baik aja minggu ini. Keep going! 💪'
        : avg >= 2.5
            ? 'Mood-mu netral. Coba istirahat sejenak ya.'
            : 'Mood lagi turun. Yuk cek Wellness Corner.';
    return GradientCard(
      onTap: () => context.push('/wellness'),
      gradient: AppColors.accentGradient,
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Center(child: Text(emoji, style: const TextStyle(fontSize: 32))),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Skor Mood: ${avg.toStringAsFixed(1)}/5',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  tone,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: Colors.white),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 16, color: color),
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            Text(
              label,
              style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppColors.divider),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 18, color: color),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MilestonePreview extends StatelessWidget {
  final Milestone milestone;
  const _MilestonePreview({required this.milestone});

  @override
  Widget build(BuildContext context) {
    final daysLeft = milestone.dueDate.difference(DateTime.now()).inDays;
    final urgent = daysLeft <= 2;
    return Card(
      child: InkWell(
        onTap: () => context.go('/timeline'),
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: milestone.statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    milestone.chapter.split(' ').last,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: milestone.statusColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      milestone.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.schedule_rounded,
                          size: 12,
                          color: urgent ? AppColors.danger : AppColors.textHint,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          daysLeft == 0
                              ? 'Hari ini'
                              : daysLeft > 0
                                  ? '$daysLeft hari lagi'
                                  : 'Lewat ${-daysLeft} hari',
                          style: TextStyle(
                            fontSize: 11,
                            color: urgent
                                ? AppColors.danger
                                : AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
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
