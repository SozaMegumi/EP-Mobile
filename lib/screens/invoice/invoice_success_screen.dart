import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/app_store.dart';
import '../../widgets/brand_app_bar.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/primary_button.dart';

/// V20 - Invois berjaya dihantar (Invoice submitted success)
class InvoiceSuccessScreen extends StatelessWidget {
  const InvoiceSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = AppStore.instance;
    final inv = store.invoiceById(store.lastInvoiceId);
    return Scaffold(
      appBar: const BrandAppBar(),
      body: SuccessView(
        title: 'Invois dihantar',
        subtitle: '${inv?.invoiceNo ?? ''}\nInvois menunggu semakan kewangan',
        actions: [
          PrimaryButton(
            label: 'Lihat status',
            onPressed: () => context
                .go(inv == null ? '/invois' : '/invois/${inv.id}/status'),
          ),
          const SizedBox(height: 12),
          SecondaryButton(
            label: 'Kembali ke utama',
            onPressed: () => context.go('/home'),
          ),
        ],
      ),
    );
  }
}
