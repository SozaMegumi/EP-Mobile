import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/brand_app_bar.dart';
import '../../widgets/common_widgets.dart';

/// Shared scaffold for the 4-step tender creation wizard.
/// Keeps the step header + title consistent across V04-V07.
class TenderStepScaffold extends StatelessWidget {
  final int stepIndex; // 0..3
  final String title;
  final List<Widget> content;
  final List<Widget> actions;
  final VoidCallback? onBack;

  static const steps = ['Spesifikasi', 'Harga', 'Dokumen', 'Semak'];

  const TenderStepScaffold({
    super.key,
    required this.stepIndex,
    required this.title,
    required this.content,
    required this.actions,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BrandAppBar(showBack: true, onBack: onBack),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: StepHeader(steps: steps, currentIndex: stepIndex),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w800)),
                const SizedBox(height: AppSpacing.lg),
                ...content,
              ],
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(mainAxisSize: MainAxisSize.min, children: actions),
            ),
          ),
        ],
      ),
    );
  }
}
