import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/app_models.dart';
import '../utils/format.dart';
import 'dummy_data.dart';

enum LoadState { loading, ready, error }

/// A business-rule or storage failure with a Malay message for the user.
class StoreException implements Exception {
  final String message;
  const StoreException(this.message);
  @override
  String toString() => message;
}

/// Single source of truth for the app. All data lives here, is persisted to
/// local storage (shared_preferences: localStorage on web) and is seeded from
/// [DummyData] on first run.
class AppStore extends ChangeNotifier {
  /// App-wide instance. Tests replace it with a fresh one.
  static AppStore instance = AppStore();

  static const storageKey = 'findprocurement_state_v1';

  AppStore({DateTime Function()? clock}) : _clock = clock ?? DateTime.now;

  final DateTime Function() _clock;
  int _seq = 0;

  LoadState loadState = LoadState.loading;
  String errorMessage = '';

  List<Invitation> invitations = [];
  List<Tender> tenders = [];
  List<Order> orders = [];
  List<Invoice> invoices = [];
  List<AppNotification> notifications = [];
  CompanyProfile company = DummyData.company;
  TenderDraft draft = TenderDraft();
  String? sessionUser;

  /// Bumped when the session or load state changes (drives route guards).
  final ValueNotifier<int> sessionVersion = ValueNotifier<int>(0);

  /// Last submitted ids, used by the success screens.
  String lastTenderId = '';
  String lastInvoiceId = '';

  // ---------------------------------------------------------------- loading

  Future<void> load() async {
    loadState = LoadState.loading;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(storageKey);
      if (raw == null) {
        _seed();
        await _save();
      } else {
        _fromJson(jsonDecode(raw) as Map<String, dynamic>);
      }
      loadState = LoadState.ready;
      errorMessage = '';
    } catch (e) {
      loadState = LoadState.error;
      errorMessage = 'Data tidak dapat dimuatkan. Sila cuba lagi.';
      if (kDebugMode) debugPrint('AppStore.load failed: $e');
    }
    sessionVersion.value++;
    notifyListeners();
  }

  /// Wipes everything and restores the demo data (session is kept).
  Future<void> resetDemoData() async {
    final user = sessionUser;
    _seed();
    sessionUser = user;
    await _commit();
  }

  void _seed() {
    invitations = List.of(DummyData.invitations);
    tenders = List.of(DummyData.tenders);
    orders = List.of(DummyData.orders);
    invoices = List.of(DummyData.invoices);
    notifications = List.of(DummyData.notifications);
    company = DummyData.company;
    draft = TenderDraft();
    sessionUser = null;
    lastTenderId = '';
    lastInvoiceId = '';
  }

  Map<String, dynamic> _toJson() => {
        'invitations': invitations.map((e) => e.toJson()).toList(),
        'tenders': tenders.map((e) => e.toJson()).toList(),
        'orders': orders.map((e) => e.toJson()).toList(),
        'invoices': invoices.map((e) => e.toJson()).toList(),
        'notifications': notifications.map((e) => e.toJson()).toList(),
        'company': company.toJson(),
        'draft': draft.toJson(),
        'session': sessionUser,
      };

  List<T> _list<T>(Map<String, dynamic> j, String key,
          T Function(Map<String, dynamic>) f) =>
      (j[key] as List).map((e) => f(e as Map<String, dynamic>)).toList();

  void _fromJson(Map<String, dynamic> j) {
    invitations = _list(j, 'invitations', Invitation.fromJson);
    tenders = _list(j, 'tenders', Tender.fromJson);
    orders = _list(j, 'orders', Order.fromJson);
    invoices = _list(j, 'invoices', Invoice.fromJson);
    notifications = _list(j, 'notifications', AppNotification.fromJson);
    company = CompanyProfile.fromJson(j['company'] as Map<String, dynamic>);
    draft = TenderDraft.fromJson(j['draft'] as Map<String, dynamic>);
    sessionUser = j['session'] as String?;
    if (currentUser == null) sessionUser = null;
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final ok = await prefs.setString(storageKey, jsonEncode(_toJson()));
    if (!ok) throw const StoreException('Data tidak dapat disimpan.');
  }

  /// Notifies listeners and persists. Throws [StoreException] if saving fails.
  Future<void> _commit() async {
    notifyListeners();
    try {
      await _save();
    } catch (_) {
      throw const StoreException('Gagal menyimpan data. Sila cuba lagi.');
    }
  }

  // ---------------------------------------------------------------- session

  UserAccount? get currentUser {
    for (final u in DummyData.users) {
      if (u.username == sessionUser) return u;
    }
    return null;
  }

  bool get isLoggedIn => currentUser != null;
  bool get isAdmin => currentUser?.isAdmin ?? false;

  Future<UserAccount> login(String username, String password) async {
    final name = username.trim();
    UserAccount? match;
    for (final u in DummyData.users) {
      if (u.username.toLowerCase() == name.toLowerCase() &&
          u.password == password) {
        match = u;
      }
    }
    if (match == null) {
      throw const StoreException('Nama pengguna atau kata laluan tidak betul');
    }
    sessionUser = match.username;
    sessionVersion.value++;
    await _commit();
    return match;
  }

  Future<void> logout() async {
    sessionUser = null;
    draft = TenderDraft();
    sessionVersion.value++;
    await _commit();
  }

  // ---------------------------------------------------------------- helpers

  String _now() => Fmt.dateTime(_clock());

  String _nextId(String prefix, Iterable<String> existing) {
    var max = 0;
    for (final id in existing) {
      final m = RegExp(r'(\d+)$').firstMatch(id);
      if (m != null) {
        final n = int.parse(m.group(1)!);
        if (n > max) max = n;
      }
    }
    return '$prefix-${(max + 1).toString().padLeft(3, '0')}';
  }

  void _notify(Audience audience, String title, String body) {
    _seq++;
    notifications.insert(
      0,
      AppNotification(
        id: 'N-${_clock().microsecondsSinceEpoch}-$_seq',
        title: title,
        body: body,
        time: '',
        createdAt: _clock().toIso8601String(),
        unread: true,
        audience: audience,
      ),
    );
  }

  Invitation? invitationById(String id) {
    for (final e in invitations) {
      if (e.id == id) return e;
    }
    return null;
  }

  Tender? tenderById(String id) {
    for (final e in tenders) {
      if (e.id == id) return e;
    }
    return null;
  }

  Order? orderById(String id) {
    for (final e in orders) {
      if (e.id == id) return e;
    }
    return null;
  }

  Invoice? invoiceById(String id) {
    for (final e in invoices) {
      if (e.id == id) return e;
    }
    return null;
  }

  // -------------------------------------------------------- derived (counts)

  int get openInvitationCount =>
      invitations.where((i) => i.status != InvitationStatus.tutup).length;

  int get activeTenderCount =>
      tenders.where((t) => t.status == Statuses.tenderSent).length;

  Invitation? get nextClosingInvitation {
    for (final i in invitations) {
      if (i.status != InvitationStatus.tutup) return i;
    }
    return null;
  }

  List<AppNotification> notificationsFor(Audience a) =>
      notifications.where((n) => n.audience == a).toList();

  int unreadCount(Audience a) =>
      notifications.where((n) => n.audience == a && n.unread).length;

  Audience get audience => isAdmin ? Audience.admin : Audience.supplier;

  String timeLabel(AppNotification n) {
    final c = n.createdAt == null ? null : DateTime.tryParse(n.createdAt!);
    return c == null ? n.time : Fmt.ago(c, _clock());
  }

  Future<void> markAllRead(Audience a) async {
    if (unreadCount(a) == 0) return;
    notifications = [
      for (final n in notifications)
        n.audience == a ? n.copyWith(unread: false) : n,
    ];
    await _commit();
  }

  // ----------------------------------------------------------- tender wizard

  /// Tender (sent/won/lost) already filed for this invitation, if any.
  Tender? filedTenderFor(String invitationId) {
    for (final t in tenders) {
      if (t.invitationId == invitationId && t.status != Statuses.tenderDraft) {
        return t;
      }
    }
    return null;
  }

  Tender? draftTenderFor(String invitationId) {
    for (final t in tenders) {
      if (t.invitationId == invitationId && t.status == Statuses.tenderDraft) {
        return t;
      }
    }
    return null;
  }

  /// Prepares the wizard state for [invitationId]. Keeps already entered
  /// values when the same invitation is reopened.
  void startDraft(String invitationId) {
    final inv = invitationById(invitationId);
    if (inv == null) {
      throw const StoreException('Pelawaan tidak dijumpai');
    }
    if (inv.status == InvitationStatus.tutup) {
      throw const StoreException('Pelawaan ini telah ditutup');
    }
    if (filedTenderFor(invitationId) != null) {
      throw const StoreException('Tawaran untuk pelawaan ini telah dihantar');
    }
    final saved = draftTenderFor(invitationId);
    if (draft.invitationId == invitationId) return;
    if (saved != null) {
      loadDraftFromTender(saved.id);
      return;
    }
    draft = TenderDraft(invitationId: invitationId, quantity: inv.quantity);
    notifyListeners();
    _saveQuietly();
  }

  void loadDraftFromTender(String tenderId) {
    final t = tenderById(tenderId);
    if (t == null || t.status != Statuses.tenderDraft) {
      throw const StoreException('Draf tidak dijumpai');
    }
    final inv = invitationById(t.invitationId);
    draft = TenderDraft(
      invitationId: t.invitationId,
      spec: t.spec,
      quantity: t.quantity > 0 ? t.quantity : inv?.quantity,
      unitPrice: t.unitPrice > 0 ? t.unitPrice : null,
      documents: List.of(t.documents),
      tenderId: t.id,
    );
    notifyListeners();
    _saveQuietly();
  }

  void updateDraft({
    String? spec,
    int? quantity,
    double? unitPrice,
    bool clearPrice = false,
    List<String>? documents,
  }) {
    if (spec != null) draft.spec = spec;
    if (quantity != null) draft.quantity = quantity;
    if (unitPrice != null) draft.unitPrice = unitPrice;
    if (clearPrice) draft.unitPrice = null;
    if (documents != null) draft.documents = List.of(documents);
    notifyListeners();
    _saveQuietly();
  }

  Future<void> discardDraft() async {
    draft = TenderDraft();
    await _commit();
  }

  /// Returns null when the wizard data is valid, else a Malay message.
  String? validateDraft() {
    final inv = invitationById(draft.invitationId);
    if (inv == null) return 'Pelawaan tidak dijumpai';
    final spec = draft.spec;
    if (spec.isEmpty || spec == inv.specifications.first) {
      return 'Sila pilih spesifikasi';
    }
    if ((draft.quantity ?? 0) <= 0) return 'Kuantiti mesti lebih daripada 0';
    if ((draft.unitPrice ?? 0) <= 0) {
      return 'Harga seunit mesti lebih daripada 0';
    }
    if (draft.documents.isEmpty) {
      return 'Sila muat naik sekurang-kurangnya satu dokumen';
    }
    return null;
  }

  Future<Tender> saveDraftTender() async {
    final inv = invitationById(draft.invitationId);
    if (inv == null) throw const StoreException('Pelawaan tidak dijumpai');
    final existing = draft.tenderId.isEmpty ? null : tenderById(draft.tenderId);
    final tender = Tender(
      id: existing?.id ?? _nextId('TWR', tenders.map((t) => t.id)),
      invitationId: inv.id,
      title: inv.title,
      submittedDate: '-',
      amount: draft.total,
      status: Statuses.tenderDraft,
      spec: draft.spec,
      quantity: draft.quantity ?? 0,
      unitPrice: draft.unitPrice ?? 0,
      documents: List.of(draft.documents),
      preparedAt: existing?.preparedAt != null && existing!.preparedAt != '-'
          ? existing.preparedAt
          : _now(),
    );
    if (existing == null) {
      tenders.insert(0, tender);
    } else {
      tenders[tenders.indexWhere((t) => t.id == existing.id)] = tender;
    }
    draft.tenderId = tender.id;
    await _commit();
    return tender;
  }

  Future<Tender> submitTender() async {
    final error = validateDraft();
    if (error != null) throw StoreException(error);
    final inv = invitationById(draft.invitationId)!;
    if (inv.status == InvitationStatus.tutup) {
      throw const StoreException('Pelawaan ini telah ditutup');
    }
    if (filedTenderFor(inv.id) != null) {
      throw const StoreException('Tawaran untuk pelawaan ini telah dihantar');
    }
    final now = _clock();
    final existing = draft.tenderId.isEmpty ? null : tenderById(draft.tenderId);
    final tender = Tender(
      id: existing?.id ?? _nextId('TWR', tenders.map((t) => t.id)),
      invitationId: inv.id,
      title: inv.title,
      submittedDate: Fmt.date(now),
      amount: draft.total,
      status: Statuses.tenderSent,
      spec: draft.spec,
      quantity: draft.quantity!,
      unitPrice: draft.unitPrice!,
      documents: List.of(draft.documents),
      preparedAt: existing != null && existing.preparedAt != '-'
          ? existing.preparedAt
          : Fmt.dateTime(now),
      submittedAt: Fmt.dateTime(now),
    );
    if (existing == null) {
      tenders.insert(0, tender);
    } else {
      tenders[tenders.indexWhere((t) => t.id == existing.id)] = tender;
    }
    lastTenderId = tender.id;
    draft = TenderDraft();
    _notify(Audience.supplier, 'Tawaran anda telah dihantar',
        '${tender.title} · ${tender.id}');
    _notify(Audience.admin, 'Tawaran baharu diterima',
        '${tender.title} · ${tender.id}');
    await _commit();
    return tender;
  }

  List<TimelineStep> tenderTimeline(Tender t) {
    final decided =
        t.status == Statuses.tenderWon || t.status == Statuses.tenderLost;
    final sent = t.status != Statuses.tenderDraft;
    return [
      TimelineStep(
        title: 'Tawaran disediakan',
        subtitle: t.preparedAt,
        done: true,
      ),
      TimelineStep(
        title: 'Tawaran dihantar',
        subtitle: sent ? t.submittedAt : 'Belum dihantar',
        done: sent,
      ),
      TimelineStep(
        title: 'Penilaian',
        subtitle: decided
            ? 'Selesai'
            : sent
                ? 'Dalam proses'
                : 'Menunggu penghantaran',
        done: decided,
      ),
      TimelineStep(
        title: 'Keputusan',
        subtitle: decided ? t.status : 'Menunggu',
        done: decided,
      ),
    ];
  }

  // ------------------------------------------------------------------ orders

  Order? orderForTender(String tenderId) {
    for (final o in orders) {
      if (o.tenderId == tenderId) return o;
    }
    return null;
  }

  Future<Order> acceptOrder(String id) async {
    final o = orderById(id);
    if (o == null) throw const StoreException('Pesanan tidak dijumpai');
    if (o.status != Statuses.orderNew) {
      throw const StoreException('Pesanan ini telah diterima');
    }
    final updated =
        o.copyWith(status: Statuses.orderAccepted, acceptedAt: _now());
    orders[orders.indexWhere((e) => e.id == id)] = updated;
    _notify(Audience.admin, 'Pesanan diterima pembekal',
        '${o.title} · ${o.poNumber}');
    await _commit();
    return updated;
  }

  List<Invoice> invoicesForOrder(String orderId) =>
      invoices.where((i) => i.orderRef == orderId).toList();

  List<TimelineStep> orderTimeline(Order o) {
    final accepted = o.status == Statuses.orderAccepted;
    final related =
        invoicesForOrder(o.id).where((i) => i.status != 'Draf').toList();
    final billed = accepted && related.isNotEmpty;
    final paid = related.any((i) => i.status == Statuses.invoicePaid);
    return [
      TimelineStep(
          title: 'Pesanan dikeluarkan', subtitle: o.issuedAt, done: true),
      TimelineStep(
        title: 'Pesanan diterima pembekal',
        subtitle: accepted ? o.acceptedAt : 'Menunggu pembekal',
        done: accepted,
      ),
      TimelineStep(
        title: 'Penghantaran',
        subtitle: billed
            ? 'Selesai'
            : accepted
                ? 'Dalam proses'
                : 'Menunggu',
        done: billed,
      ),
      TimelineStep(
        title: 'Penerimaan oleh UiTM',
        subtitle: paid ? 'Disahkan' : 'Menunggu pengesahan',
        done: paid,
      ),
    ];
  }

  // ---------------------------------------------------------------- invoices

  List<Order> get ordersReadyForInvoice =>
      orders.where((o) => o.status == Statuses.orderAccepted).toList();

  String nextInvoiceNo() => _nextId('INV', invoices.map((i) => i.invoiceNo));

  String? invoiceNoError(String? invoiceNo) {
    final no = (invoiceNo ?? '').trim();
    if (no.isEmpty) return 'No. invois diperlukan';
    if (!RegExp(r'^[A-Za-z0-9_-]+$').hasMatch(no)) {
      return 'No. invois hanya boleh mengandungi huruf, nombor, - dan _';
    }
    if (invoices.any((i) => i.invoiceNo.toLowerCase() == no.toLowerCase())) {
      return 'No. invois telah digunakan';
    }
    return null;
  }

  String? validateInvoice(String orderId, String invoiceNo, double? amount) {
    final o = orderById(orderId);
    if (o == null) return 'Sila pilih pesanan';
    if (o.status != Statuses.orderAccepted) {
      return 'Pesanan mesti diterima sebelum invois disediakan';
    }
    final noError = invoiceNoError(invoiceNo);
    if (noError != null) return noError;
    if (amount == null || amount <= 0) {
      return 'Jumlah invois mesti lebih daripada 0';
    }
    if (amount > o.amount) {
      return 'Jumlah invois melebihi jumlah pesanan (${Fmt.rm(o.amount)})';
    }
    return null;
  }

  Future<Invoice> createInvoice({
    required String orderId,
    required String invoiceNo,
    required double amount,
    bool asDraft = false,
  }) async {
    final error = validateInvoice(orderId, invoiceNo, amount);
    if (error != null) throw StoreException(error);
    final no = invoiceNo.trim();
    final inv = Invoice(
      id: no,
      invoiceNo: no,
      orderRef: orderId,
      date: Fmt.date(_clock()),
      amount: amount,
      status: asDraft ? 'Draf' : Statuses.invoiceSent,
    );
    invoices.insert(0, inv);
    lastInvoiceId = inv.id;
    if (!asDraft) _notifyInvoiceSent(inv);
    await _commit();
    return inv;
  }

  void _notifyInvoiceSent(Invoice inv) {
    _notify(Audience.admin, 'Invois baharu menunggu semakan',
        '${inv.invoiceNo} · ${Fmt.rm(inv.amount)}');
  }

  Future<void> sendInvoiceDraft(String id) async {
    final inv = invoiceById(id);
    if (inv == null || inv.status != 'Draf') {
      throw const StoreException('Draf invois tidak dijumpai');
    }
    invoices[invoices.indexWhere((e) => e.id == id)] =
        inv.copyWith(status: Statuses.invoiceSent);
    lastInvoiceId = id;
    _notifyInvoiceSent(inv);
    await _commit();
  }

  List<TimelineStep> invoiceTimeline(Invoice i) {
    final sent = i.status != 'Draf';
    final reviewed = i.status == Statuses.invoiceReviewed ||
        i.status == Statuses.invoicePaid;
    final paid = i.status == Statuses.invoicePaid;
    return [
      TimelineStep(title: 'Invois disediakan', subtitle: i.date, done: true),
      TimelineStep(
        title: 'Invois dihantar',
        subtitle: sent ? i.date : 'Belum dihantar',
        done: sent,
      ),
      TimelineStep(
        title: 'Semakan kewangan',
        subtitle: reviewed
            ? 'Selesai'
            : sent
                ? 'Dalam proses'
                : 'Menunggu penghantaran',
        done: reviewed,
      ),
      TimelineStep(
        title: 'Pembayaran',
        subtitle: paid ? 'Selesai' : 'Menunggu',
        done: paid,
      ),
    ];
  }

  // ------------------------------------------------------------------- admin

  List<Tender> get submittedTenders =>
      tenders.where((t) => t.status != Statuses.tenderDraft).toList();

  List<Tender> get tendersAwaitingOrder => tenders
      .where(
          (t) => t.status == Statuses.tenderWon && orderForTender(t.id) == null)
      .toList();

  List<Invoice> get submittedInvoices =>
      invoices.where((i) => i.status != 'Draf').toList();

  Future<void> decideTender(String id, {required bool award}) async {
    final t = tenderById(id);
    if (t == null) throw const StoreException('Tawaran tidak dijumpai');
    if (t.status != Statuses.tenderSent) {
      throw const StoreException('Tawaran ini telah diputuskan');
    }
    final status = award ? Statuses.tenderWon : Statuses.tenderLost;
    tenders[tenders.indexWhere((e) => e.id == id)] = t.copyWith(status: status);
    _notify(
      Audience.supplier,
      award ? 'Tawaran anda berjaya' : 'Tawaran anda tidak berjaya',
      '${t.title} · ${t.id}',
    );
    await _commit();
  }

  Future<Order> issueOrder(String tenderId) async {
    final t = tenderById(tenderId);
    if (t == null) throw const StoreException('Tawaran tidak dijumpai');
    if (t.status != Statuses.tenderWon) {
      throw const StoreException(
          'Pesanan hanya boleh dikeluarkan untuk tawaran yang berjaya');
    }
    if (orderForTender(tenderId) != null) {
      throw const StoreException('Pesanan telah dikeluarkan untuk tawaran ini');
    }
    final inv = invitationById(t.invitationId);
    final id = _nextId('PO', orders.map((o) => o.id));
    final order = Order(
      id: id,
      poNumber: id,
      title: t.title,
      agency: inv?.agency ?? 'UiTM',
      quantity: t.quantity,
      amount: t.amount,
      status: Statuses.orderNew,
      tenderId: t.id,
      issuedAt: _now(),
    );
    orders.insert(0, order);
    _notify(Audience.supplier, 'Pesanan tempatan baharu',
        '${order.title} · ${order.poNumber}');
    await _commit();
    return order;
  }

  Future<void> reviewInvoice(String id) async {
    final i = invoiceById(id);
    if (i == null) throw const StoreException('Invois tidak dijumpai');
    if (i.status != Statuses.invoiceSent) {
      throw const StoreException('Invois ini tidak menunggu semakan');
    }
    invoices[invoices.indexWhere((e) => e.id == id)] =
        i.copyWith(status: Statuses.invoiceReviewed);
    _notify(Audience.supplier, 'Invois telah disemak',
        '${i.invoiceNo} · ${Fmt.rm(i.amount)}');
    await _commit();
  }

  Future<void> payInvoice(String id) async {
    final i = invoiceById(id);
    if (i == null) throw const StoreException('Invois tidak dijumpai');
    if (i.status != Statuses.invoiceReviewed) {
      throw const StoreException('Invois mesti disemak sebelum dibayar');
    }
    invoices[invoices.indexWhere((e) => e.id == id)] =
        i.copyWith(status: Statuses.invoicePaid);
    _notify(Audience.supplier, 'Invois telah dibayar',
        '${i.invoiceNo} · ${Fmt.rm(i.amount)}');
    await _commit();
  }

  // ----------------------------------------------------------------- utility

  void _saveQuietly() {
    unawaited(_save().catchError((Object e) {
      if (kDebugMode) debugPrint('AppStore save failed: $e');
    }));
  }
}
