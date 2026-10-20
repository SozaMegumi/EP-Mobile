import 'package:flutter/material.dart';

import 'router/app_router.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const FindProcurementApp());
}

/// UiTM Mobile eProcurement — PEMBEKAL (Supplier) flow.
class FindProcurementApp extends StatelessWidget {
  const FindProcurementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'FindProcurement+',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: AppRouter.router,
    );
  }
}
