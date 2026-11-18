import 'package:flutter/material.dart';

import '../data/app_store.dart';
import '../models/app_models.dart';
import '../theme/app_theme.dart';
import '../widgets/brand_app_bar.dart';
import '../widgets/feedback.dart';

/// V14 - Notifikasi (Notifications)
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  /// Ids that were unread when the screen opened, so the dot stays visible
  /// during this visit even though everything is marked read.
  late final Set<String> _unreadOnOpen;
  late final Audience _audience;

  @override
  void initState() {
    super.initState();
    final store = AppStore.instance;
    _audience = store.audience;
    _unreadOnOpen = {
      for (final n in store.notificationsFor(_audience))
        if (n.unread) n.id,
    };
    WidgetsBinding.instance.addPostFrameCallback((_) {
      store.markAllRead(_audience).catchError((Object _) {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final store = AppStore.instance;
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final items = store.notificationsFor(_audience);
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
              if (items.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: AppSpacing.xxl),
                  child: EmptyState('Tiada notifikasi',
                      icon: Icons.notifications_none),
                ),
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
                              color: (n.unread || _unreadOnOpen.contains(n.id))
                                  ? AppColors.black
                                  : AppColors.grey300,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(n.title,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14)),
                                const SizedBox(height: 2),
                                Text(n.body,
                                    style: const TextStyle(
                                        color: AppColors.grey700,
                                        fontSize: 13)),
                                const SizedBox(height: AppSpacing.xs),
                                Text(store.timeLabel(n),
                                    style: const TextStyle(
                                        color: AppColors.grey500,
                                        fontSize: 11)),
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
      },
    );
  }
}
