import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'data/app_store.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';
import 'widgets/feedback.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final store = AppStore.instance;
  store.load(); // the app shows a loading indicator until this completes
  runApp(FindProcurementApp(store: store));
}

/// UiTM Mobile eProcurement: PEMBEKAL (supplier) flow plus admin flow.
class FindProcurementApp extends StatefulWidget {
  final AppStore store;
  const FindProcurementApp({super.key, required this.store});

  @override
  State<FindProcurementApp> createState() => _FindProcurementAppState();
}

class _FindProcurementAppState extends State<FindProcurementApp> {
  late final GoRouter _router = AppRouter.create(widget.store);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'FindProcurement+',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: _router,
      builder: (context, child) {
        return ListenableBuilder(
          listenable: widget.store,
          builder: (context, _) {
            switch (widget.store.loadState) {
              case LoadState.loading:
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              case LoadState.error:
                return Scaffold(
                  body: ErrorState(
                    message: widget.store.errorMessage,
                    onRetry: widget.store.load,
                  ),
                );
              case LoadState.ready:
                return child ?? const SizedBox.shrink();
            }
          },
        );
      },
    );
  }
}
