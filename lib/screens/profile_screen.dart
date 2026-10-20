import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/dummy_data.dart';
import '../theme/app_theme.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/brand_app_bar.dart';
import '../widgets/common_widgets.dart';
import '../widgets/primary_button.dart';

/// V15 - Profil syarikat (Company profile)
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const c = DummyData.company;
    return Scaffold(
      appBar: const BrandAppBar(),
      bottomNavigationBar: const AppBottomNav(currentIndex: 4),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          const Text('Profil syarikat',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
          const SizedBox(height: AppSpacing.lg),
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundColor: AppColors.grey100,
                  child: Text(
                    c.name.substring(0, 1),
                    style: const TextStyle(
                        fontSize: 28, fontWeight: FontWeight.w800),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(c.name,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w700)),
                const SizedBox(height: AppSpacing.xs),
                const StatusPill(label: 'Pembekal berdaftar'),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                children: [
                  DetailRow(label: 'No. pendaftaran', value: c.registrationNo),
                  const Divider(),
                  DetailRow(label: 'Kategori', value: c.category),
                  const Divider(),
                  DetailRow(label: 'E-mel', value: c.email),
                  const Divider(),
                  DetailRow(label: 'Telefon', value: c.phone),
                  const Divider(),
                  DetailRow(label: 'Alamat', value: c.address),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          SecondaryButton(
            label: 'Notifikasi',
            icon: Icons.notifications_none,
            onPressed: () => context.go('/notifikasi'),
          ),
          const SizedBox(height: AppSpacing.md),
          PrimaryButton(
            label: 'Log keluar',
            icon: Icons.logout,
            onPressed: () => context.go('/login'),
          ),
        ],
      ),
    );
  }
}
