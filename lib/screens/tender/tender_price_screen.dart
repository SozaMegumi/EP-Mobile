import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/primary_button.dart';
import 'tender_step_scaffold.dart';

/// V05 - Tawaran: Harga (step 2 of 4)
class TenderPriceScreen extends StatefulWidget {
  const TenderPriceScreen({super.key});

  @override
  State<TenderPriceScreen> createState() => _TenderPriceScreenState();
}

class _TenderPriceScreenState extends State<TenderPriceScreen> {
  final _unitCtrl = TextEditingController(text: '23.00');
  static const int _qty = 50;

  double get _unit => double.tryParse(_unitCtrl.text) ?? 0;
  double get _total => _unit * _qty;

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

  String _rm(double v) => 'RM${v.toStringAsFixed(2)}';

  @override
  Widget build(BuildContext context) {
    return TenderStepScaffold(
      stepIndex: 1,
      title: 'Tawaran harga',
      onBack: () => context.go('/tawaran/baru/spesifikasi'),
      content: [
        LabeledField(
          label: 'Harga seunit (RM)',
          child: TextField(
            controller: _unitCtrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              children: [
                const SectionLabel('Ringkasan harga'),
                const DetailRow(label: 'Kuantiti', value: '$_qty rim'),
                const Divider(),
                DetailRow(label: 'Harga seunit', value: _rm(_unit)),
                const Divider(),
                DetailRow(
                  label: 'Jumlah tawaran',
                  value: _rm(_total),
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
          onPressed: () => context.go('/tawaran/baru/dokumen'),
        ),
        const SizedBox(height: AppSpacing.sm),
        SecondaryButton(
          label: 'Simpan draf',
          onPressed: () => ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Draf disimpan'))),
        ),
      ],
    );
  }
}
