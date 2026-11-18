import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/app_store.dart';
import '../../theme/app_theme.dart';
import '../../utils/format.dart';
import '../../widgets/brand_app_bar.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/feedback.dart';
import '../../widgets/primary_button.dart';

/// V13 - Status invois (Invoice status)
class InvoiceStatusScreen extends StatelessWidget {
  final String invoiceId;
  const InvoiceStatusScreen({super.key, required this.invoiceId});

  @override
  Widget build(BuildContext context) {
    final store = AppStore.instance;
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final inv = store.invoiceById(invoiceId);
        if (inv == null) {
          return NotFoundScaffold(
            message: 'Invois tidak dijumpai',
            backLabel: 'Kembali ke invois',
            onBack: () => context.go('/invois'),
          );
        }
        return Scaffold(
          appBar:
              BrandAppBar(showBack: true, onBack: () => context.go('/invois')),
          body: ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text('Status invois',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w800)),
                  ),
                  StatusPill(label: inv.status),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(inv.invoiceNo,
                  style:
                      const TextStyle(color: AppColors.grey500, fontSize: 12)),
              const SizedBox(height: AppSpacing.lg),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    children: [
                      DetailRow(label: 'Rujukan pesanan', value: inv.orderRef),
                      const Divider(),
                      DetailRow(label: 'Tarikh invois', value: inv.date),
                      const Divider(),
                      DetailRow(
                        label: 'Jumlah invois',
                        value: Fmt.rm(inv.amount),
                        emphasize: true,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              const SectionLabel('Status pembayaran'),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: StatusTimeline(steps: store.invoiceTimeline(inv)),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              if (inv.status == 'Draf') ...[
                PrimaryButton(
                  label: 'Hantar invois',
                  onPressed: () async {
                    final ok = await runVoid(context, () => store.sendInvoiceDraft(inv.id));
                    if (ok && context.mounted) {
                      context.go('/invois/berjaya');
                    }
                  },
                ),
                const SizedBox(height: AppSpacing.md),
              ],
              SecondaryButton(
                label: 'Kembali ke invois',
                onPressed: () => context.go('/invois'),
              ),
            ],
          ),
        );
      },
    );
  }
}
