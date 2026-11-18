import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/app_store.dart';
import '../../theme/app_theme.dart';
import '../../utils/format.dart';
import '../../widgets/brand_app_bar.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/feedback.dart';
import '../../widgets/primary_button.dart';

/// V11 - Invois (Invoice list)
class InvoiceListScreen extends StatelessWidget {
  const InvoiceListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = AppStore.instance;
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final invoices = store.invoices;
        return Scaffold(
          appBar:
              BrandAppBar(showBack: true, onBack: () => context.go('/home')),
          body: ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              const Text('Invois',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
              const SizedBox(height: AppSpacing.md),
              PrimaryButton(
                label: 'Sediakan invois',
                icon: Icons.add,
                onPressed: () => context.go('/invois/baru'),
              ),
              const SizedBox(height: AppSpacing.lg),
              const SectionLabel('Invois terkini'),
              if (invoices.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: AppSpacing.xl),
                  child: EmptyState('Tiada invois lagi',
                      icon: Icons.receipt_long_outlined),
                ),
              ...invoices.map((inv) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: Card(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(AppSpacing.radius),
                        onTap: () => context.go('/invois/${inv.id}/status'),
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
                            ],
                          ),
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
