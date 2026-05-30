import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../models/models.dart';
import '../../shared/widgets/gradient_card.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/consultation_viewmodel.dart';

class BimbinganScreen extends StatefulWidget {
  const BimbinganScreen({super.key});

  @override
  State<BimbinganScreen> createState() => _BimbinganScreenState();
}

class _BimbinganScreenState extends State<BimbinganScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

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
    final consultationVm = context.watch<ConsultationViewModel>();
    final upcoming = consultationVm.upcoming;
    final past = consultationVm.past;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bimbingan Hub'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textHint,
          indicatorColor: AppColors.primary,
          indicatorWeight: 3,
          labelStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
          tabs: const [
            Tab(text: 'Akan Datang'),
            Tab(text: 'Riwayat'),
          ],
        ),
      ),
      body: Column(
        children: [
          _buildSupervisorCard(context),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildList(upcoming, isUpcoming: true),
                _buildList(past, isUpcoming: false),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/schedule-consultation'),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.event_available_rounded, color: Colors.white),
        label: const Text('Jadwal Baru', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
      ),
    );
  }

  Widget _buildSupervisorCard(BuildContext context) {
    final user = context.watch<AuthViewModel>().user!;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: GradientCard(
        gradient: AppColors.infoGradient,
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.person_rounded, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dosen Pembimbing',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    user.supervisor,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Chat dosen akan tersedia di rilis berikutnya')),
                );
              },
              icon: const Icon(Icons.chat_bubble_outline_rounded, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(List<Consultation> items, {required bool isUpcoming}) {
    if (items.isEmpty) {
      return EmptyState(
        icon: isUpcoming ? Icons.event_outlined : Icons.history_rounded,
        title: isUpcoming ? 'Belum ada jadwal' : 'Belum ada riwayat',
        subtitle: isUpcoming
            ? 'Jadwalkan sesi bimbingan dengan dosenmu.'
            : 'Sesi bimbingan yang sudah selesai akan tampil di sini.',
        actionLabel: isUpcoming ? 'Jadwalkan Sekarang' : null,
        onAction: isUpcoming ? () => context.push('/schedule-consultation') : null,
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, i) => _ConsultationCard(consultation: items[i]),
    );
  }
}

class _ConsultationCard extends StatelessWidget {
  final Consultation consultation;
  const _ConsultationCard({required this.consultation});

  @override
  Widget build(BuildContext context) {
    final daysLeft = consultation.scheduledAt.difference(DateTime.now()).inDays;
    final isToday = daysLeft == 0 && !consultation.completed;
    final timeFormat = DateFormat('HH:mm');
    final dayFormat = DateFormat('EEE, d MMM yyyy', 'id_ID');

    return Card(
      child: InkWell(
        onTap: () => _showDetail(context),
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  gradient: consultation.completed
                      ? const LinearGradient(colors: [Color(0xFF10B981), Color(0xFF34D399)])
                      : isToday
                          ? const LinearGradient(colors: [Color(0xFFFB7185), Color(0xFFF472B6)])
                          : AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat('d', 'id_ID').format(consultation.scheduledAt),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        height: 1,
                      ),
                    ),
                    Text(
                      DateFormat('MMM', 'id_ID').format(consultation.scheduledAt).toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.access_time_rounded, size: 12, color: AppColors.textHint),
                        const SizedBox(width: 4),
                        Text(
                          '${timeFormat.format(consultation.scheduledAt)} • ${consultation.durationMinutes} menit',
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      consultation.agenda.split('\n').first,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dayFormat.format(consultation.scheduledAt),
                      style: const TextStyle(fontSize: 11, color: AppColors.textHint),
                    ),
                  ],
                ),
              ),
              if (isToday)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'HARI INI',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      color: AppColors.accent,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              if (consultation.completed)
                const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 22),
            ],
          ),
        ),
      ),
    );
  }

  void _showDetail(BuildContext context) {
    final noteController = TextEditingController(text: consultation.notes ?? '');
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
            child: SingleChildScrollView(
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
                  const Text('Detail Bimbingan',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 16),
                  _row(Icons.calendar_today_rounded, 'Tanggal',
                      DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(consultation.scheduledAt)),
                  const SizedBox(height: 8),
                  _row(Icons.access_time_rounded, 'Waktu',
                      '${DateFormat('HH:mm').format(consultation.scheduledAt)} • ${consultation.durationMinutes} menit'),
                  const SizedBox(height: 8),
                  _row(Icons.person_rounded, 'Dosen', consultation.supervisorName),
                  const SizedBox(height: 16),
                  const Text('Agenda',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.bg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(consultation.agenda,
                        style: const TextStyle(fontSize: 13, height: 1.6)),
                  ),
                  const SizedBox(height: 16),
                  const Text('Catatan Bimbingan',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: noteController,
                    maxLines: 4,
                    readOnly: consultation.completed,
                    decoration: InputDecoration(
                      hintText: consultation.completed
                          ? 'Tidak ada catatan'
                          : 'Tulis ringkasan hasil bimbingan...',
                      fillColor: consultation.completed ? AppColors.bg : Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (!consultation.completed)
                    ElevatedButton.icon(
                      onPressed: () {
                        context
                            .read<ConsultationViewModel>()
                            .completeConsultation(consultation.id, noteController.text);
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Bimbingan selesai. Catatan tersimpan ✨'),
                            backgroundColor: AppColors.success,
                          ),
                        );
                      },
                      icon: const Icon(Icons.check_rounded, color: Colors.white),
                      label: const Text('Tandai Selesai & Simpan'),
                    )
                  else
                    OutlinedButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Tutup'),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _row(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 12),
        SizedBox(
          width: 70,
          child: Text(label,
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
        ),
        Expanded(
          child: Text(value,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
        ),
      ],
    );
  }
}
