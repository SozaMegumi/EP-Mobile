import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/dummy_data.dart';
import '../theme/app_theme.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/brand_app_bar.dart';
import '../widgets/common_widgets.dart';

/// V01 - Utama (Home / Dashboard)
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BrandAppBar(),
      bottomNavigationBar: const AppBottomNav(currentIndex: 0),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          const Text('Selamat datang',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
          const SizedBox(height: AppSpacing.xs),
          Text(DummyData.company.name,
              style: const TextStyle(color: AppColors.grey500, fontSize: 13)),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  value: '1',
                  label: 'Pelawaan terbuka',
                  onTap: () => context.go('/pelawaan'),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _StatCard(
                  value: '1',
                  label: 'Tawaran aktif',
                  onTap: () => context.go('/tawaran-saya'),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          const SectionLabel('Tarikh tutup terdekat'),
          Card(
            child: ListTile(
              title: const Text('Bekalan kertas A4',
                  style: TextStyle(fontWeight: FontWeight.w700)),
              subtitle: const Text('18 Okt 2026 · 12:00 tengah hari'),
              trailing: const StatusPill(label: 'Baru'),
              onTap: () => context.go('/pelawaan/INV-CONTOH-001'),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Row(
            children: [
              const Expanded(child: SectionLabel('Status pesanan')),
              TextButton(
                onPressed: () => context.go('/pesanan'),
                child: const Text('Lihat semua'),
              ),
            ],
          ),
          Card(
            child: Column(
              children: [
                ListTile(
                  title: const Text('Toner pencetak',
                      style: TextStyle(fontWeight: FontWeight.w700)),
                  subtitle: const Text('PO-CONTOH-018 · RM1,800.00'),
                  trailing: const StatusPill(label: 'Baharu'),
                  onTap: () => context.go('/pesanan/PO-CONTOH-018'),
                ),
                const Divider(height: 1),
                ListTile(
                  title: const Text('Bekalan kertas A4',
                      style: TextStyle(fontWeight: FontWeight.w700)),
                  subtitle: const Text('PO-CONTOH-015 · RM2,308.00'),
                  trailing: const StatusPill(label: 'Diterima'),
                  onTap: () => context.go('/pesanan/PO-CONTOH-015'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final VoidCallback? onTap;

  const _StatCard({required this.value, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSpacing.radius),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value,
                  style: const TextStyle(
                      fontSize: 28, fontWeight: FontWeight.w800)),
              const SizedBox(height: AppSpacing.xs),
              Text(label,
                  style:
                      const TextStyle(color: AppColors.grey500, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}
