import 'package:flutter/material.dart';
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
    return AppBar(
      automaticallyImplyLeading: false,
      leading: showBack
          ? IconButton(
              icon: const Icon(Icons.arrow_back, size: 20),
              onPressed: onBack ?? () => Navigator.of(context).maybePop(),
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
          const Text('FindProcurement+'),
        ],
      ),
      actions: const [
        Icon(Icons.search, size: 20, color: AppColors.grey700),
        SizedBox(width: AppSpacing.lg),
        Icon(Icons.notifications_none, size: 20, color: AppColors.grey700),
        SizedBox(width: AppSpacing.lg),
      ],
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Divider(height: 1),
      ),
    );
  }
}
