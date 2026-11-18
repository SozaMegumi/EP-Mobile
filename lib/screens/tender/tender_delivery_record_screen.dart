import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/app_store.dart';
import '../../theme/app_theme.dart';
import '../../utils/format.dart';
import '../../widgets/brand_app_bar.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/feedback.dart';
import '../../widgets/primary_button.dart';

/// V18 - Rekod penghantaran tawaran (Tender delivery record)
class TenderDeliveryRecordScreen extends StatelessWidget {
  /// Tender to show (from `?id=`); falls back to the last submitted tender.
  final String? tenderId;
  const TenderDeliveryRecordScreen({super.key, this.tenderId});

  @override
  Widget build(BuildContext context) {
    final store = AppStore.instance;
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final t = store.tenderById((tenderId == null || tenderId!.isEmpty)
            ? store.lastTenderId
            : tenderId!);
        if (t == null) {
          return NotFoundScaffold(
            message: 'Tawaran tidak dijumpai',
            backLabel: 'Kembali ke tawaran',
            onBack: () => context.go('/tawaran-saya'),
          );
        }
        final inv = store.invitationById(t.invitationId);
        return Scaffold(
          appBar: BrandAppBar(
              showBack: true, onBack: () => context.go('/tawaran-saya')),
          body: ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text('Rekod penghantaran',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w800)),
                  ),
                  StatusPill(label: t.status),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(t.id,
                  style:
                      const TextStyle(color: AppColors.grey500, fontSize: 12)),
              const SizedBox(height: AppSpacing.lg),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    children: [
                      DetailRow(label: 'Nama tawaran', value: t.title),
                      const Divider(),
                      DetailRow(
                          label: 'Kuantiti',
                          value: '${t.quantity} ${inv?.unit ?? 'unit'}'),
                      const Divider(),
                      DetailRow(
                          label: 'Jumlah tawaran',
                          value: Fmt.rm(t.amount),
                          emphasize: true),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              const SectionLabel('Status penghantaran'),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: StatusTimeline(steps: store.tenderTimeline(t)),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              SecondaryButton(
                label: 'Kembali ke tawaran',
                onPressed: () => context.go('/tawaran-saya'),
              ),
            ],
          ),
        );
      },
    );
  }
}
