import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/app_store.dart';
import '../theme/app_theme.dart';

/// The "FindProcurement+" top brand bar seen on most screens.
class BrandAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showBack;
  final VoidCallback? onBack;
  const BrandAppBar({super.key, this.showBack = false, this.onBack});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final store = AppStore.instance;
    return AppBar(
      automaticallyImplyLeading: false,
      leading: showBack
          ? IconButton(
              icon: const Icon(Icons.arrow_back, size: 20),
              onPressed: onBack ??
                  () {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.go(store.isAdmin ? '/admin' : '/home');
                    }
                  },
            )
          : null,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.black,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(Icons.inventory_2_outlined,
                size: 14, color: AppColors.white),
          ),
          const SizedBox(width: AppSpacing.sm),
          Flexible(
            child: Text(
              store.isAdmin ? 'FindProcurement+ Admin' : 'FindProcurement+',
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      actions: [
        if (!store.isAdmin)
          IconButton(
            tooltip: 'Cari pelawaan',
            icon: const Icon(Icons.search, size: 20, color: AppColors.grey700),
            onPressed: () => context.go('/pelawaan'),
          ),
        ListenableBuilder(
          listenable: store,
          builder: (context, _) {
            final unread = store.unreadCount(store.audience);
            return IconButton(
              tooltip: 'Notifikasi',
              icon: Badge(
                isLabelVisible: unread > 0,
                label: Text('$unread'),
                child: const Icon(Icons.notifications_none,
                    size: 20, color: AppColors.grey700),
              ),
              onPressed: () => context.push('/notifikasi'),
            );
          },
        ),
        if (store.isAdmin)
          IconButton(
            tooltip: 'Log keluar',
            icon: const Icon(Icons.logout, size: 20, color: AppColors.grey700),
            onPressed: () async {
              await store.logout();
              if (context.mounted) context.go('/login');
            },
          ),
        const SizedBox(width: AppSpacing.sm),
      ],
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Divider(height: 1),
      ),
    );
  }
}
