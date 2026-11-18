import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/app_store.dart';
import '../../theme/app_theme.dart';
import '../../utils/format.dart';
import '../../utils/validators.dart';
import '../../widgets/brand_app_bar.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/feedback.dart';
import '../../widgets/primary_button.dart';

/// V12 - Penyediaan invois (Create invoice)
class InvoiceCreateScreen extends StatefulWidget {
  /// Order to bill (from `?order=`); when null the user picks one.
  final String? orderId;
  const InvoiceCreateScreen({super.key, this.orderId});

  @override
  State<InvoiceCreateScreen> createState() => _InvoiceCreateScreenState();
}

class _InvoiceCreateScreenState extends State<InvoiceCreateScreen> {
  final _store = AppStore.instance;
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _noCtrl;
  late final TextEditingController _dateCtrl;
  final _amountCtrl = TextEditingController();
  String? _orderId;
  bool _confirm = false;
  bool _busy = false;
  String? _confirmError;

  @override
  void initState() {
    super.initState();
    _noCtrl = TextEditingController(text: _store.nextInvoiceNo());
    _dateCtrl = TextEditingController(text: Fmt.isoDay(DateTime.now()));
    final ready = _store.ordersReadyForInvoice;
    final wanted = widget.orderId;
    if (wanted != null && ready.any((o) => o.id == wanted)) {
      _orderId = wanted;
    } else if (ready.length == 1) {
      _orderId = ready.first.id;
    }
    _fillAmount();
  }

  void _fillAmount() {
    final o = _orderId == null ? null : _store.orderById(_orderId!);
    _amountCtrl.text = o == null ? '' : o.amount.toStringAsFixed(2);
  }

  @override
  void dispose() {
    _noCtrl.dispose();
    _dateCtrl.dispose();
    _amountCtrl.dispose();
    super.dispose();
  }

  Future<void> _save({required bool draft}) async {
    setState(() => _confirmError = null);
    if (_orderId == null) {
      showToast(context, 'Sila pilih pesanan');
      return;
    }
    if (!_formKey.currentState!.validate()) return;
    if (!draft && !_confirm) {
      setState(() => _confirmError = 'Sila sahkan maklumat invois');
      return;
    }
    setState(() => _busy = true);
    final inv = await runAction(
      context,
      () => _store.createInvoice(
        orderId: _orderId!,
        invoiceNo: _noCtrl.text,
        amount: Validators.parseAmount(_amountCtrl.text)!,
        asDraft: draft,
      ),
    );
    if (!mounted) return;
    setState(() => _busy = false);
    if (inv == null) return;
    if (draft) {
      showToast(context, 'Draf disimpan');
      context.go('/invois/${inv.id}/status');
    } else {
      context.go('/invois/berjaya');
    }
  }

  @override
  Widget build(BuildContext context) {
    final ready = _store.ordersReadyForInvoice;
    final order = _orderId == null ? null : _store.orderById(_orderId!);
    return Scaffold(
      appBar: BrandAppBar(showBack: true, onBack: () => context.go('/invois')),
      body: ready.isEmpty
          ? const EmptyState(
              'Tiada pesanan yang diterima untuk dibuat invois. '
              'Terima pesanan terlebih dahulu.',
              icon: Icons.receipt_long_outlined)
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                children: [
                  const Text('Sediakan invois',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    order == null
                        ? 'Pilih pesanan untuk dibuat invois'
                        : 'Berdasarkan pesanan ${order.poNumber}',
                    style:
                        const TextStyle(color: AppColors.grey500, fontSize: 13),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  LabeledField(
                    label: 'Pesanan',
                    child: DropdownButtonFormField<String>(
                      initialValue: _orderId,
                      hint: const Text('Pilih pesanan'),
                      isExpanded: true,
                      items: ready
                          .map((o) => DropdownMenuItem(
                                value: o.id,
                                child: Text('${o.poNumber} · ${o.title}',
                                    overflow: TextOverflow.ellipsis),
                              ))
                          .toList(),
                      validator: (v) => v == null ? 'Sila pilih pesanan' : null,
                      onChanged: (v) => setState(() {
                        _orderId = v;
                        _fillAmount();
                      }),
                    ),
                  ),
                  if (order != null)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        child: Column(
                          children: [
                            DetailRow(label: 'Pesanan', value: order.poNumber),
                            const Divider(),
                            DetailRow(label: 'Item', value: order.title),
                            const Divider(),
                            DetailRow(
                                label: 'Kuantiti',
                                value: '${order.quantity} unit'),
                            const Divider(),
                            DetailRow(
                                label: 'Jumlah pesanan',
                                value: Fmt.rm(order.amount)),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: AppSpacing.lg),
                  LabeledField(
                    label: 'No. invois',
                    child: TextFormField(
                      controller: _noCtrl,
                      validator: _store.invoiceNoError,
                    ),
                  ),
                  LabeledField(
                    label: 'Tarikh invois',
                    child: TextField(
                      controller: _dateCtrl,
                      readOnly: true,
                      decoration: const InputDecoration(
                        suffixIcon:
                            Icon(Icons.calendar_today_outlined, size: 18),
                      ),
                    ),
                  ),
                  LabeledField(
                    label: 'Jumlah invois (RM)',
                    child: TextFormField(
                      controller: _amountCtrl,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      validator: (v) {
                        final base = Validators.amount(v, 'Jumlah invois');
                        if (base != null) return base;
                        final o = order;
                        final n = Validators.parseAmount(v)!;
                        if (o != null && n > o.amount) {
                          return 'Jumlah melebihi jumlah pesanan (${Fmt.rm(o.amount)})';
                        }
                        return null;
                      },
                    ),
                  ),
                  CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                    value: _confirm,
                    onChanged: (v) => setState(() {
                      _confirm = v ?? false;
                      _confirmError = null;
                    }),
                    title: const Text(
                      'Saya mengesahkan maklumat invois ini betul dan tepat.',
                      style: TextStyle(fontSize: 12, color: AppColors.grey700),
                    ),
                  ),
                  if (_confirmError != null)
                    Text(_confirmError!,
                        style: const TextStyle(
                            color: AppColors.danger, fontSize: 12)),
                  const SizedBox(height: AppSpacing.md),
                  PrimaryButton(
                    label: 'Hantar invois',
                    onPressed: _busy ? null : () => _save(draft: false),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  SecondaryButton(
                    label: 'Simpan draf',
                    onPressed: _busy ? null : () => _save(draft: true),
                  ),
                ],
              ),
            ),
    );
  }
}
