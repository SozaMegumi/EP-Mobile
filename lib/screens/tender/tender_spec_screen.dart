import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/app_store.dart';
import '../../theme/app_theme.dart';
import '../../utils/validators.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/feedback.dart';
import '../../widgets/primary_button.dart';
import 'tender_step_scaffold.dart';

/// V04 - Tawaran: Spesifikasi teknikal (step 1 of 4)
class TenderSpecScreen extends StatefulWidget {
  const TenderSpecScreen({super.key});

  @override
  State<TenderSpecScreen> createState() => _TenderSpecScreenState();
}

class _TenderSpecScreenState extends State<TenderSpecScreen> {
  final _store = AppStore.instance;
  final _formKey = GlobalKey<FormState>();
  late final _inv = _store.invitationById(_store.draft.invitationId)!;
  late final _qtyCtrl =
      TextEditingController(text: '${_store.draft.quantity ?? _inv.quantity}');
  late final _dateCtrl = TextEditingController(text: _inv.closingDay);
  late final _placeCtrl = TextEditingController(text: _inv.deliveryPlace);
  late String _spec = _store.draft.spec.isNotEmpty &&
          _inv.specifications.contains(_store.draft.spec)
      ? _store.draft.spec
      : _inv.specifications.first;

  @override
  void dispose() {
    _qtyCtrl.dispose();
    _dateCtrl.dispose();
    _placeCtrl.dispose();
    super.dispose();
  }

  /// Copies the form into the shared wizard state (no validation).
  void _store_() {
    _store.updateDraft(
      spec: _spec == _inv.specifications.first ? '' : _spec,
      quantity: int.tryParse(_qtyCtrl.text.trim()),
    );
  }

  void _next() {
    if (!_formKey.currentState!.validate()) return;
    _store_();
    context.go('/tawaran/baru/harga');
  }

  Future<void> _saveDraft() async {
    _store_();
    final t = await runAction(context, _store.saveDraftTender);
    if (t != null && mounted) showToast(context, 'Draf disimpan');
  }

  @override
  Widget build(BuildContext context) {
    return TenderStepScaffold(
      stepIndex: 0,
      title: 'Spesifikasi teknikal',
      onBack: () {
        _store_();
        context.go('/pelawaan/${_inv.id}');
      },
      content: [
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_inv.title,
                  style:
                      const TextStyle(color: AppColors.grey500, fontSize: 13)),
              const SizedBox(height: AppSpacing.md),
              LabeledField(
                label: 'Tarikh tutup tawaran',
                child: TextField(
                  controller: _dateCtrl,
                  readOnly: true,
                  decoration: const InputDecoration(
                    suffixIcon: Icon(Icons.calendar_today_outlined, size: 18),
                  ),
                ),
              ),
              LabeledField(
                label: 'Kuantiti (${_inv.unit})',
                child: TextFormField(
                  controller: _qtyCtrl,
                  keyboardType: TextInputType.number,
                  validator: Validators.quantity,
                ),
              ),
              LabeledField(
                label: 'Spesifikasi',
                child: DropdownButtonFormField<String>(
                  initialValue: _spec,
                  isExpanded: true,
                  items: _inv.specifications
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  validator: (v) =>
                      (v == null || v == _inv.specifications.first)
                          ? 'Sila pilih spesifikasi'
                          : null,
                  onChanged: (v) => setState(() => _spec = v ?? _spec),
                ),
              ),
              LabeledField(
                label: 'Tempat serahan hasil',
                child: TextField(controller: _placeCtrl, readOnly: true),
              ),
            ],
          ),
        ),
      ],
      actions: [
        PrimaryButton(
          label: 'Seterusnya: Harga',
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
