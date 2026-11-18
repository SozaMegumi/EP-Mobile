import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/app_store.dart';
import '../screens/admin/admin_home_screen.dart';
import '../screens/admin/admin_invoices_screen.dart';
import '../screens/admin/admin_orders_screen.dart';
import '../screens/admin/admin_tender_detail_screen.dart';
import '../screens/admin/admin_tenders_screen.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../screens/notifications_screen.dart';
import '../screens/pelawaan_detail_screen.dart';
import '../screens/pelawaan_list_screen.dart';
import '../screens/pesanan_accepted_screen.dart';
import '../screens/pesanan_detail_screen.dart';
import '../screens/pesanan_list_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/tawaran_saya_screen.dart';
import '../screens/invoice/invoice_create_screen.dart';
import '../screens/invoice/invoice_list_screen.dart';
import '../screens/invoice/invoice_status_screen.dart';
import '../screens/invoice/invoice_success_screen.dart';
import '../screens/tender/tender_delivery_record_screen.dart';
import '../screens/tender/tender_document_screen.dart';
import '../screens/tender/tender_price_screen.dart';
import '../screens/tender/tender_review_screen.dart';
import '../screens/tender/tender_spec_screen.dart';
import '../screens/tender/tender_success_screen.dart';

/// Central go_router configuration for the whole app.
class AppRouter {
  AppRouter._();

  static GoRouter create(AppStore store) => GoRouter(
    initialLocation: '/login',
    refreshListenable: store.sessionVersion,
    redirect: (context, state) => _guard(store, state.uri.path),
    routes: [
      GoRoute(
        path: '/login',
        builder: (_, __) => const LoginScreen(),
      ),

      // ---- Main tabs ----
      GoRoute(
        path: '/home',
        builder: (_, __) => const HomeScreen(),
      ),
      GoRoute(
        path: '/pelawaan',
        builder: (_, __) => const PelawaanListScreen(),
      ),
      GoRoute(
        path: '/pelawaan/:id',
        builder: (_, state) =>
            PelawaanDetailScreen(invitationId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/tawaran-saya',
        builder: (_, __) => const TawaranSayaScreen(),
      ),
      GoRoute(
        path: '/pesanan',
        builder: (_, __) => const PesananListScreen(),
      ),
      GoRoute(
        path: '/pesanan/:id',
        builder: (_, state) =>
            PesananDetailScreen(orderId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/pesanan/:id/diterima',
        builder: (_, state) =>
            PesananAcceptedScreen(orderId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/profil',
        builder: (_, __) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/notifikasi',
        builder: (_, __) => const NotificationsScreen(),
      ),

      // ---- Tender creation wizard ----
      GoRoute(
        path: '/tawaran/baru/spesifikasi',
        builder: (_, __) => const TenderSpecScreen(),
      ),
      GoRoute(
        path: '/tawaran/baru/harga',
        builder: (_, __) => const TenderPriceScreen(),
      ),
      GoRoute(
        path: '/tawaran/baru/dokumen',
        builder: (_, __) => const TenderDocumentScreen(),
      ),
      GoRoute(
        path: '/tawaran/baru/semak',
        builder: (_, __) => const TenderReviewScreen(),
      ),
      GoRoute(
        path: '/tawaran/berjaya',
        builder: (_, __) => const TenderSuccessScreen(),
      ),
      GoRoute(
        path: '/tawaran/rekod',
        builder: (_, state) => TenderDeliveryRecordScreen(
          tenderId: state.uri.queryParameters['id'],
        ),
      ),

      // ---- Admin flow ----
      GoRoute(path: '/admin', builder: (_, __) => const AdminHomeScreen()),
      GoRoute(
        path: '/admin/tawaran',
        builder: (_, __) => const AdminTendersScreen(),
      ),
      GoRoute(
        path: '/admin/tawaran/:id',
        builder: (_, state) =>
            AdminTenderDetailScreen(tenderId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/admin/pesanan',
        builder: (_, __) => const AdminOrdersScreen(),
      ),
      GoRoute(
        path: '/admin/invois',
        builder: (_, __) => const AdminInvoicesScreen(),
      ),

      // ---- Invoice flow ----
      GoRoute(
        path: '/invois',
        builder: (_, __) => const InvoiceListScreen(),
      ),
      GoRoute(
        path: '/invois/baru',
        builder: (_, state) => InvoiceCreateScreen(
          key: ValueKey(state.uri.toString()),
          orderId: state.uri.queryParameters['order'],
        ),
      ),
      GoRoute(
        path: '/invois/berjaya',
        builder: (_, __) => const InvoiceSuccessScreen(),
      ),
      GoRoute(
        path: '/invois/:id/status',
        builder: (_, state) =>
            InvoiceStatusScreen(invoiceId: state.pathParameters['id']!),
      ),
    ],
    errorBuilder: (_, state) => Scaffold(
      body: Center(child: Text('Halaman tidak dijumpai: ${state.uri}')),
    ),
  );

  /// Route guard: login required, role-based areas, wizard needs a draft.
  static String? _guard(AppStore store, String path) {
    if (store.loadState != LoadState.ready) return null;
    if (!store.isLoggedIn) return path == '/login' ? null : '/login';
    final home = store.isAdmin ? '/admin' : '/home';
    if (path == '/login' || path == '/') return home;
    final isAdminPath = path.startsWith('/admin');
    if (store.isAdmin && !isAdminPath && path != '/notifikasi') return home;
    if (!store.isAdmin && isAdminPath) return home;
    if (path.startsWith('/tawaran/baru') &&
        store.draft.invitationId.isEmpty) {
      return '/pelawaan';
    }
    return null;
  }
}