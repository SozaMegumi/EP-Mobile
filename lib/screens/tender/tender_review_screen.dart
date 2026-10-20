import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/primary_button.dart';
import 'tender_step_scaffold.dart';

/// V07 - Tawaran: Semak & hantar (step 4 of 4)
class TenderReviewScreen extends StatefulWidget {
  const TenderReviewScreen({super.key});

  @override
  State<TenderReviewScreen> createState() => _TenderReviewScreenState();
}

class _TenderReviewScreenState extends State<TenderReviewScreen> {
  bool _agreed = false;

  @override
  Widget build(BuildContext context) {
    return TenderStepScaffold(
      stepIndex: 3,
      title: 'Semak & hantar',
      onBack: () => context.go('/tawaran/baru/dokumen'),
      content: [
        const SectionLabel('Maklumat tawaran'),
        const Card(
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.lg),
            child: Column(
              children: [
                DetailRow(label: 'Nama pelawaan', value: 'Bekalan kertas A4'),
                Divider(),
                DetailRow(label: 'No. pelawaan', value: 'INV-CONTOH-001'),
                Divider(),
                DetailRow(label: 'Tarikh tutup', value: '18 Okt 2026'),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        const SectionLabel('Spesifikasi'),
        const Card(
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.lg),
            child: Column(
              children: [
                DetailRow(label: 'Item', value: 'Kertas A4 80gsm · putih'),
                Divider(),
                DetailRow(label: 'Kuantiti', value: '50 rim'),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        const SectionLabel('Harga tawaran'),
        const Card(
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.lg),
            child: Column(
              children: [
                DetailRow(label: 'Harga seunit', value: 'RM23.00'),
                Divider(),
                DetailRow(label: 'Jumlah', value: 'RM1,150.00'),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        const SectionLabel('Dokumen'),
        const Card(
          child: ListTile(
            leading: Icon(Icons.description_outlined),
            title: Text('Sijil_pendaftaran.pdf'),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        CheckboxListTile(
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
          value: _agreed,
          onChanged: (v) => setState(() => _agreed = v ?? false),
          title: const Text(
            'Saya mengisahkan maklumat tawaran ini betul. '
            'Tawaran yang dihantar tidak boleh dipinda.',
            style: TextStyle(fontSize: 12, color: AppColors.grey700),
          ),
        ),
      ],
      actions: [
        PrimaryButton(
          label: 'Hantar tawaran',
          onPressed: _agreed ? () => context.go('/tawaran/berjaya') : null,
        ),
        const SizedBox(height: AppSpacing.sm),
        SecondaryButton(
          label: 'Kembali semula',
          onPressed: () => context.go('/tawaran/baru/dokumen'),
        ),
      ],
    );
  }
}
