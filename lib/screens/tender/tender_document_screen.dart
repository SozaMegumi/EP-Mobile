import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/app_store.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/feedback.dart';
import '../../widgets/primary_button.dart';
import 'tender_step_scaffold.dart';

/// V06 - Tawaran: Dokumen (step 3 of 4)
class TenderDocumentScreen extends StatefulWidget {
  const TenderDocumentScreen({super.key});

  @override
  State<TenderDocumentScreen> createState() => _TenderDocumentScreenState();
}

class _TenderDocumentScreenState extends State<TenderDocumentScreen> {
  final _store = AppStore.instance;
  late final List<String> _docs = List.of(_store.draft.documents);
  bool _showError = false;

  /// Simulated upload: adds the next unused "Dokumen_sokongan_N.pdf".
  void _addDoc() {
    var n = 1;
    while (_docs.contains('Dokumen_sokongan_$n.pdf')) {
      n++;
    }
    setState(() {
      _docs.add('Dokumen_sokongan_$n.pdf');
      _showError = false;
    });
    _store.updateDraft(documents: _docs);
  }

  void _removeDoc(String name) {
    setState(() => _docs.remove(name));
    _store.updateDraft(documents: _docs);
  }

  void _next() {
    if (_docs.isEmpty) {
      setState(() => _showError = true);
      return;
    }
    context.go('/tawaran/baru/semak');
  }

  Future<void> _saveDraft() async {
    final t = await runAction(context, _store.saveDraftTender);
    if (t != null && mounted) showToast(context, 'Draf disimpan');
  }

  @override
  Widget build(BuildContext context) {
    return TenderStepScaffold(
      stepIndex: 2,
      title: 'Dokumen tawaran',
      onBack: () => context.go('/tawaran/baru/harga'),
      content: [
        const Text(
          'Muat naik dokumen sokongan tawaran anda.',
          style: TextStyle(color: AppColors.grey700, fontSize: 13),
        ),
        const SizedBox(height: AppSpacing.lg),
        OutlinedButton.icon(
          onPressed: _addDoc,
          icon: const Icon(Icons.upload_file_outlined, size: 18),
          label: const Text('Muat naik dokumen'),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        if (_docs.isEmpty)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.xl),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.cloud_upload_outlined,
                        size: 40, color: AppColors.grey300),
                    SizedBox(height: AppSpacing.md),
                    Text('Tiada dokumen dimuat naik',
                        style: TextStyle(color: AppColors.grey500)),
                  ],
                ),
              ),
            ),
          ),
        if (_showError && _docs.isEmpty)
          const Padding(
            padding: EdgeInsets.only(top: AppSpacing.sm),
            child: Text(
              'Sila muat naik sekurang-kurangnya satu dokumen',
              style: TextStyle(color: AppColors.danger, fontSize: 12),
            ),
          ),
        ..._docs.map((name) => Card(
              child: ListTile(
                leading: const Icon(Icons.description_outlined),
                title: Text(name),
                trailing: IconButton(
                  tooltip: 'Buang dokumen',
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: () => _removeDoc(name),
                ),
              ),
            )),
        const SizedBox(height: AppSpacing.lg),
        const SectionLabel('Dokumen cadangan'),
        const Card(
          child: ListTile(
            leading: Icon(Icons.picture_as_pdf_outlined),
            title: Text('Sijil pendaftaran syarikat'),
            subtitle: Text('Sertakan salinan terkini'),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        const Card(
          child: ListTile(
            leading: Icon(Icons.picture_as_pdf_outlined),
            title: Text('Surat Contoh Sdn. Bhd.'),
            subtitle: Text('Surat pengalaman'),
          ),
        ),
      ],
      actions: [
        PrimaryButton(
          label: 'Seterusnya: Semak',
          onPressed: _next,
        ),
        const SizedBox(height: AppSpacing.sm),
        SecondaryButton(
          label: 'Simpan draf',
          onPressed: _saveDraft,
        ),
      ],
    );
  }
}
