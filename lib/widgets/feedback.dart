import 'package:flutter/material.dart';

import '../data/app_store.dart';
import '../theme/app_theme.dart';
import 'primary_button.dart';

/// Shows a short message at the bottom of the screen.
void showToast(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}

/// Runs a store action and reports a [StoreException] as a toast.
/// Returns the result, or null when it failed.
Future<T?> runAction<T>(BuildContext context, Future<T> Function() action) async {
  try {
    return await action();
  } on StoreException catch (e) {
    if (context.mounted) showToast(context, e.message);
  } catch (_) {
    if (context.mounted) {
      showToast(context, 'Ralat tidak dijangka. Sila cuba lagi.');
    }
  }
  return null;
}

/// Like [runAction] for actions without a result. Returns true on success.
Future<bool> runVoid(BuildContext context, Future<void> Function() action) async {
  final r = await runAction<bool>(context, () async {
    await action();
    return true;
  });
  return r ?? false;
}

/// Asks the user to confirm. Returns true when confirmed.
Future<bool> confirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  String confirmLabel = 'Ya',
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: const Text('Batal'),
        ),
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(true),
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
  return result ?? false;
}

/// Centered empty-list message.
class EmptyState extends StatelessWidget {
  final String message;
  final IconData icon;
  const EmptyState(this.message,
      {super.key, this.icon = Icons.inbox_outlined});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 40, color: AppColors.grey300),
            const SizedBox(height: AppSpacing.md),
            Text(message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.grey500)),
          ],
        ),
      ),
    );
  }
}

/// Centered error message with a retry action.
class ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const ErrorState({super.key, required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 40, color: AppColors.grey500),
            const SizedBox(height: AppSpacing.md),
            Text(message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.grey700)),
            const SizedBox(height: AppSpacing.lg),
            PrimaryButton(label: 'Cuba lagi', onPressed: onRetry),
          ],
        ),
      ),
    );
  }
}

/// Shown when an id in the URL matches nothing in the store.
class NotFoundScaffold extends StatelessWidget {
  final String message;
  final String backLabel;
  final VoidCallback onBack;
  const NotFoundScaffold({
    super.key,
    required this.message,
    required this.backLabel,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FindProcurement+')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(message, textAlign: TextAlign.center),
              const SizedBox(height: AppSpacing.lg),
              SecondaryButton(label: backLabel, onPressed: onBack),
            ],
          ),
        ),
      ),
    );
  }
}
