import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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

  static final GoRouter router = GoRouter(
    initialLocation: '/login',
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
        builder: (_, __) => const TenderDeliveryRecordScreen(),
      ),

      // ---- Invoice flow ----
      GoRoute(
        path: '/invois',
        builder: (_, __) => const InvoiceListScreen(),
      ),
      GoRoute(
        path: '/invois/baru',
        builder: (_, __) => const InvoiceCreateScreen(),
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
}
