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

/// V19 - Pesanan diterima pembekal (Order accepted by supplier)
class PesananAcceptedScreen extends StatelessWidget {
  final String orderId;
  const PesananAcceptedScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    final store = AppStore.instance;
    final order = store.orderById(orderId);
    if (order == null) {
      return NotFoundScaffold(
        message: 'Pesanan tidak dijumpai',
        backLabel: 'Kembali ke pesanan',
        onBack: () => context.go('/pesanan'),
      );
    }
    if (order.status != Statuses.orderAccepted) {
      // Not accepted yet: send the user to the detail page to accept.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) context.go('/pesanan/${order.id}');
      });
      return const Scaffold(body: SizedBox.shrink());
    }
    return Scaffold(
      appBar: BrandAppBar(
          showBack: true, onBack: () => context.go('/pesanan/${order.id}')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          const SizedBox(height: AppSpacing.lg),
          Center(
            child: Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.black, width: 2),
              ),
              child: const Icon(Icons.check, size: 36),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          const Center(
            child: Text('Pesanan diterima',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
          ),
          const SizedBox(height: AppSpacing.xs),
          Center(
            child: Text(order.poNumber,
                style: const TextStyle(color: AppColors.grey500, fontSize: 12)),
          ),
          const SizedBox(height: AppSpacing.xl),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                children: [
                  DetailRow(label: 'Item', value: order.title),
                  const Divider(),
                  DetailRow(label: 'Kuantiti', value: '${order.quantity} unit'),
                  const Divider(),
                  DetailRow(
                      label: 'Jumlah pesanan',
                      value: Fmt.rm(order.amount),
                      emphasize: true),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          const SectionLabel('Langkah seterusnya'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: StatusTimeline(
                steps: [
                  TimelineStep(
                    title: 'Pesanan diterima',
                    subtitle: 'Selesai · ${order.acceptedAt}',
                    done: true,
                  ),
                  const TimelineStep(
                    title: 'Penghantaran barang',
                    subtitle: 'Sediakan penghantaran',
                    done: false,
                  ),
                  const TimelineStep(
                    title: 'Penyediaan invois',
                    subtitle: 'Selepas penghantaran',
                    done: false,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          PrimaryButton(
            label: 'Sediakan invois',
            onPressed: () => context.go('/invois/baru?order=${order.id}'),
          ),
          const SizedBox(height: AppSpacing.md),
          SecondaryButton(
            label: 'Kembali ke utama',
            onPressed: () => context.go('/home'),
          ),
        ],
      ),
    );
  }
}
