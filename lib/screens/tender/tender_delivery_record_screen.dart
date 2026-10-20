import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/app_models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/brand_app_bar.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/primary_button.dart';

/// V18 - Rekod penghantaran tawaran (Tender delivery record)
class TenderDeliveryRecordScreen extends StatelessWidget {
  const TenderDeliveryRecordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BrandAppBar(showBack: true),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          const Text('Rekod penghantaran',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
          const SizedBox(height: AppSpacing.xs),
          const Text('INV-CONTOH-001',
              style: TextStyle(color: AppColors.grey500, fontSize: 12)),
          const SizedBox(height: AppSpacing.lg),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: Column(
                children: [
                  DetailRow(label: 'Nama tawaran', value: 'Bekalan kertas A4'),
                  Divider(),
                  DetailRow(label: 'Kuantiti', value: '50 rim'),
                  Divider(),
                  DetailRow(
                      label: 'Jumlah tawaran',
                      value: 'RM2,308.00',
                      emphasize: true),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          const SectionLabel('Status penghantaran'),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: StatusTimeline(
                steps: [
                  TimelineStep(
                    title: 'Tawaran disediakan',
                    subtitle: '14 Okt 2026 · 08:30 pagi',
                    done: true,
                  ),
                  TimelineStep(
                    title: 'Tawaran dihantar',
                    subtitle: '14 Okt 2026 · 09:00 pagi',
                    done: true,
                  ),
                  TimelineStep(
                    title: 'Penilaian',
                    subtitle: 'Dalam proses',
                    done: false,
                  ),
                  TimelineStep(
                    title: 'Keputusan',
                    subtitle: 'Menunggu',
                    done: false,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          SecondaryButton(
            label: 'Kembali ke tawaran',
            onPressed: () => context.go('/tawaran-saya'),
          ),
        ],
      ),
    );
  }
}
