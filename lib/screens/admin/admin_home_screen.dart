import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/app_store.dart';
import '../../models/app_models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/admin_bottom_nav.dart';
import '../../widgets/brand_app_bar.dart';
import '../../widgets/feedback.dart';
import '../../widgets/primary_button.dart';

/// A01 - Utama pentadbir (Admin dashboard)
class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = AppStore.instance;
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final pendingTenders =
            store.tenders.where((t) => t.status == Statuses.tenderSent).length;
        final toIssue = store.tendersAwaitingOrder.length;
        final pendingInvoices = store.invoices
            .where((i) =>
                i.status == Statuses.invoiceSent ||
                i.status == Statuses.invoiceReviewed)
            .length;
        return Scaffold(
          appBar: const BrandAppBar(),
          bottomNavigationBar: const AdminBottomNav(currentIndex: 0),
          body: ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              const Text('Panel pentadbir',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
              const SizedBox(height: AppSpacing.xs),
              Text(store.currentUser?.displayName ?? '',
                  style:
                      const TextStyle(color: AppColors.grey500, fontSize: 13)),
              const SizedBox(height: AppSpacing.lg),
              _Tile(
                value: pendingTenders,
                label: 'Tawaran menunggu keputusan',
                onTap: () => context.go('/admin/tawaran'),
              ),
              const SizedBox(height: AppSpacing.md),
              _Tile(
                value: toIssue,
                label: 'Tawaran berjaya menunggu pesanan',
                onTap: () => context.go('/admin/pesanan'),
              ),
              const SizedBox(height: AppSpacing.md),
              _Tile(
                value: pendingInvoices,
                label: 'Invois menunggu semakan / bayaran',
                onTap: () => context.go('/admin/invois'),
              ),
              const SizedBox(height: AppSpacing.xl),
              SecondaryButton(
                label: 'Set semula data demo',
                icon: Icons.restore,
                onPressed: () async {
                  final ok = await confirmDialog(
                    context,
                    title: 'Set semula data demo',
                    message:
                        'Semua perubahan akan dipadam dan data contoh dipulihkan. Teruskan?',
                    confirmLabel: 'Set semula',
                  );
                  if (!ok || !context.mounted) return;
                  final done = await runVoid(context, store.resetDemoData);
                  if (done && context.mounted) {
                    showToast(context, 'Data demo telah dipulihkan');
                  }
                },
              ),
              const SizedBox(height: AppSpacing.md),
              PrimaryButton(
                label: 'Log keluar',
                icon: Icons.logout,
                onPressed: () async {
                  await store.logout();
                  if (context.mounted) context.go('/login');
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Tile extends StatelessWidget {
  final int value;
  final String label;
  final VoidCallback onTap;
  const _Tile({required this.value, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSpacing.radius),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(
            children: [
              Text('$value',
                  style: const TextStyle(
                      fontSize: 28, fontWeight: FontWeight.w800)),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Text(label,
                    style: const TextStyle(
                        color: AppColors.grey700, fontSize: 13)),
              ),
              const Icon(Icons.chevron_right, color: AppColors.grey500),
            ],
          ),
        ),
      ),
    );
  }
}
