import 'package:flutter/material.dart';

import '../../data/app_store.dart';
import '../../models/app_models.dart';
import '../../theme/app_theme.dart';
import '../../utils/format.dart';
import '../../widgets/admin_bottom_nav.dart';
import '../../widgets/brand_app_bar.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/feedback.dart';
import '../../widgets/primary_button.dart';

/// A05 - Semak invois (Admin: review invoices and mark them as paid)
class AdminInvoicesScreen extends StatelessWidget {
  const AdminInvoicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = AppStore.instance;
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final invoices = store.submittedInvoices;
        return Scaffold(
          appBar: const BrandAppBar(),
          bottomNavigationBar: const AdminBottomNav(currentIndex: 3),
          body: ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              const Text('Semak invois',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
              const SizedBox(height: AppSpacing.lg),
              if (invoices.isEmpty)
                const EmptyState('Tiada invois lagi',
                    icon: Icons.receipt_long_outlined),
              ...invoices.map((inv) => Padding(
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
                                  child: Text(inv.invoiceNo,
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700)),
                                ),
                                StatusPill(label: inv.status),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Text('Rujukan: ${inv.orderRef}',
                                style: const TextStyle(
                                    color: AppColors.grey500, fontSize: 12)),
                            const SizedBox(height: AppSpacing.sm),
                            Row(
                              children: [
                                Text(inv.date,
                                    style: const TextStyle(
                                        color: AppColors.grey700,
                                        fontSize: 12)),
                                const Spacer(),
                                Text(Fmt.rm(inv.amount),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14)),
                              ],
                            ),
                            if (inv.status == Statuses.invoiceSent) ...[
                              const SizedBox(height: AppSpacing.md),
                              PrimaryButton(
                                label: 'Sahkan semakan',
                                onPressed: () async {
                                  final ok = await runVoid(context, () => store.reviewInvoice(inv.id));
                                  if (ok && context.mounted) {
                                    showToast(context, 'Invois telah disemak');
                                  }
                                },
                              ),
                            ] else if (inv.status ==
                                Statuses.invoiceReviewed) ...[
                              const SizedBox(height: AppSpacing.md),
                              PrimaryButton(
                                label: 'Tandakan dibayar',
                                onPressed: () async {
                                  final ok = await runVoid(context, () => store.payInvoice(inv.id));
                                  if (ok && context.mounted) {
                                    showToast(
                                        context, 'Invois ditandakan dibayar');
                                  }
                                },
                              ),
                            ],
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
