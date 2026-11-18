import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/app_store.dart';
import '../models/app_models.dart';
import '../theme/app_theme.dart';
import '../utils/format.dart';
import '../widgets/brand_app_bar.dart';
import '../widgets/common_widgets.dart';
import '../widgets/feedback.dart';
import '../widgets/primary_button.dart';

/// V10 - Butiran pesanan (Order detail)
class PesananDetailScreen extends StatelessWidget {
  final String orderId;
  const PesananDetailScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    final store = AppStore.instance;
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final order = store.orderById(orderId);
        if (order == null) {
          return NotFoundScaffold(
            message: 'Pesanan tidak dijumpai',
            backLabel: 'Kembali ke pesanan',
            onBack: () => context.go('/pesanan'),
          );
        }
        return Scaffold(
          appBar:
              BrandAppBar(showBack: true, onBack: () => context.go('/pesanan')),
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
                  style:
                      const TextStyle(color: AppColors.grey500, fontSize: 12)),
              const SizedBox(height: AppSpacing.lg),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    children: [
                      DetailRow(label: 'Agensi', value: order.agency),
                      const Divider(),
                      DetailRow(
                          label: 'Kuantiti', value: '${order.quantity} unit'),
                      const Divider(),
                      DetailRow(
                        label: 'Jumlah pesanan',
                        value: Fmt.rm(order.amount),
                        emphasize: true,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              const SectionLabel('Status pesanan'),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: StatusTimeline(steps: store.orderTimeline(order)),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              if (order.status == Statuses.orderNew)
                PrimaryButton(
                  label: 'Terima pesanan',
                  onPressed: () async {
                    final ok = await runAction(
                        context, () => store.acceptOrder(order.id));
                    if (ok != null && context.mounted) {
                      context.go('/pesanan/${order.id}/diterima');
                    }
                  },
                )
              else
                PrimaryButton(
                  label: 'Sediakan invois',
                  onPressed: () => context.go('/invois/baru?order=${order.id}'),
                ),
              const SizedBox(height: AppSpacing.md),
              SecondaryButton(
                label: 'Kembali ke pesanan',
                onPressed: () => context.go('/pesanan'),
              ),
            ],
          ),
        );
      },
    );
  }
}
