import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../viewmodels/auth_viewmodel.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final _pages = [
    _OnboardItem(
      icon: Icons.timeline_rounded,
      gradient: AppColors.primaryGradient,
      title: 'Petakan Perjalanan Skripsimu',
      subtitle:
          'Pecah skripsi besar menjadi milestone kecil yang bisa kamu eksekusi setiap minggu. Tidak lagi bingung mau mulai dari mana.',
    ),
    _OnboardItem(
      icon: Icons.school_rounded,
      gradient: AppColors.infoGradient,
      title: 'Bimbingan yang Terstruktur',
      subtitle:
          'Pesan slot bimbingan dosen, tulis agenda, dan catat hasilnya — semua dalam satu tempat. Tidak ada lagi chat WA yang bolak-balik.',
    ),
    _OnboardItem(
      icon: Icons.menu_book_rounded,
      gradient: AppColors.successGradient,
      title: 'Manajemen Referensi yang Rapi',
      subtitle:
          'Simpan jurnal PDF, beri tag, dan generate sitasi APA/IEEE dalam hitungan detik. Pustakamu, terorganisir.',
    ),
    _OnboardItem(
      icon: Icons.favorite_rounded,
      gradient: AppColors.accentGradient,
      title: 'Kamu Tidak Sendirian',
      subtitle:
          'Bergabung dengan squad mahasiswa lain, lakukan check-in harian, dan jaga kesehatan mental melalui Wellness Corner.',
    ),
  ];

  void _next() async {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOut,
      );
    } else {
      await context.read<AuthViewModel>().completeOnboarding();
      if (mounted) context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLast = _currentPage == _pages.length - 1;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.school_rounded, color: Colors.white, size: 18),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'SkripsiKita',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                  if (!isLast)
                    TextButton(
                      onPressed: () async {
                        await context.read<AuthViewModel>().completeOnboarding();
                        if (mounted) context.go('/login');
                      },
                      child: const Text('Lewati'),
                    ),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 220,
                          height: 220,
                          decoration: BoxDecoration(
                            gradient: page.gradient,
                            borderRadius: BorderRadius.circular(60),
                            boxShadow: [
                              BoxShadow(
                                color: page.gradient.colors.first.withValues(alpha: 0.3),
                                blurRadius: 32,
                                offset: const Offset(0, 16),
                              ),
                            ],
                          ),
                          child: Icon(page.icon, size: 110, color: Colors.white),
                        ),
                        const SizedBox(height: 48),
                        Text(
                          page.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          page.subtitle,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_pages.length, (i) {
                      final active = i == _currentPage;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: active ? 28 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: active ? AppColors.primary : AppColors.divider,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _next,
                    child: Text(isLast ? 'Mulai Sekarang' : 'Lanjut'),
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

class _OnboardItem {
  final IconData icon;
  final Gradient gradient;
  final String title;
  final String subtitle;

  _OnboardItem({
    required this.icon,
    required this.gradient,
    required this.title,
    required this.subtitle,
  });
}
