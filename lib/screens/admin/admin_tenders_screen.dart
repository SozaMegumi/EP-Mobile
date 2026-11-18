import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/app_store.dart';
import '../../models/app_models.dart';
import '../../theme/app_theme.dart';
import '../../utils/format.dart';
import '../../widgets/admin_bottom_nav.dart';
import '../../widgets/brand_app_bar.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/feedback.dart';

/// A02 - Semak tawaran (Admin: submitted tenders)
class AdminTendersScreen extends StatefulWidget {
  const AdminTendersScreen({super.key});

  @override
  State<AdminTendersScreen> createState() => _AdminTendersScreenState();
}

class _AdminTendersScreenState extends State<AdminTendersScreen> {
  int _tab = 0;
  static const _tabs = ['Semua', 'Menunggu', 'Berjaya', 'Tidak berjaya'];
  static const _filters = [
    null,
    Statuses.tenderSent,
    Statuses.tenderWon,
    Statuses.tenderLost,
  ];

  @override
  Widget build(BuildContext context) {
    final store = AppStore.instance;
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final f = _filters[_tab];
        final items = store.submittedTenders
            .where((t) => f == null || t.status == f)
            .toList();
        return Scaffold(
          appBar: const BrandAppBar(),
          bottomNavigationBar: const AdminBottomNav(currentIndex: 1),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.lg,
                    AppSpacing.lg, AppSpacing.lg, AppSpacing.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Semak tawaran',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w800)),
                    const SizedBox(height: AppSpacing.md),
                    Wrap(
                      spacing: AppSpacing.sm,
                      children: List.generate(_tabs.length, (i) {
                        final selected = i == _tab;
                        return ChoiceChip(
                          label: Text(_tabs[i]),
                          selected: selected,
                          onSelected: (_) => setState(() => _tab = i),
                          showCheckmark: false,
                          selectedColor: AppColors.black,
                          labelStyle: TextStyle(
                            color:
                                selected ? AppColors.white : AppColors.grey700,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: items.isEmpty
                    ? const EmptyState('Tiada tawaran',
                        icon: Icons.description_outlined)
                    : ListView.separated(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        itemCount: items.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: AppSpacing.md),
                        itemBuilder: (_, i) {
                          final t = items[i];
                          return Card(
                            child: InkWell(
                              borderRadius:
                                  BorderRadius.circular(AppSpacing.radius),
                              onTap: () => context.go('/admin/tawaran/${t.id}'),
                              child: Padding(
                                padding: const EdgeInsets.all(AppSpacing.lg),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(t.title,
                                              style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w700)),
                                        ),
                                        StatusPill(label: t.status),
                                      ],
                                    ),
                                    const SizedBox(height: AppSpacing.xs),
                                    Text(t.id,
                                        style: const TextStyle(
                                            color: AppColors.grey500,
                                            fontSize: 12)),
                                    const SizedBox(height: AppSpacing.sm),
                                    Row(
                                      children: [
                                        Text('Dihantar: ${t.submittedDate}',
                                            style: const TextStyle(
                                                color: AppColors.grey700,
                                                fontSize: 12)),
                                        const Spacer(),
                                        Text(Fmt.rm(t.amount),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 14)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
