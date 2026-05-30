import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../models/models.dart';
import '../../shared/widgets/gradient_card.dart';
import '../../viewmodels/timeline_viewmodel.dart';

class TimelineScreen extends StatefulWidget {
  const TimelineScreen({super.key});

  @override
  State<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final List<String> _filters = ['Semua', 'BAB 1', 'BAB 2', 'BAB 3', 'BAB 4', 'BAB 5'];
  String _activeFilter = 'Semua';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TimelineViewModel>();
    final milestones = vm.allMilestones;
    final filtered = _activeFilter == 'Semua'
        ? milestones
        : milestones.where((m) => m.chapter == _activeFilter).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Timeline Skripsi'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () => context.push('/add-milestone'),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildProgressOverview(context, vm),
          const SizedBox(height: 12),
          SizedBox(
            height: 40,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              itemCount: _filters.length,
              itemBuilder: (context, i) {
                final f = _filters[i];
                final active = f == _activeFilter;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(f),
                    selected: active,
                    onSelected: (_) => setState(() => _activeFilter = f),
                    backgroundColor: Colors.white,
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: active ? Colors.white : AppColors.textSecondary,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: active ? AppColors.primary : AppColors.divider,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: filtered.isEmpty
                ? const EmptyState(
                    icon: Icons.assignment_outlined,
                    title: 'Belum ada milestone',
                    subtitle: 'Tambahkan milestone pertama untuk memulai perjalanan skripsimu.',
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(20),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, i) {
                      final m = filtered[i];
                      return _MilestoneCard(milestone: m);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/add-milestone'),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text('Tambah', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
      ),
    );
  }

  Widget _buildProgressOverview(BuildContext context, TimelineViewModel vm) {
    final chapterProgress = vm.chapterProgress;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.insights_rounded, color: Colors.white, size: 18),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text('Progres per BAB',
                        style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                  ),
                  Text(
                    '${(vm.overallProgress * 100).toStringAsFixed(0)}%',
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ...chapterProgress.entries.map((e) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 50,
                          child: Text(
                            e.key,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: LinearProgressIndicator(
                              value: e.value,
                              minHeight: 8,
                              backgroundColor: AppColors.bg,
                              valueColor: AlwaysStoppedAnimation(
                                e.value == 1.0
                                    ? AppColors.success
                                    : e.value > 0
                                        ? AppColors.primary
                                        : AppColors.divider,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        SizedBox(
                          width: 36,
                          child: Text(
                            '${(e.value * 100).toStringAsFixed(0)}%',
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class _MilestoneCard extends StatelessWidget {
  final Milestone milestone;
  const _MilestoneCard({required this.milestone});

  @override
  Widget build(BuildContext context) {
    final daysLeft = milestone.dueDate.difference(DateTime.now()).inDays;
    final isDone = milestone.status == MilestoneStatus.done;
    final isOverdue = !isDone && daysLeft < 0;

    return Dismissible(
      key: ValueKey(milestone.id),
      direction: DismissDirection.endToStart,
      background: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        alignment: Alignment.centerRight,
        decoration: BoxDecoration(
          color: AppColors.danger,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(Icons.delete_rounded, color: Colors.white),
      ),
      confirmDismiss: (_) async {
        return await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Hapus milestone?'),
                content: const Text('Milestone ini akan dihapus permanen.'),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    child: const Text('Batal'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.danger,
                      minimumSize: const Size(80, 40),
                    ),
                    onPressed: () => Navigator.pop(ctx, true),
                    child: const Text('Hapus'),
                  ),
                ],
              ),
            ) ??
            false;
      },
      onDismissed: (_) {
        context.read<TimelineViewModel>().deleteMilestone(milestone.id);
      },
      child: Card(
        child: InkWell(
          onTap: () => _showDetail(context, milestone),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: milestone.statusColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        milestone.chapter,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: milestone.statusColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (milestone.priority == 1)
                      const Icon(Icons.flag_rounded, size: 16, color: AppColors.danger),
                    const Spacer(),
                    StatChip(
                      icon: isDone
                          ? Icons.check_circle_rounded
                          : isOverdue
                              ? Icons.warning_amber_rounded
                              : Icons.access_time_rounded,
                      label: milestone.statusLabel,
                      color: milestone.statusColor,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  milestone.title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    decoration: isDone ? TextDecoration.lineThrough : null,
                    color: isDone ? AppColors.textHint : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  milestone.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.calendar_today_rounded,
                        size: 14, color: AppColors.textHint),
                    const SizedBox(width: 6),
                    Text(
                      DateFormat('EEE, d MMM', 'id_ID').format(milestone.dueDate),
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    _buildStatusButton(context),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusButton(BuildContext context) {
    final isDone = milestone.status == MilestoneStatus.done;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          final newStatus = isDone ? MilestoneStatus.todo : MilestoneStatus.done;
          context.read<TimelineViewModel>().updateStatus(milestone.id, newStatus);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(isDone ? 'Milestone dibatalkan' : 'Milestone selesai! 🎉'),
              backgroundColor: isDone ? AppColors.warning : AppColors.success,
              duration: const Duration(milliseconds: 1500),
            ),
          );
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isDone ? AppColors.success : AppColors.primary,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isDone ? Icons.check_rounded : Icons.play_arrow_rounded,
                color: Colors.white,
                size: 14,
              ),
              const SizedBox(width: 4),
              Text(
                isDone ? 'Selesai' : 'Tandai',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDetail(BuildContext context, Milestone m) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
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
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: m.statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    m.chapter,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: m.statusColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(m.title,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Text(m.description,
                style: const TextStyle(color: AppColors.textSecondary, height: 1.5)),
            const SizedBox(height: 20),
            _detailRow(Icons.calendar_today_rounded, 'Tenggat',
                DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(m.dueDate)),
            const SizedBox(height: 8),
            _detailRow(Icons.flag_rounded, 'Prioritas',
                m.priority == 1 ? 'Tinggi' : m.priority == 2 ? 'Sedang' : 'Rendah'),
            const SizedBox(height: 8),
            _detailRow(Icons.info_outline_rounded, 'Status', m.statusLabel),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Tutup'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 12),
        Text('$label: ',
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
        Text(value,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
      ],
    );
  }
}
