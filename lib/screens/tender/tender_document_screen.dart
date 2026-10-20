import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/primary_button.dart';
import 'tender_step_scaffold.dart';

/// V06 - Tawaran: Dokumen (step 3 of 4)
class TenderDocumentScreen extends StatefulWidget {
  const TenderDocumentScreen({super.key});

  @override
  State<TenderDocumentScreen> createState() => _TenderDocumentScreenState();
}

class _TenderDocumentScreenState extends State<TenderDocumentScreen> {
  final _docs = <String>[]; // simulated upload list

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
          onPressed: () {
            setState(() {
              _docs.add('Dokumen_sokongan_${_docs.length + 1}.pdf');
            });
          },
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
        ..._docs.map((name) => Card(
              child: ListTile(
                leading: const Icon(Icons.description_outlined),
                title: Text(name),
                trailing: IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: () => setState(() => _docs.remove(name)),
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
          onPressed: () => context.go('/tawaran/baru/semak'),
        ),
        const SizedBox(height: AppSpacing.sm),
        SecondaryButton(
          label: 'Simpan draf',
          onPressed: () => ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Draf disimpan'))),
        ),
      ],
    );
  }
}
