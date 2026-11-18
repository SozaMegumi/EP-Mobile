import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/app_store.dart';
import '../../theme/app_theme.dart';
import '../../utils/format.dart';
import '../../utils/validators.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/feedback.dart';
import '../../widgets/primary_button.dart';
import 'tender_step_scaffold.dart';

/// V05 - Tawaran: Harga (step 2 of 4)
class TenderPriceScreen extends StatefulWidget {
  const TenderPriceScreen({super.key});

  @override
  State<TenderPriceScreen> createState() => _TenderPriceScreenState();
}

class _TenderPriceScreenState extends State<TenderPriceScreen> {
  final _store = AppStore.instance;
  final _formKey = GlobalKey<FormState>();
  late final _unitCtrl = TextEditingController(
    text: _store.draft.unitPrice == null
        ? ''
        : _store.draft.unitPrice!.toStringAsFixed(2),
  );

  int get _qty => _store.draft.quantity ?? 0;
  double get _unit => Validators.parseAmount(_unitCtrl.text) ?? 0;
  double get _total => _unit * _qty;
  String get _unitLabel =>
      _store.invitationById(_store.draft.invitationId)?.unit ?? 'unit';

  @override
  void initState() {
    super.initState();
    _unitCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _unitCtrl.dispose();
    super.dispose();
  }

  void _keep() {
    final v = Validators.parseAmount(_unitCtrl.text);
    if (v != null && v > 0) {
      _store.updateDraft(unitPrice: v);
    } else if (_unitCtrl.text.trim().isEmpty) {
      _store.updateDraft(clearPrice: true);
    }
  }

  void _next() {
    if (!_formKey.currentState!.validate()) return;
    _keep();
    context.go('/tawaran/baru/dokumen');
  }

  Future<void> _saveDraft() async {
    _keep();
    final t = await runAction(context, _store.saveDraftTender);
    if (t != null && mounted) showToast(context, 'Draf disimpan');
  }

  @override
  Widget build(BuildContext context) {
    return TenderStepScaffold(
      stepIndex: 1,
      title: 'Tawaran harga',
      onBack: () {
        _keep();
        context.go('/tawaran/baru/spesifikasi');
      },
      content: [
        Form(
          key: _formKey,
          child: LabeledField(
            label: 'Harga seunit (RM)',
            child: TextFormField(
              controller: _unitCtrl,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              validator: (v) => Validators.amount(v, 'Harga seunit'),
            ),
          ),
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              children: [
                const SectionLabel('Ringkasan harga'),
                DetailRow(label: 'Kuantiti', value: '$_qty $_unitLabel'),
                const Divider(),
                DetailRow(label: 'Harga seunit', value: Fmt.rm(_unit)),
                const Divider(),
                DetailRow(
                  label: 'Jumlah tawaran',
                  value: Fmt.rm(_total),
                  emphasize: true,
                ),
              ],
            ),
          ),
        ),
      ],
      actions: [
        PrimaryButton(
          label: 'Seterusnya: Dokumen',
          onPressed: _next,
        ),
        const SizedBox(height: AppSpacing.sm),
        SecondaryButton(
          label: 'Simpan draf',
          onPressed: _saveDraft,
        ),
      ],
    );
  }
}
