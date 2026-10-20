import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/brand_app_bar.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/primary_button.dart';

/// V17 - Tawaran berjaya dihantar (Tender submitted success)
class TenderSuccessScreen extends StatelessWidget {
  const TenderSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BrandAppBar(),
      body: SuccessView(
        title: 'Tawaran dihantar',
        subtitle: 'INV-CONTOH-001\n14 Okt 2026 · Tawaran memenuhi penilaian',
        actions: [
          PrimaryButton(
            label: 'Lihat maklumat',
            onPressed: () => context.go('/tawaran/rekod'),
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
