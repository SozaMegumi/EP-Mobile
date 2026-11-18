import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_theme.dart';

/// Bottom navigation for the admin (UiTM officer) flow.
class AdminBottomNav extends StatelessWidget {
  final int currentIndex;
  const AdminBottomNav({super.key, required this.currentIndex});

  static const _routes = [
    '/admin',
    '/admin/tawaran',
    '/admin/pesanan',
    '/admin/invois',
  ];

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (i) {
        if (i != currentIndex) context.go(_routes[i]);
      },
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppColors.white,
      selectedItemColor: AppColors.black,
      unselectedItemColor: AppColors.grey500,
      selectedFontSize: 11,
      unselectedFontSize: 11,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard_outlined),
          activeIcon: Icon(Icons.dashboard),
          label: 'Utama',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.description_outlined),
          activeIcon: Icon(Icons.description),
          label: 'Tawaran',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.local_shipping_outlined),
          activeIcon: Icon(Icons.local_shipping),
          label: 'Pesanan',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.receipt_long_outlined),
          activeIcon: Icon(Icons.receipt_long),
          label: 'Invois',
        ),
      ],
    );
  }
}
