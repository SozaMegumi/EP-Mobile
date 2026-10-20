import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/dummy_data.dart';
import '../../theme/app_theme.dart';
import '../../widgets/brand_app_bar.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/primary_button.dart';

/// V13 - Status invois (Invoice status)
class InvoiceStatusScreen extends StatelessWidget {
  final String invoiceId;

  const InvoiceStatusScreen({super.key, required this.invoiceId});

  @override
  Widget build(BuildContext context) {
    final inv = DummyData.invoices.firstWhere(
      (e) => e.id == invoiceId,
      orElse: () => DummyData.invoices.first,
    );

    return Scaffold(
      appBar: BrandAppBar(showBack: true, onBack: () => context.go('/invois')),
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
              style: const TextStyle(color: AppColors.grey500, fontSize: 12)),
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
                    value: 'RM${inv.amount.toStringAsFixed(2)}',
                    emphasize: true,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          const SectionLabel('Status pembayaran'),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: StatusTimeline(steps: DummyData.invoiceTimeline),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          SecondaryButton(
            label: 'Kembali ke invois',
            onPressed: () => context.go('/invois'),
          ),
        ],
      ),
    );
  }
}
