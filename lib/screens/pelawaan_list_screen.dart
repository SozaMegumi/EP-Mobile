import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/dummy_data.dart';
import '../models/app_models.dart';
import '../theme/app_theme.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/brand_app_bar.dart';
import '../widgets/common_widgets.dart';

/// V02 - Pelawaan (Invitations list with search + tabs)
class PelawaanListScreen extends StatefulWidget {
  const PelawaanListScreen({super.key});

  @override
  State<PelawaanListScreen> createState() => _PelawaanListScreenState();
}

class _PelawaanListScreenState extends State<PelawaanListScreen> {
  int _tab = 0; // 0 Semua, 1 Baru, 2 Tutup
  String _query = '';

  static const _tabs = ['Semua', 'Baru', 'Tutup'];

  List<Invitation> get _filtered {
    return DummyData.invitations.where((inv) {
      final matchesTab = switch (_tab) {
        1 => inv.status == InvitationStatus.baru,
        2 => inv.status == InvitationStatus.tutup,
        _ => true,
      };
      final matchesQuery = _query.isEmpty ||
          inv.title.toLowerCase().contains(_query.toLowerCase()) ||
          inv.agency.toLowerCase().contains(_query.toLowerCase());
      return matchesTab && matchesQuery;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BrandAppBar(),
      bottomNavigationBar: const AppBottomNav(currentIndex: 1),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.sm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Pelawaan',
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                const SizedBox(height: AppSpacing.md),
                TextField(
                  onChanged: (v) => setState(() => _query = v),
                  decoration: const InputDecoration(
                    hintText: 'Cari pelawaan atau agensi',
                    prefixIcon: Icon(Icons.search, size: 20),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: List.generate(_tabs.length, (i) {
                    final selected = i == _tab;
                    return Padding(
                      padding: const EdgeInsets.only(right: AppSpacing.sm),
                      child: ChoiceChip(
                        label: Text(_tabs[i]),
                        selected: selected,
                        onSelected: (_) => setState(() => _tab = i),
                        showCheckmark: false,
                        selectedColor: AppColors.black,
                        labelStyle: TextStyle(
                          color: selected ? AppColors.white : AppColors.grey700,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
          Expanded(
            child: _filtered.isEmpty
                ? const Center(
                    child: Text('Tiada pelawaan',
                        style: TextStyle(color: AppColors.grey500)),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    itemCount: _filtered.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: AppSpacing.md),
                    itemBuilder: (context, i) {
                      final inv = _filtered[i];
                      return _InvitationCard(invitation: inv);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _InvitationCard extends StatelessWidget {
  final Invitation invitation;

  const _InvitationCard({required this.invitation});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSpacing.radius),
        onTap: () => context.go('/pelawaan/${invitation.id}'),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(invitation.title,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w700)),
                  ),
                  StatusPill(label: invitation.status.label),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(invitation.agency,
                  style:
                      const TextStyle(color: AppColors.grey700, fontSize: 13)),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  const Icon(Icons.schedule,
                      size: 14, color: AppColors.grey500),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(invitation.closingDate,
                        style: const TextStyle(
                            color: AppColors.grey500, fontSize: 12)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
