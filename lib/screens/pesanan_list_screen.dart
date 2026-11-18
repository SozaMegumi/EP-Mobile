import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/app_store.dart';
import '../theme/app_theme.dart';
import '../utils/format.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/brand_app_bar.dart';
import '../widgets/common_widgets.dart';
import '../widgets/feedback.dart';

/// V09 - Pesanan tempatan (Local orders list)
class PesananListScreen extends StatelessWidget {
  const PesananListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = AppStore.instance;
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final orders = store.orders;
        return Scaffold(
          appBar: const BrandAppBar(),
          bottomNavigationBar: const AppBottomNav(currentIndex: 3),
          body: ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              const Text('Pesanan tempatan',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
              const SizedBox(height: AppSpacing.lg),
              if (orders.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: AppSpacing.xxl),
                  child: EmptyState('Tiada pesanan tempatan lagi',
                      icon: Icons.local_shipping_outlined),
                ),
              ...orders.map((o) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: Card(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(AppSpacing.radius),
                        onTap: () => context.go('/pesanan/${o.id}'),
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
                                  Text(
                                    Fmt.rm(o.amount),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14),
                                  ),
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
