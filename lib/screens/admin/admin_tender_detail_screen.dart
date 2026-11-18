import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/app_store.dart';
import '../../models/app_models.dart';
import '../../theme/app_theme.dart';
import '../../utils/format.dart';
import '../../widgets/brand_app_bar.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/feedback.dart';
import '../../widgets/primary_button.dart';

/// A03 - Butiran tawaran (Admin: review, award or reject a tender)
class AdminTenderDetailScreen extends StatelessWidget {
  final String tenderId;
  const AdminTenderDetailScreen({super.key, required this.tenderId});

  @override
  Widget build(BuildContext context) {
    final store = AppStore.instance;
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final t = store.tenderById(tenderId);
        if (t == null || t.status == Statuses.tenderDraft) {
          return NotFoundScaffold(
            message: 'Tawaran tidak dijumpai',
            backLabel: 'Kembali ke tawaran',
            onBack: () => context.go('/admin/tawaran'),
          );
        }
        final inv = store.invitationById(t.invitationId);
        final order = store.orderForTender(t.id);
        return Scaffold(
          appBar: BrandAppBar(
              showBack: true, onBack: () => context.go('/admin/tawaran')),
          body: ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(t.title,
                        style: const TextStyle(
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
                      DetailRow(
                          label: 'Pembekal', value: store.company.name),
                      const Divider(),
                      DetailRow(label: 'Agensi', value: inv?.agency ?? '-'),
                      const Divider(),
                      DetailRow(label: 'Spesifikasi', value: t.spec),
                      const Divider(),
                      DetailRow(
                          label: 'Kuantiti',
                          value: '${t.quantity} ${inv?.unit ?? 'unit'}'),
                      const Divider(),
                      DetailRow(
                          label: 'Harga seunit', value: Fmt.rm(t.unitPrice)),
                      const Divider(),
                      DetailRow(
                          label: 'Jumlah tawaran',
                          value: Fmt.rm(t.amount),
                          emphasize: true),
                      const Divider(),
                      DetailRow(label: 'Tarikh hantar', value: t.submittedAt),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              const SectionLabel('Dokumen'),
              Card(
                child: t.documents.isEmpty
                    ? const ListTile(title: Text('Tiada dokumen'))
                    : Column(
                        children: [
                          for (var i = 0; i < t.documents.length; i++) ...[
                            if (i > 0) const Divider(height: 1),
                            ListTile(
                              leading: const Icon(Icons.description_outlined),
                              title: Text(t.documents[i]),
                            ),
                          ],
                        ],
                      ),
              ),
              const SizedBox(height: AppSpacing.lg),
              const SectionLabel('Status penilaian'),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: StatusTimeline(steps: store.tenderTimeline(t)),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              if (t.status == Statuses.tenderSent) ...[
                PrimaryButton(
                  label: 'Terima tawaran (Berjaya)',
                  onPressed: () async {
                    final ok = await runVoid(context, () => store.decideTender(t.id, award: true));
                    if (ok && context.mounted) {
                      showToast(context, 'Tawaran diluluskan');
                    }
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                SecondaryButton(
                  label: 'Tolak tawaran',
                  onPressed: () async {
                    final yes = await confirmDialog(
                      context,
                      title: 'Tolak tawaran',
                      message: 'Tawaran ${t.id} akan ditandakan tidak berjaya.',
                      confirmLabel: 'Tolak',
                    );
                    if (!yes || !context.mounted) return;
                    final ok = await runVoid(context, () => store.decideTender(t.id, award: false));
                    if (ok && context.mounted) {
                      showToast(context, 'Tawaran ditolak');
                    }
                  },
                ),
              ] else if (t.status == Statuses.tenderWon && order == null)
                PrimaryButton(
                  label: 'Keluarkan pesanan',
                  onPressed: () async {
                    final o = await runAction(
                        context, () => store.issueOrder(t.id));
                    if (o != null && context.mounted) {
                      showToast(context, 'Pesanan ${o.poNumber} dikeluarkan');
                    }
                  },
                )
              else if (order != null)
                DetailRow(
                    label: 'Pesanan dikeluarkan',
                    value: '${order.poNumber} · ${order.status}'),
            ],
          ),
        );
      },
    );
  }
}
