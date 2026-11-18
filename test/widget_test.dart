import 'dart:convert';

import 'package:findprocurement/data/app_store.dart';
import 'package:findprocurement/main.dart';
import 'package:findprocurement/models/app_models.dart';
import 'package:findprocurement/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<AppStore> freshStore({Map<String, Object> initial = const {}}) async {
  SharedPreferences.setMockInitialValues(initial);
  final store = AppStore();
  await store.load();
  AppStore.instance = store;
  return store;
}

Future<void> fillValidDraft(AppStore store, String invitationId) async {
  store.startDraft(invitationId);
  final inv = store.invitationById(invitationId)!;
  store.updateDraft(
    spec: inv.specifications[1],
    quantity: inv.quantity,
    unitPrice: 25,
    documents: ['Dokumen_sokongan_1.pdf'],
  );
}

void main() {
  group('Persistence', () {
    test('seeds demo data on first run', () async {
      final store = await freshStore();
      expect(store.loadState, LoadState.ready);
      expect(store.invitations.length, 5);
      expect(store.tenders.length, 3);
      expect(store.orders.length, 2);
      expect(store.invoices.length, 2);
    });

    test('changes survive a restart', () async {
      final store = await freshStore();
      await store.acceptOrder('PO-CONTOH-018');

      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString(AppStore.storageKey)!;
      final reopened = await freshStore(initial: {AppStore.storageKey: saved});
      expect(
          reopened.orderById('PO-CONTOH-018')!.status, Statuses.orderAccepted);
    });

    test('corrupt storage gives an error state that can be retried', () async {
      final store = await freshStore(initial: {AppStore.storageKey: '{bad'});
      expect(store.loadState, LoadState.error);
      expect(store.errorMessage, isNotEmpty);
      SharedPreferences.setMockInitialValues({});
      await store.load();
      expect(store.loadState, LoadState.ready);
    });
  });

  group('Session', () {
    test('rejects wrong password and accepts valid login', () async {
      final store = await freshStore();
      expect(() => store.login('pembekal.contoh', 'salah'),
          throwsA(isA<StoreException>()));
      await store.login('pembekal.contoh', 'pembekal123');
      expect(store.isLoggedIn, isTrue);
      expect(store.isAdmin, isFalse);
      await store.logout();
      expect(store.isLoggedIn, isFalse);
    });
  });

  group('Tender wizard', () {
    test('keeps values between steps and submits a new tender', () async {
      final store = await freshStore();
      await fillValidDraft(store, 'INV-CONTOH-005');
      expect(store.draft.spec, 'Set alat tulis asas');
      expect(store.draft.total, 500);

      final t = await store.submitTender();
      expect(t.status, Statuses.tenderSent);
      expect(store.tenders.first.id, t.id);
      expect(store.tenders.first.amount, 500);
      expect(store.activeTenderCount, 3);
      expect(store.draft.invitationId, isEmpty);
      expect(store.unreadCount(Audience.admin), 3);
    });

    test('blocks submit when data is missing or out of range', () async {
      final store = await freshStore();
      store.startDraft('INV-CONTOH-005');
      expect(store.validateDraft(), 'Sila pilih spesifikasi');
      store.updateDraft(spec: 'Set alat tulis asas');
      expect(store.validateDraft(), 'Harga seunit mesti lebih daripada 0');
      store.updateDraft(unitPrice: -5);
      expect(store.validateDraft(), isNotNull);
      store.updateDraft(unitPrice: 10);
      expect(store.validateDraft(), contains('dokumen'));
      expect(store.submitTender, throwsA(isA<StoreException>()));
      expect(store.tenders.length, 3);
    });

    test('saves a draft and resumes it', () async {
      final store = await freshStore();
      store.startDraft('INV-CONTOH-005');
      store.updateDraft(spec: 'Set alat tulis asas', unitPrice: 12.5);
      final saved = await store.saveDraftTender();
      expect(saved.status, Statuses.tenderDraft);
      store.draft = TenderDraft();
      store.loadDraftFromTender(saved.id);
      expect(store.draft.unitPrice, 12.5);
      expect(store.draft.spec, 'Set alat tulis asas');
    });

    test('cannot bid twice on the same invitation', () async {
      final store = await freshStore();
      expect(() => store.startDraft('INV-CONTOH-001'),
          throwsA(isA<StoreException>()));
      expect(() => store.startDraft('INV-CONTOH-004'),
          throwsA(isA<StoreException>()));
    });
  });

  group('Orders and invoices', () {
    test('accepting an order updates status and timeline', () async {
      final store = await freshStore();
      final before = store.orderTimeline(store.orderById('PO-CONTOH-018')!);
      expect(before[1].done, isFalse);
      await store.acceptOrder('PO-CONTOH-018');
      final order = store.orderById('PO-CONTOH-018')!;
      expect(order.status, Statuses.orderAccepted);
      expect(store.orderTimeline(order)[1].done, isTrue);
      expect(() => store.acceptOrder('PO-CONTOH-018'),
          throwsA(isA<StoreException>()));
    });

    test('creates an invoice with validation', () async {
      final store = await freshStore();
      expect(store.validateInvoice('PO-CONTOH-018', 'INV-X', 10),
          contains('diterima'));
      await store.acceptOrder('PO-CONTOH-018');
      expect(store.validateInvoice('PO-CONTOH-018', '', 10), isNotNull);
      expect(store.validateInvoice('PO-CONTOH-018', 'INV-CONTOH-018', 10),
          'No. invois telah digunakan');
      expect(store.validateInvoice('PO-CONTOH-018', 'INV-X', 0), isNotNull);
      expect(store.validateInvoice('PO-CONTOH-018', 'INV-X', 99999),
          contains('melebihi'));

      final inv = await store.createInvoice(
          orderId: 'PO-CONTOH-018', invoiceNo: 'INV-019', amount: 500);
      expect(store.invoices.first.id, inv.id);
      expect(inv.status, Statuses.invoiceSent);
      expect(store.invoiceTimeline(inv)[2].done, isFalse);
    });
  });

  group('Admin actions reach the supplier side', () {
    test('award, issue order, review and pay', () async {
      final store = await freshStore();
      await fillValidDraft(store, 'INV-CONTOH-005');
      final t = await store.submitTender();

      await store.decideTender(t.id, award: true);
      expect(store.tenderById(t.id)!.status, Statuses.tenderWon);
      expect(store.tendersAwaitingOrder.map((e) => e.id), contains(t.id));

      final order = await store.issueOrder(t.id);
      expect(order.status, Statuses.orderNew);
      expect(store.tendersAwaitingOrder, isEmpty);
      expect(() => store.issueOrder(t.id), throwsA(isA<StoreException>()));

      await store.acceptOrder(order.id);
      final inv = await store.createInvoice(
          orderId: order.id, invoiceNo: 'INV-020', amount: order.amount);
      expect(() => store.payInvoice(inv.id), throwsA(isA<StoreException>()));
      await store.reviewInvoice(inv.id);
      await store.payInvoice(inv.id);
      expect(store.invoiceById(inv.id)!.status, Statuses.invoicePaid);
      expect(store.orderTimeline(store.orderById(order.id)!)[3].done, isTrue);

      final titles = store
          .notificationsFor(Audience.supplier)
          .map((n) => n.title)
          .toList();
      expect(
          titles,
          containsAll([
            'Tawaran anda berjaya',
            'Pesanan tempatan baharu',
            'Invois telah dibayar'
          ]));
    });

    test('rejecting a tender notifies the supplier', () async {
      final store = await freshStore();
      await store.decideTender('TWR-CONTOH-011', award: false);
      expect(store.tenderById('TWR-CONTOH-011')!.status, Statuses.tenderLost);
      expect(store.notificationsFor(Audience.supplier).first.title,
          'Tawaran anda tidak berjaya');
    });
  });

  group('Validators', () {
    test('amount', () {
      expect(Validators.amount('', 'Harga'), isNotNull);
      expect(Validators.amount('abc', 'Harga'), isNotNull);
      expect(Validators.amount('0', 'Harga'), isNotNull);
      expect(Validators.amount('-3', 'Harga'), isNotNull);
      expect(Validators.amount('1.234', 'Harga'), isNotNull);
      expect(Validators.amount('99999999', 'Harga'), isNotNull);
      expect(Validators.amount('1,250.50', 'Harga'), isNull);
    });

    test('quantity', () {
      expect(Validators.quantity(''), isNotNull);
      expect(Validators.quantity('1.5'), isNotNull);
      expect(Validators.quantity('0'), isNotNull);
      expect(Validators.quantity('50'), isNull);
    });
  });

  group('UI', () {
    testWidgets('unauthenticated users are sent to login', (tester) async {
      final store = await freshStore();
      await tester.pumpWidget(FindProcurementApp(store: store));
      await tester.pumpAndSettle();
      expect(find.text('Log masuk'), findsWidgets);
      expect(find.text('Selamat datang'), findsNothing);
    });

    testWidgets('login validates, then supplier reaches home', (tester) async {
      final store = await freshStore();
      await tester.pumpWidget(FindProcurementApp(store: store));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).first, '');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Log masuk'));
      await tester.pumpAndSettle();
      expect(find.text('Nama pengguna diperlukan'), findsOneWidget);

      await tester.enterText(
          find.byType(TextFormField).first, 'pembekal.contoh');
      await tester.enterText(find.byType(TextFormField).last, 'salah');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Log masuk'));
      await tester.pumpAndSettle();
      expect(find.text('Nama pengguna atau kata laluan tidak betul'),
          findsOneWidget);

      await tester.enterText(find.byType(TextFormField).last, 'pembekal123');
      await tester.tap(find.widgetWithText(ElevatedButton, 'Log masuk'));
      await tester.pumpAndSettle();
      expect(find.text('Selamat datang'), findsOneWidget);
      expect(find.text('Pembekal Mantap Sdn. Bhd.'), findsOneWidget);
    });

    testWidgets(
        'admin account lands on admin dashboard and cannot open supplier routes',
        (tester) async {
      final store = await freshStore();
      await tester.pumpWidget(FindProcurementApp(store: store));
      await tester.pumpAndSettle();
      await store.login('admin.uitm', 'admin123');
      await tester.pumpAndSettle();
      expect(find.text('Panel pentadbir'), findsOneWidget);
    });

    testWidgets('supplier submits a tender through the wizard screens',
        (tester) async {
      tester.view.physicalSize = const Size(900, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      final store = await freshStore();
      await store.login('pembekal.contoh', 'pembekal123');
      await tester.pumpWidget(FindProcurementApp(store: store));
      await tester.pumpAndSettle();

      final router = GoRouter.of(tester.element(find.text('Selamat datang')));
      router.go('/pelawaan/INV-CONTOH-005');
      await tester.pumpAndSettle();
      await tester.tap(find.text('Sediakan tawaran'));
      await tester.pumpAndSettle();

      // Step 1: empty spec is rejected with a Malay message.
      await tester.tap(find.text('Seterusnya: Harga'));
      await tester.pumpAndSettle();
      expect(find.text('Sila pilih spesifikasi'), findsOneWidget);
      await tester.tap(find.byType(DropdownButtonFormField<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Set alat tulis lengkap').last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Seterusnya: Harga'));
      await tester.pumpAndSettle();

      // Step 2: zero price is rejected, valid price accepted.
      await tester.enterText(find.byType(TextFormField), '0');
      await tester.tap(find.text('Seterusnya: Dokumen'));
      await tester.pumpAndSettle();
      expect(find.text('Harga seunit mesti lebih daripada 0'), findsOneWidget);
      await tester.enterText(find.byType(TextFormField), '30');
      await tester.pumpAndSettle();
      expect(find.text('RM600.00'), findsOneWidget);
      await tester.tap(find.text('Seterusnya: Dokumen'));
      await tester.pumpAndSettle();

      // Step 3: no document blocks progression.
      await tester.tap(find.text('Seterusnya: Semak'));
      await tester.pumpAndSettle();
      expect(find.text('Sila muat naik sekurang-kurangnya satu dokumen'),
          findsOneWidget);
      await tester.tap(find.text('Muat naik dokumen'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Seterusnya: Semak'));
      await tester.pumpAndSettle();

      // Step 4: review shows what was entered, then submit.
      expect(find.text('Set alat tulis lengkap'), findsOneWidget);
      expect(find.text('RM600.00'), findsOneWidget);
      expect(find.text('Dokumen_sokongan_1.pdf'), findsOneWidget);
      await tester.tap(find.byType(CheckboxListTile));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Hantar tawaran'));
      await tester.pumpAndSettle();
      expect(find.text('Tawaran dihantar'), findsOneWidget);

      expect(store.tenders.first.status, Statuses.tenderSent);
      expect(store.tenders.first.amount, 600);

      router.go('/tawaran-saya');
      await tester.pumpAndSettle();
      expect(find.text('RM600.00'), findsOneWidget);
    });

    testWidgets('supplier accepts an order and creates an invoice',
        (tester) async {
      tester.view.physicalSize = const Size(900, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      final store = await freshStore();
      await store.login('pembekal.contoh', 'pembekal123');
      await tester.pumpWidget(FindProcurementApp(store: store));
      await tester.pumpAndSettle();

      GoRouter.of(tester.element(find.text('Selamat datang')))
          .go('/pesanan/PO-CONTOH-018');
      await tester.pumpAndSettle();
      await tester.tap(find.text('Terima pesanan'));
      await tester.pumpAndSettle();
      expect(find.text('Pesanan diterima'), findsWidgets);
      expect(store.orderById('PO-CONTOH-018')!.status, Statuses.orderAccepted);

      await tester.tap(find.text('Sediakan invois'));
      await tester.pumpAndSettle();
      // Amount above the order total is rejected.
      await tester.enterText(find.byType(TextFormField).last, '999999');
      await tester.tap(find.byType(CheckboxListTile));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Hantar invois'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Jumlah melebihi jumlah pesanan'),
          findsOneWidget);
      await tester.enterText(find.byType(TextFormField).last, '1800');
      await tester.tap(find.text('Hantar invois'));
      await tester.pumpAndSettle();
      expect(find.text('Invois dihantar'), findsOneWidget);
      expect(store.invoices.first.invoiceNo, 'INV-019');
    });

    testWidgets('persisted session skips login and logout returns to it',
        (tester) async {
      final seeded = await freshStore();
      await seeded.login('pembekal.contoh', 'pembekal123');
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString(AppStore.storageKey)!;
      expect(jsonDecode(saved)['session'], 'pembekal.contoh');

      final store = await freshStore(initial: {AppStore.storageKey: saved});
      await tester.pumpWidget(FindProcurementApp(store: store));
      await tester.pumpAndSettle();
      expect(find.text('Selamat datang'), findsOneWidget);

      await store.logout();
      await tester.pumpAndSettle();
      expect(find.text('Selamat datang'), findsNothing);
      expect(find.text('Akaun pembekal UiTM eProcurement'), findsOneWidget);
    });
  });
}
