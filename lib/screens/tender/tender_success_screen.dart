import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/app_store.dart';
import '../../widgets/brand_app_bar.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/primary_button.dart';

/// V17 - Tawaran berjaya dihantar (Tender submitted success)
class TenderSuccessScreen extends StatelessWidget {
  const TenderSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = AppStore.instance;
    final t = store.tenderById(store.lastTenderId);
    return Scaffold(
      appBar: const BrandAppBar(),
      body: SuccessView(
        title: 'Tawaran dihantar',
        subtitle: t == null
            ? 'Tawaran memenuhi penilaian'
            : '${t.id}\n${t.submittedDate} · Tawaran memenuhi penilaian',
        actions: [
          PrimaryButton(
            label: 'Lihat maklumat',
            onPressed: () => context
                .go(t == null ? '/tawaran-saya' : '/tawaran/rekod?id=${t.id}'),
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
