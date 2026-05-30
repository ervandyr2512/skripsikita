// ROUTER
// GoRouter setup dengan auth-guard berdasarkan state AuthViewModel.
// MVVM: Router membaca state dari ViewModel (bukan langsung dari Repository).

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/login_screen.dart';
import '../../features/auth/register_screen.dart';
import '../../features/bimbingan/bimbingan_screen.dart';
import '../../features/bimbingan/schedule_consultation_screen.dart';
import '../../features/dashboard/dashboard_screen.dart';
import '../../features/main_shell/main_shell.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/references/add_reference_screen.dart';
import '../../features/references/references_screen.dart';
import '../../features/skripsibot/skripsibot_screen.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/squad/squad_screen.dart';
import '../../features/timeline/add_milestone_screen.dart';
import '../../features/timeline/timeline_screen.dart';
import '../../features/wellness/mood_history_screen.dart';
import '../../features/wellness/wellness_screen.dart';
import '../../viewmodels/auth_viewmodel.dart';

class AppRouter {
  static GoRouter router(AuthViewModel authVm) {
    return GoRouter(
      initialLocation: '/splash',
      refreshListenable: authVm,
      redirect: (context, state) {
        final isAuth = authVm.isAuthenticated;
        final hasOnboarded = authVm.hasCompletedOnboarding;
        final path = state.matchedLocation;

        if (path == '/splash') return null;

        if (!hasOnboarded && path != '/onboarding') {
          return '/onboarding';
        }

        final isAuthRoute = path == '/login' || path == '/register';
        if (!isAuth && !isAuthRoute && hasOnboarded) {
          return '/login';
        }
        if (isAuth && isAuthRoute) {
          return '/home';
        }
        return null;
      },
      routes: [
        GoRoute(path: '/splash', builder: (_, __) => const SplashScreen()),
        GoRoute(path: '/onboarding', builder: (_, __) => const OnboardingScreen()),
        GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
        GoRoute(path: '/register', builder: (_, __) => const RegisterScreen()),

        ShellRoute(
          builder: (context, state, child) => MainShell(child: child),
          routes: [
            GoRoute(path: '/home', builder: (_, __) => const DashboardScreen()),
            GoRoute(path: '/timeline', builder: (_, __) => const TimelineScreen()),
            GoRoute(path: '/bimbingan', builder: (_, __) => const BimbinganScreen()),
            GoRoute(path: '/references', builder: (_, __) => const ReferencesScreen()),
            GoRoute(path: '/squad', builder: (_, __) => const SquadScreen()),
          ],
        ),

        GoRoute(path: '/add-milestone', builder: (_, __) => const AddMilestoneScreen()),
        GoRoute(path: '/schedule-consultation', builder: (_, __) => const ScheduleConsultationScreen()),
        GoRoute(path: '/add-reference', builder: (_, __) => const AddReferenceScreen()),
        GoRoute(path: '/wellness', builder: (_, __) => const WellnessScreen()),
        GoRoute(path: '/mood-history', builder: (_, __) => const MoodHistoryScreen()),
        GoRoute(path: '/skripsibot', builder: (_, __) => const SkripsiBotScreen()),
        GoRoute(path: '/profile', builder: (_, __) => const ProfileScreen()),
      ],
      errorBuilder: (context, state) => Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.warning_amber_rounded, size: 64, color: Colors.orange),
                const SizedBox(height: 16),
                const Text('Halaman tidak ditemukan',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(state.uri.toString(), style: TextStyle(color: Colors.grey[600])),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => context.go('/home'),
                  child: const Text('Kembali ke Beranda'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
