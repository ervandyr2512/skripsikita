import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_constants.dart';

class MainShell extends StatelessWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  static const _tabs = [
    _Tab(label: 'Beranda', icon: Icons.home_rounded, path: '/home'),
    _Tab(label: 'Timeline', icon: Icons.timeline_rounded, path: '/timeline'),
    _Tab(label: 'Bimbingan', icon: Icons.school_rounded, path: '/bimbingan'),
    _Tab(label: 'Referensi', icon: Icons.menu_book_rounded, path: '/references'),
    _Tab(label: 'Squad', icon: Icons.groups_rounded, path: '/squad'),
  ];

  int _calculateIndex(String location) {
    for (var i = 0; i < _tabs.length; i++) {
      if (location.startsWith(_tabs[i].path)) return i;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final currentIndex = _calculateIndex(location);

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, -2),
            ),
          ],
          border: const Border(top: BorderSide(color: AppColors.divider, width: 1)),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_tabs.length, (i) {
                final tab = _tabs[i];
                final active = i == currentIndex;
                return Expanded(
                  child: InkWell(
                    onTap: () => context.go(tab.path),
                    borderRadius: BorderRadius.circular(12),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: EdgeInsets.symmetric(horizontal: active ? 14 : 8, vertical: 6),
                            decoration: BoxDecoration(
                              color: active ? AppColors.primary.withValues(alpha: 0.12) : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              tab.icon,
                              color: active ? AppColors.primary : AppColors.textHint,
                              size: 22,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            tab.label,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: active ? FontWeight.w800 : FontWeight.w500,
                              color: active ? AppColors.primary : AppColors.textHint,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _Tab {
  final String label;
  final IconData icon;
  final String path;
  const _Tab({required this.label, required this.icon, required this.path});
}
