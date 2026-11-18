import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/app_store.dart';
import '../models/app_models.dart';
import '../utils/format.dart';
import '../theme/app_theme.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/brand_app_bar.dart';
import '../widgets/common_widgets.dart';

/// V01 - Utama (Home / Dashboard)
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = AppStore.instance;
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final next = store.nextClosingInvitation;
        final orders = store.orders.take(2).toList();
        final invoices = store.invoices.where((i) => i.status != 'Draf').take(2).toList();
        return Scaffold(
          appBar: const BrandAppBar(),
          bottomNavigationBar: const AppBottomNav(currentIndex: 0),
          body: ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              const Text('Selamat datang',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
              const SizedBox(height: AppSpacing.xs),
              Text(store.company.name,
                  style:
                      const TextStyle(color: AppColors.grey500, fontSize: 13)),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      value: '${store.openInvitationCount}',
                      label: 'Pelawaan terbuka',
                      onTap: () => context.go('/pelawaan'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: _StatCard(
                      value: '${store.activeTenderCount}',
                      label: 'Tawaran aktif',
                      onTap: () => context.go('/tawaran-saya'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
              const SectionLabel('Tarikh tutup terdekat'),
              if (next == null)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(AppSpacing.lg),
                    child: Text('Tiada pelawaan terbuka',
                        style: TextStyle(color: AppColors.grey500)),
                  ),
                )
              else
                Card(
                  child: ListTile(
                    title: Text(next.title,
                        style: const TextStyle(fontWeight: FontWeight.w700)),
                    subtitle: Text(next.closingDate),
                    trailing: StatusPill(label: next.status.label),
                    onTap: () => context.go('/pelawaan/${next.id}'),
                  ),
                ),
              const SizedBox(height: AppSpacing.xl),
              Row(
                children: [
                  const Expanded(child: SectionLabel('Status pesanan')),
                  TextButton(
                    onPressed: () => context.go('/pesanan'),
                    child: const Text('Lihat semua'),
                  ),
                ],
              ),
              Card(
                child: orders.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.all(AppSpacing.lg),
                        child: Text('Tiada pesanan',
                            style: TextStyle(color: AppColors.grey500)),
                      )
                    : Column(
                        children: [
                          for (var i = 0; i < orders.length; i++) ...[
                            if (i > 0) const Divider(height: 1),
                            ListTile(
                              title: Text(orders[i].title,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700)),
                              subtitle: Text(
                                  '${orders[i].poNumber} · ${Fmt.rm(orders[i].amount)}'),
                              trailing: StatusPill(
                                  label: orders[i].status == Statuses.orderNew
                                      ? 'Baharu'
                                      : orders[i].status),
                              onTap: () =>
                                  context.go('/pesanan/${orders[i].id}'),
                            ),
                          ],
                        ],
                      ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Row(
                children: [
                  const Expanded(child: SectionLabel('Invois')),
                  TextButton(
                    onPressed: () => context.go('/invois'),
                    child: const Text('Lihat semua'),
                  ),
                ],
              ),
              Card(
                child: invoices.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.all(AppSpacing.lg),
                        child: Text('Tiada invois',
                            style: TextStyle(color: AppColors.grey500)),
                      )
                    : Column(
                        children: [
                          for (var i = 0; i < invoices.length; i++) ...[
                            if (i > 0) const Divider(height: 1),
                            ListTile(
                              title: Text(invoices[i].invoiceNo,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700)),
                              subtitle: Text(
                                  '${invoices[i].orderRef} · ${Fmt.rm(invoices[i].amount)}'),
                              trailing: StatusPill(label: invoices[i].status),
                              onTap: () => context
                                  .go('/invois/${invoices[i].id}/status'),
                            ),
                          ],
                        ],
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final VoidCallback? onTap;

  const _StatCard({required this.value, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSpacing.radius),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value,
                  style: const TextStyle(
                      fontSize: 28, fontWeight: FontWeight.w800)),
              const SizedBox(height: AppSpacing.xs),
              Text(label,
                  style:
                      const TextStyle(color: AppColors.grey500, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}
