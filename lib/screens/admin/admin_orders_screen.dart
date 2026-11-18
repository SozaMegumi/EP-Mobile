import 'package:flutter/material.dart';

import '../../data/app_store.dart';
import '../../theme/app_theme.dart';
import '../../utils/format.dart';
import '../../widgets/admin_bottom_nav.dart';
import '../../widgets/brand_app_bar.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/feedback.dart';
import '../../widgets/primary_button.dart';

/// A04 - Keluarkan pesanan (Admin: issue orders and track them)
class AdminOrdersScreen extends StatelessWidget {
  const AdminOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = AppStore.instance;
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final toIssue = store.tendersAwaitingOrder;
        final orders = store.orders;
        return Scaffold(
          appBar: const BrandAppBar(),
          bottomNavigationBar: const AdminBottomNav(currentIndex: 2),
          body: ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              const Text('Pesanan',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
              const SizedBox(height: AppSpacing.lg),
              const SectionLabel('Tawaran berjaya menunggu pesanan'),
              if (toIssue.isEmpty)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(AppSpacing.lg),
                    child: Text('Tiada tawaran menunggu pesanan',
                        style: TextStyle(color: AppColors.grey500)),
                  ),
                ),
              ...toIssue.map((t) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(t.title,
                                style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700)),
                            const SizedBox(height: AppSpacing.xs),
                            Text('${t.id} · ${Fmt.rm(t.amount)}',
                                style: const TextStyle(
                                    color: AppColors.grey500, fontSize: 12)),
                            const SizedBox(height: AppSpacing.md),
                            PrimaryButton(
                              label: 'Keluarkan pesanan',
                              onPressed: () async {
                                final o = await runAction(
                                    context, () => store.issueOrder(t.id));
                                if (o != null && context.mounted) {
                                  showToast(context,
                                      'Pesanan ${o.poNumber} dikeluarkan');
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  )),
              const SizedBox(height: AppSpacing.lg),
              const SectionLabel('Pesanan dikeluarkan'),
              if (orders.isEmpty)
                const EmptyState('Tiada pesanan lagi',
                    icon: Icons.local_shipping_outlined),
              ...orders.map((o) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(o.title,
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700)),
                                ),
                                StatusPill(label: o.status),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Text(o.poNumber,
                                style: const TextStyle(
                                    color: AppColors.grey500, fontSize: 12)),
                            const SizedBox(height: AppSpacing.sm),
                            Row(
                              children: [
                                Text(o.agency,
                                    style: const TextStyle(
                                        color: AppColors.grey700,
                                        fontSize: 12)),
                                const Spacer(),
                                Text(Fmt.rm(o.amount),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  )),
            ],
          ),
        );
      },
    );
  }
}
