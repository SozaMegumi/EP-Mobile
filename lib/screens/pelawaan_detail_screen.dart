import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/app_store.dart';
import '../models/app_models.dart';
import '../theme/app_theme.dart';
import '../widgets/brand_app_bar.dart';
import '../widgets/common_widgets.dart';
import '../widgets/feedback.dart';
import '../widgets/primary_button.dart';

/// V03 - Butiran pelawaan (Invitation detail)
class PelawaanDetailScreen extends StatelessWidget {
  final String invitationId;

  const PelawaanDetailScreen({super.key, required this.invitationId});

  @override
  Widget build(BuildContext context) {
    final store = AppStore.instance;
    final inv = store.invitationById(invitationId);
    if (inv == null) {
      return NotFoundScaffold(
        message: 'Pelawaan tidak dijumpai',
        backLabel: 'Kembali ke pelawaan',
        onBack: () => context.go('/pelawaan'),
      );
    }
    final filed = store.filedTenderFor(inv.id);
    final saved = store.draftTenderFor(inv.id);

    return Scaffold(
      appBar:
          BrandAppBar(showBack: true, onBack: () => context.go('/pelawaan')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Row(
            children: [
              Expanded(
                child: Text(inv.title,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.w800)),
              ),
              StatusPill(label: inv.status.label),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(inv.id,
              style: const TextStyle(color: AppColors.grey500, fontSize: 12)),
          const SizedBox(height: AppSpacing.lg),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                children: [
                  DetailRow(label: 'Agensi', value: inv.agency),
                  const Divider(),
                  DetailRow(label: 'Tarikh tutup', value: inv.closingDate),
                  const Divider(),
                  DetailRow(label: 'Lokasi', value: inv.location),
                  const Divider(),
                  DetailRow(
                      label: 'Kuantiti', value: '${inv.quantity} ${inv.unit}'),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          const SectionLabel('Butiran bekalan'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Text(
                inv.description,
                style: const TextStyle(color: AppColors.grey700, height: 1.5),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          const SectionLabel('Dokumen rujukan'),
          const Card(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.picture_as_pdf_outlined),
                  title: Text('Spesifikasi teknikal.pdf'),
                  trailing: Icon(Icons.download_outlined, size: 20),
                ),
                Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.picture_as_pdf_outlined),
                  title: Text('Syarat tawaran.pdf'),
                  trailing: Icon(Icons.download_outlined, size: 20),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          if (filed != null)
            PrimaryButton(
              label: 'Lihat tawaran saya',
              onPressed: () => context.go('/tawaran/rekod?id=${filed.id}'),
            )
          else if (inv.status != InvitationStatus.tutup)
            PrimaryButton(
              label: saved != null ? 'Sambung tawaran' : 'Sediakan tawaran',
              onPressed: () {
                try {
                  store.startDraft(inv.id);
                  context.go('/tawaran/baru/spesifikasi?inv=${inv.id}');
                } on StoreException catch (e) {
                  showToast(context, e.message);
                }
              },
            ),
          const SizedBox(height: AppSpacing.md),
          SecondaryButton(
            label: 'Kembali ke pelawaan',
            onPressed: () => context.go('/pelawaan'),
          ),
        ],
      ),
    );
  }
}
