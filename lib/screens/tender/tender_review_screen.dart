import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/app_store.dart';
import '../../theme/app_theme.dart';
import '../../utils/format.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/feedback.dart';
import '../../widgets/primary_button.dart';
import 'tender_step_scaffold.dart';

/// V07 - Tawaran: Semak & hantar (step 4 of 4)
class TenderReviewScreen extends StatefulWidget {
  const TenderReviewScreen({super.key});

  @override
  State<TenderReviewScreen> createState() => _TenderReviewScreenState();
}

class _TenderReviewScreenState extends State<TenderReviewScreen> {
  final _store = AppStore.instance;
  bool _agreed = false;
  bool _busy = false;

  Future<void> _submit() async {
    final problem = _store.validateDraft();
    if (problem != null) {
      showToast(context, problem);
      return;
    }
    setState(() => _busy = true);
    final tender = await runAction(context, _store.submitTender);
    if (!mounted) return;
    setState(() => _busy = false);
    if (tender != null) context.go('/tawaran/berjaya');
  }

  Future<void> _saveDraft() async {
    final t = await runAction(context, _store.saveDraftTender);
    if (t != null && mounted) showToast(context, 'Draf disimpan');
  }

  @override
  Widget build(BuildContext context) {
    final draft = _store.draft;
    final inv = _store.invitationById(draft.invitationId);
    if (inv == null) {
      return NotFoundScaffold(
        message: 'Pelawaan tidak dijumpai',
        backLabel: 'Kembali ke pelawaan',
        onBack: () => context.go('/pelawaan'),
      );
    }
    final specText = draft.spec.isEmpty ? '-' : draft.spec;
    return TenderStepScaffold(
      stepIndex: 3,
      title: 'Semak & hantar',
      onBack: () => context.go('/tawaran/baru/dokumen'),
      content: [
        const SectionLabel('Maklumat tawaran'),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              children: [
                DetailRow(label: 'Nama pelawaan', value: inv.title),
                const Divider(),
                DetailRow(label: 'No. pelawaan', value: inv.id),
                const Divider(),
                DetailRow(label: 'Tarikh tutup', value: inv.closingDay),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        const SectionLabel('Spesifikasi'),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              children: [
                DetailRow(label: 'Item', value: specText),
                const Divider(),
                DetailRow(
                    label: 'Kuantiti',
                    value: '${draft.quantity ?? 0} ${inv.unit}'),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        const SectionLabel('Harga tawaran'),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              children: [
                DetailRow(
                    label: 'Harga seunit', value: Fmt.rm(draft.unitPrice ?? 0)),
                const Divider(),
                DetailRow(
                    label: 'Jumlah',
                    value: Fmt.rm(draft.total),
                    emphasize: true),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        const SectionLabel('Dokumen'),
        if (draft.documents.isEmpty)
          const Card(
            child: ListTile(
              leading: Icon(Icons.warning_amber_outlined),
              title: Text('Tiada dokumen dimuat naik'),
            ),
          )
        else
          Card(
            child: Column(
              children: [
                for (var i = 0; i < draft.documents.length; i++) ...[
                  if (i > 0) const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.description_outlined),
                    title: Text(draft.documents[i]),
                  ),
                ],
              ],
            ),
          ),
        const SizedBox(height: AppSpacing.lg),
        CheckboxListTile(
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
          value: _agreed,
          onChanged: (v) => setState(() => _agreed = v ?? false),
          title: const Text(
            'Saya mengesahkan maklumat tawaran ini betul. '
            'Tawaran yang dihantar tidak boleh dipinda.',
            style: TextStyle(fontSize: 12, color: AppColors.grey700),
          ),
        ),
      ],
      actions: [
        PrimaryButton(
          label: 'Hantar tawaran',
          onPressed: (_agreed && !_busy) ? _submit : null,
        ),
        const SizedBox(height: AppSpacing.sm),
        SecondaryButton(
          label: 'Simpan draf',
          onPressed: _busy ? null : _saveDraft,
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
