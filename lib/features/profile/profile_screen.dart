import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../shared/widgets/gradient_card.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/reference_viewmodel.dart';
import '../../viewmodels/timeline_viewmodel.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authVm = context.watch<AuthViewModel>();
    final timelineVm = context.watch<TimelineViewModel>();
    final referenceVm = context.watch<ReferenceViewModel>();
    final user = authVm.user!;

    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          GradientCard(
            gradient: AppColors.primaryGradient,
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Center(
                    child: Text(
                      user.avatarSeed,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  user.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user.email,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${user.prodi} • Semester ${user.semester}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Statistik Akademik',
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                  ),
                  const SizedBox(height: 12),
                  _statRow(Icons.badge_outlined, 'NIM', user.nim),
                  const Divider(height: 16),
                  _statRow(Icons.school_outlined, 'Pembimbing', user.supervisor),
                  const Divider(height: 16),
                  _statRow(Icons.calendar_today_outlined, 'Target Sidang',
                      DateFormat('d MMMM yyyy', 'id_ID').format(user.targetDefenseDate)),
                  const Divider(height: 16),
                  _statRow(Icons.check_circle_outline_rounded, 'Milestone Selesai',
                      '${timelineVm.doneCount} dari ${timelineVm.totalCount}'),
                  const Divider(height: 16),
                  _statRow(Icons.menu_book_outlined, 'Referensi Tersimpan', '${referenceVm.totalCount}'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Card(
            child: Column(
              children: [
                _menuItem(
                  context,
                  Icons.edit_outlined,
                  'Edit Profil',
                  () {
                    // === Demo Navigator.push + MaterialPageRoute ===
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const EditProfileScreen(),
                        fullscreenDialog: false,
                      ),
                    );
                  },
                ),
                const Divider(height: 1, indent: 56),
                _menuItem(context, Icons.notifications_outlined, 'Pengaturan Notifikasi',
                    () => _showSnack(context, 'Pengaturan notifikasi (demo)')),
                const Divider(height: 1, indent: 56),
                _menuItem(context, Icons.lock_outline_rounded, 'Privasi & Keamanan',
                    () => _showSnack(context, 'Privasi & keamanan (demo)')),
                const Divider(height: 1, indent: 56),
                _menuItem(context, Icons.language_outlined, 'Bahasa',
                    () => _showSnack(context, 'Bahasa: Indonesia')),
                const Divider(height: 1, indent: 56),
                _menuItem(context, Icons.help_outline_rounded, 'Bantuan & FAQ',
                    () => _showSnack(context, 'Bantuan (demo)')),
                const Divider(height: 1, indent: 56),
                _menuItem(context, Icons.info_outline_rounded, 'Tentang SkripsiKita',
                    () => _showAbout(context)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Card(
            color: AppColors.danger.withValues(alpha: 0.04),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: AppColors.danger.withValues(alpha: 0.3)),
            ),
            child: ListTile(
              leading: const Icon(Icons.logout_rounded, color: AppColors.danger),
              title: const Text(
                'Keluar',
                style: TextStyle(color: AppColors.danger, fontWeight: FontWeight.w700),
              ),
              onTap: () => _confirmLogout(context),
            ),
          ),
          const SizedBox(height: 32),
          const Center(
            child: Text(
              'SkripsiKita v1.0.0',
              style: TextStyle(fontSize: 11, color: AppColors.textHint),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _statRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.textSecondary),
        const SizedBox(width: 10),
        SizedBox(
          width: 130,
          child: Text(
            label,
            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  Widget _menuItem(BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return ListTile(
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppColors.primary, size: 18),
      ),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
      trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textHint),
      onTap: onTap,
    );
  }

  void _showSnack(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Keluar dari SkripsiKita?'),
        content: const Text('Kamu perlu login lagi untuk mengakses datamu.'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.danger,
              minimumSize: const Size(80, 40),
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              await context.read<AuthViewModel>().logout();
              if (context.mounted) context.go('/login');
            },
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
  }

  void _showAbout(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'SkripsiKita',
      applicationVersion: '1.0.0',
      applicationIcon: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Icon(Icons.school_rounded, color: Colors.white, size: 32),
      ),
      children: const [
        SizedBox(height: 16),
        Text(
          'Pendamping cerdas perjalanan skripsi mahasiswa Indonesia. Dibuat dengan ❤️ untuk semua mahasiswa tingkat akhir.',
          style: TextStyle(height: 1.5),
        ),
      ],
    );
  }
}
