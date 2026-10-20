import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';
import '../../widgets/brand_app_bar.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/primary_button.dart';

/// V12 - Penyediaan invois (Create invoice)
class InvoiceCreateScreen extends StatefulWidget {
  const InvoiceCreateScreen({super.key});

  @override
  State<InvoiceCreateScreen> createState() => _InvoiceCreateScreenState();
}

class _InvoiceCreateScreenState extends State<InvoiceCreateScreen> {
  final _noCtrl = TextEditingController(text: 'INV-CONTOH-018');
  final _dateCtrl = TextEditingController(text: '2026-10-14');
  final _amountCtrl = TextEditingController(text: '1800.00');
  bool _confirm = false;

  @override
  void dispose() {
    _noCtrl.dispose();
    _dateCtrl.dispose();
    _amountCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BrandAppBar(showBack: true, onBack: () => context.go('/invois')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          const Text('Sediakan invois',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
          const SizedBox(height: AppSpacing.xs),
          const Text('Berdasarkan pesanan PO-CONTOH-018',
              style: TextStyle(color: AppColors.grey500, fontSize: 13)),
          const SizedBox(height: AppSpacing.lg),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: Column(
                children: [
                  DetailRow(label: 'Pesanan', value: 'PO-CONTOH-018'),
                  Divider(),
                  DetailRow(label: 'Item', value: 'Toner pencetak'),
                  Divider(),
                  DetailRow(label: 'Kuantiti', value: '6 unit'),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          LabeledField(
            label: 'No. invois',
            child: TextField(controller: _noCtrl),
          ),
          LabeledField(
            label: 'Tarikh invois',
            child: TextField(
              controller: _dateCtrl,
              readOnly: true,
              decoration: const InputDecoration(
                suffixIcon: Icon(Icons.calendar_today_outlined, size: 18),
              ),
            ),
          ),
          LabeledField(
            label: 'Jumlah invois (RM)',
            child: TextField(
              controller: _amountCtrl,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
          ),
          CheckboxListTile(
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
            value: _confirm,
            onChanged: (v) => setState(() => _confirm = v ?? false),
            title: const Text(
              'Saya mengesahkan maklumat invois ini betul dan tepat.',
              style: TextStyle(fontSize: 12, color: AppColors.grey700),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          PrimaryButton(
            label: 'Hantar invois',
            onPressed: _confirm ? () => context.go('/invois/berjaya') : null,
          ),
          const SizedBox(height: AppSpacing.sm),
          SecondaryButton(
            label: 'Simpan draf',
            onPressed: () => ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text('Draf disimpan'))),
          ),
        ],
      ),
    );
  }
}
