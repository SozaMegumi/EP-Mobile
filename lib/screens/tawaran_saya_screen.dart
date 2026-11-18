import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/app_store.dart';
import '../models/app_models.dart';
import '../utils/format.dart';
import '../widgets/feedback.dart';
import '../theme/app_theme.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/brand_app_bar.dart';
import '../widgets/common_widgets.dart';

/// V08 - Tawaran saya (My tenders)
class TawaranSayaScreen extends StatefulWidget {
  const TawaranSayaScreen({super.key});

  @override
  State<TawaranSayaScreen> createState() => _TawaranSayaScreenState();
}

class _TawaranSayaScreenState extends State<TawaranSayaScreen> {
  int _tab = 0; // 0 Semua, 1 Aktif

  static const _tabs = ['Semua', 'Aktif'];

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppStore.instance,
      builder: (context, _) => _build(context),
    );
  }

  Widget _build(BuildContext context) {
    final store = AppStore.instance;
    final filtered = _tab == 1
        ? store.tenders.where((t) => t.status == Statuses.tenderSent).toList()
        : store.tenders;

    return Scaffold(
      appBar: const BrandAppBar(),
      bottomNavigationBar: const AppBottomNav(currentIndex: 2),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.sm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Tawaran saya',
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: List.generate(_tabs.length, (i) {
                    final selected = i == _tab;
                    return Padding(
                      padding: const EdgeInsets.only(right: AppSpacing.sm),
                      child: ChoiceChip(
                        label: Text(_tabs[i]),
                        selected: selected,
                        onSelected: (_) => setState(() => _tab = i),
                        showCheckmark: false,
                        selectedColor: AppColors.black,
                        labelStyle: TextStyle(
                          color: selected ? AppColors.white : AppColors.grey700,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
          Expanded(
            child: filtered.isEmpty
                ? const EmptyState(
                    'Tiada tawaran lagi. Pilih pelawaan untuk menyediakan tawaran.',
                    icon: Icons.description_outlined)
                : ListView.separated(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppSpacing.md),
                    itemBuilder: (_, i) {
                      final t = filtered[i];
                      return Card(
                        child: InkWell(
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radius),
                          onTap: () {
                            if (t.status == Statuses.tenderDraft) {
                              try {
                                store.loadDraftFromTender(t.id);
                                context.go(
                                    '/tawaran/baru/spesifikasi?inv=${t.invitationId}');
                              } on StoreException catch (e) {
                                showToast(context, e.message);
                              }
                            } else {
                              context.go('/tawaran/rekod?id=${t.id}');
                            }
                          },
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
                                    Text(
                                        t.status == Statuses.tenderDraft
                                            ? 'Belum dihantar'
                                            : 'Dihantar: ${t.submittedDate}',
                                        style: const TextStyle(
                                            color: AppColors.grey700,
                                            fontSize: 12)),
                                    const Spacer(),
                                    Text(
                                      Fmt.rm(t.amount),
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
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
