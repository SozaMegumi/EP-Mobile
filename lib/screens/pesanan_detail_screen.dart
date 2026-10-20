import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/dummy_data.dart';
import '../theme/app_theme.dart';
import '../widgets/brand_app_bar.dart';
import '../widgets/common_widgets.dart';
import '../widgets/primary_button.dart';

/// V10 - Butiran pesanan (Order detail — e.g. Toner pencetak)
class PesananDetailScreen extends StatelessWidget {
  final String orderId;

  const PesananDetailScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    final order = DummyData.orders.firstWhere(
      (o) => o.id == orderId,
      orElse: () => DummyData.orders.first,
    );

    return Scaffold(
      appBar: BrandAppBar(
          showBack: true, onBack: () => context.go('/pesanan')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Row(
            children: [
              Expanded(
                child: Text(order.title,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w800)),
              ),
              StatusPill(label: order.status),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(order.poNumber,
              style: const TextStyle(color: AppColors.grey500, fontSize: 12)),
          const SizedBox(height: AppSpacing.lg),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                children: [
                  DetailRow(label: 'Agensi', value: order.agency),
                  const Divider(),
                  DetailRow(label: 'Kuantiti', value: '${order.quantity} unit'),
                  const Divider(),
                  DetailRow(
                    label: 'Jumlah pesanan',
                    value: 'RM${order.amount.toStringAsFixed(2)}',
                    emphasize: true,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          const SectionLabel('Status pesanan'),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: StatusTimeline(steps: DummyData.orderTimeline),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          if (order.status == 'Pesanan baharu')
            PrimaryButton(
              label: 'Terima pesanan',
              onPressed: () => context.go('/pesanan/${order.id}/diterima'),
            ),
          const SizedBox(height: AppSpacing.md),
          SecondaryButton(
            label: 'Kembali ke pesanan',
            onPressed: () => context.go('/pesanan'),
          ),
        ],
      ),
    );
  }
}
