import 'package:flutter/material.dart';
import '../data/dummy_data.dart';
import '../theme/app_theme.dart';
import '../widgets/brand_app_bar.dart';

/// V14 - Notifikasi (Notifications)
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const items = DummyData.notifications;
    return Scaffold(
      appBar: const BrandAppBar(showBack: true),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          const Text('Notifikasi',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
          const SizedBox(height: AppSpacing.xs),
          const Text('Aktiviti terkini pada akaun anda',
              style: TextStyle(color: AppColors.grey500, fontSize: 13)),
          const SizedBox(height: AppSpacing.lg),
          ...items.map(
            (n) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.only(top: 6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              n.unread ? AppColors.black : AppColors.grey300,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(n.title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 14)),
                            const SizedBox(height: 2),
                            Text(n.body,
                                style: const TextStyle(
                                    color: AppColors.grey700, fontSize: 13)),
                            const SizedBox(height: AppSpacing.xs),
                            Text(n.time,
                                style: const TextStyle(
                                    color: AppColors.grey500, fontSize: 11)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
