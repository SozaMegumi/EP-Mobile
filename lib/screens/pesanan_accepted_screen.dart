import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/app_models.dart';
import '../theme/app_theme.dart';
import '../widgets/brand_app_bar.dart';
import '../widgets/common_widgets.dart';
import '../widgets/primary_button.dart';

/// V19 - Pesanan diterima pembekal (Order accepted by supplier)
class PesananAcceptedScreen extends StatelessWidget {
  final String orderId;

  const PesananAcceptedScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BrandAppBar(showBack: true),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          const SizedBox(height: AppSpacing.lg),
          Center(
            child: Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.black, width: 2),
              ),
              child: const Icon(Icons.check, size: 36),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          const Center(
            child: Text('Pesanan diterima',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
          ),
          const SizedBox(height: AppSpacing.xs),
          Center(
            child: Text(orderId,
                style: const TextStyle(color: AppColors.grey500, fontSize: 12)),
          ),
          const SizedBox(height: AppSpacing.xl),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: Column(
                children: [
                  DetailRow(label: 'Item', value: 'Toner pencetak'),
                  Divider(),
                  DetailRow(label: 'Kuantiti', value: '6 unit'),
                  Divider(),
                  DetailRow(
                      label: 'Jumlah pesanan',
                      value: 'RM1,800.00',
                      emphasize: true),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          const SectionLabel('Langkah seterusnya'),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: StatusTimeline(
                steps: [
                  TimelineStep(
                    title: 'Pesanan diterima',
                    subtitle: 'Selesai',
                    done: true,
                  ),
                  TimelineStep(
                    title: 'Penghantaran barang',
                    subtitle: 'Sediakan penghantaran',
                    done: false,
                  ),
                  TimelineStep(
                    title: 'Penyediaan invois',
                    subtitle: 'Selepas penghantaran',
                    done: false,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          PrimaryButton(
            label: 'Sediakan invois',
            onPressed: () => context.go('/invois/baru'),
          ),
          const SizedBox(height: AppSpacing.md),
          SecondaryButton(
            label: 'Kembali ke utama',
            onPressed: () => context.go('/home'),
          ),
        ],
      ),
    );
  }
}
