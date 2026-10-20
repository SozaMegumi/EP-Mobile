import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/dummy_data.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/primary_button.dart';
import 'tender_step_scaffold.dart';

/// V04 - Tawaran: Spesifikasi teknikal (step 1 of 4)
class TenderSpecScreen extends StatefulWidget {
  const TenderSpecScreen({super.key});

  @override
  State<TenderSpecScreen> createState() => _TenderSpecScreenState();
}

class _TenderSpecScreenState extends State<TenderSpecScreen> {
  String _spec = DummyData.specifications.first;
  final _qtyCtrl = TextEditingController(text: '50');
  final _dateCtrl = TextEditingController(text: '18 Okt 2026');

  @override
  void dispose() {
    _qtyCtrl.dispose();
    _dateCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TenderStepScaffold(
      stepIndex: 0,
      title: 'Spesifikasi teknikal',
      onBack: () => context.go('/pelawaan'),
      content: [
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
          label: 'Kuantiti (rim)',
          child: TextField(
            controller: _qtyCtrl,
            keyboardType: TextInputType.number,
          ),
        ),
        LabeledField(
          label: 'Spesifikasi',
          child: DropdownButtonFormField<String>(
            initialValue: _spec,
            items: DummyData.specifications
                .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                .toList(),
            onChanged: (v) => setState(() => _spec = v ?? _spec),
          ),
        ),
        LabeledField(
          label: 'Tempat serahan hasil',
          child: TextField(
            controller: TextEditingController(text: 'Stor pusat, UiTM Shah Alam'),
            readOnly: true,
          ),
        ),
      ],
      actions: [
        PrimaryButton(
          label: 'Seterusnya: Harga',
          onPressed: () => context.go('/tawaran/baru/harga'),
        ),
        const SizedBox(height: AppSpacing.sm),
        SecondaryButton(
          label: 'Simpan draf',
          onPressed: () => _snack(context),
        ),
      ],
    );
  }

  void _snack(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Draf disimpan')),
    );
  }
}
