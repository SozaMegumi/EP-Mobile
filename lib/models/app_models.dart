// Data models for the eProcurement flows (supplier + admin).
// Every model can be serialised to JSON so the whole state can be persisted.

enum InvitationStatus { baru, aktif, tutup }

extension InvitationStatusLabel on InvitationStatus {
  String get label {
    switch (this) {
      case InvitationStatus.baru:
        return 'Baru';
      case InvitationStatus.aktif:
        return 'Aktif';
      case InvitationStatus.tutup:
        return 'Tutup';
    }
  }
}

/// Status strings shared by tenders, orders and invoices.
class Statuses {
  Statuses._();
  // Tender
  static const tenderDraft = 'Draf';
  static const tenderSent = 'Dihantar';
  static const tenderWon = 'Berjaya';
  static const tenderLost = 'Tidak berjaya';
  // Order
  static const orderNew = 'Pesanan baharu';
  static const orderAccepted = 'Diterima';
  // Invoice
  static const invoiceSent = 'Dihantar';
  static const invoiceReviewed = 'Disemak';
  static const invoicePaid = 'Dibayar';
}

class Invitation {
  final String id;
  final String title;
  final String agency;
  final String closingDate;
  final String location;
  final InvitationStatus status;
  final int quantity;
  final String unit;
  final String description;
  final String deliveryPlace;
  final List<String> specifications;

  const Invitation({
    required this.id,
    required this.title,
    required this.agency,
    required this.closingDate,
    required this.location,
    required this.status,
    this.quantity = 1,
    this.unit = 'unit',
    this.description = '',
    this.deliveryPlace = '',
    this.specifications = const ['Pilih spesifikasi'],
  });

  /// Closing date without the time part, e.g. "18 Okt 2026".
  String get closingDay => closingDate.split('·').first.trim();

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'agency': agency,
        'closingDate': closingDate,
        'location': location,
        'status': status.name,
        'quantity': quantity,
        'unit': unit,
        'description': description,
        'deliveryPlace': deliveryPlace,
        'specifications': specifications,
      };

  factory Invitation.fromJson(Map<String, dynamic> j) => Invitation(
        id: j['id'] as String,
        title: j['title'] as String,
        agency: j['agency'] as String,
        closingDate: j['closingDate'] as String,
        location: j['location'] as String,
        status: InvitationStatus.values.byName(j['status'] as String),
        quantity: (j['quantity'] as num?)?.toInt() ?? 1,
        unit: j['unit'] as String? ?? 'unit',
        description: j['description'] as String? ?? '',
        deliveryPlace: j['deliveryPlace'] as String? ?? '',
        specifications: (j['specifications'] as List?)?.cast<String>() ??
            const ['Pilih spesifikasi'],
      );
}

class Tender {
  final String id;
  final String invitationId;
  final String title;
  final String submittedDate;
  final double amount;
  final String status; // Draf, Dihantar, Berjaya, Tidak berjaya
  final String spec;
  final int quantity;
  final double unitPrice;
  final List<String> documents;
  final String preparedAt;
  final String submittedAt;

  const Tender({
    required this.id,
    required this.title,
    required this.submittedDate,
    required this.amount,
    required this.status,
    this.invitationId = '',
    this.spec = '',
    this.quantity = 0,
    this.unitPrice = 0,
    this.documents = const [],
    this.preparedAt = '-',
    this.submittedAt = '-',
  });

  Tender copyWith({
    String? submittedDate,
    double? amount,
    String? status,
    String? spec,
    int? quantity,
    double? unitPrice,
    List<String>? documents,
    String? preparedAt,
    String? submittedAt,
  }) =>
      Tender(
        id: id,
        invitationId: invitationId,
        title: title,
        submittedDate: submittedDate ?? this.submittedDate,
        amount: amount ?? this.amount,
        status: status ?? this.status,
        spec: spec ?? this.spec,
        quantity: quantity ?? this.quantity,
        unitPrice: unitPrice ?? this.unitPrice,
        documents: documents ?? this.documents,
        preparedAt: preparedAt ?? this.preparedAt,
        submittedAt: submittedAt ?? this.submittedAt,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'invitationId': invitationId,
        'title': title,
        'submittedDate': submittedDate,
        'amount': amount,
        'status': status,
        'spec': spec,
        'quantity': quantity,
        'unitPrice': unitPrice,
        'documents': documents,
        'preparedAt': preparedAt,
        'submittedAt': submittedAt,
      };

  factory Tender.fromJson(Map<String, dynamic> j) => Tender(
        id: j['id'] as String,
        invitationId: j['invitationId'] as String? ?? '',
        title: j['title'] as String,
        submittedDate: j['submittedDate'] as String,
        amount: (j['amount'] as num).toDouble(),
        status: j['status'] as String,
        spec: j['spec'] as String? ?? '',
        quantity: (j['quantity'] as num?)?.toInt() ?? 0,
        unitPrice: (j['unitPrice'] as num?)?.toDouble() ?? 0,
        documents: (j['documents'] as List?)?.cast<String>() ?? const [],
        preparedAt: j['preparedAt'] as String? ?? '-',
        submittedAt: j['submittedAt'] as String? ?? '-',
      );
}

class Order {
  final String id;
  final String poNumber;
  final String title;
  final String agency;
  final int quantity;
  final double amount;
  final String status; // Pesanan baharu, Diterima
  final String tenderId;
  final String issuedAt;
  final String acceptedAt;

  const Order({
    required this.id,
    required this.poNumber,
    required this.title,
    required this.agency,
    required this.quantity,
    required this.amount,
    required this.status,
    this.tenderId = '',
    this.issuedAt = '-',
    this.acceptedAt = '',
  });

  Order copyWith({String? status, String? acceptedAt}) => Order(
        id: id,
        poNumber: poNumber,
        title: title,
        agency: agency,
        quantity: quantity,
        amount: amount,
        status: status ?? this.status,
        tenderId: tenderId,
        issuedAt: issuedAt,
        acceptedAt: acceptedAt ?? this.acceptedAt,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'poNumber': poNumber,
        'title': title,
        'agency': agency,
        'quantity': quantity,
        'amount': amount,
        'status': status,
        'tenderId': tenderId,
        'issuedAt': issuedAt,
        'acceptedAt': acceptedAt,
      };

  factory Order.fromJson(Map<String, dynamic> j) => Order(
        id: j['id'] as String,
        poNumber: j['poNumber'] as String,
        title: j['title'] as String,
        agency: j['agency'] as String,
        quantity: (j['quantity'] as num).toInt(),
        amount: (j['amount'] as num).toDouble(),
        status: j['status'] as String,
        tenderId: j['tenderId'] as String? ?? '',
        issuedAt: j['issuedAt'] as String? ?? '-',
        acceptedAt: j['acceptedAt'] as String? ?? '',
      );
}

class Invoice {
  final String id;
  final String invoiceNo;
  final String orderRef;
  final String date;
  final double amount;
  final String status; // Dihantar, Disemak, Dibayar

  const Invoice({
    required this.id,
    required this.invoiceNo,
    required this.orderRef,
    required this.date,
    required this.amount,
    required this.status,
  });

  Invoice copyWith({String? status}) => Invoice(
        id: id,
        invoiceNo: invoiceNo,
        orderRef: orderRef,
        date: date,
        amount: amount,
        status: status ?? this.status,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'invoiceNo': invoiceNo,
        'orderRef': orderRef,
        'date': date,
        'amount': amount,
        'status': status,
      };

  factory Invoice.fromJson(Map<String, dynamic> j) => Invoice(
        id: j['id'] as String,
        invoiceNo: j['invoiceNo'] as String,
        orderRef: j['orderRef'] as String,
        date: j['date'] as String,
        amount: (j['amount'] as num).toDouble(),
        status: j['status'] as String,
      );
}

/// Who a notification is meant for.
enum Audience { supplier, admin }

class AppNotification {
  final String id;
  final String title;
  final String body;

  /// Fixed text for seeded items; ignored when [createdAt] is set.
  final String time;
  final String? createdAt; // ISO-8601
  final bool unread;
  final Audience audience;

  const AppNotification({
    this.id = '',
    required this.title,
    required this.body,
    required this.time,
    this.createdAt,
    this.unread = false,
    this.audience = Audience.supplier,
  });

  AppNotification copyWith({bool? unread}) => AppNotification(
        id: id,
        title: title,
        body: body,
        time: time,
        createdAt: createdAt,
        unread: unread ?? this.unread,
        audience: audience,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'body': body,
        'time': time,
        'createdAt': createdAt,
        'unread': unread,
        'audience': audience.name,
      };

  factory AppNotification.fromJson(Map<String, dynamic> j) => AppNotification(
        id: j['id'] as String? ?? '',
        title: j['title'] as String,
        body: j['body'] as String,
        time: j['time'] as String? ?? '',
        createdAt: j['createdAt'] as String?,
        unread: j['unread'] as bool? ?? false,
        audience:
            Audience.values.byName(j['audience'] as String? ?? 'supplier'),
      );
}

/// A single step on a vertical status timeline.
class TimelineStep {
  final String title;
  final String subtitle;
  final bool done;

  const TimelineStep({
    required this.title,
    required this.subtitle,
    this.done = false,
  });
}

class CompanyProfile {
  final String name;
  final String registrationNo;
  final String category;
  final String email;
  final String phone;
  final String address;

  const CompanyProfile({
    required this.name,
    required this.registrationNo,
    required this.category,
    required this.email,
    required this.phone,
    required this.address,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'registrationNo': registrationNo,
        'category': category,
        'email': email,
        'phone': phone,
        'address': address,
      };

  factory CompanyProfile.fromJson(Map<String, dynamic> j) => CompanyProfile(
        name: j['name'] as String,
        registrationNo: j['registrationNo'] as String,
        category: j['category'] as String,
        email: j['email'] as String,
        phone: j['phone'] as String,
        address: j['address'] as String,
      );
}

/// Login account (demo accounts live in code, only the session is stored).
class UserAccount {
  final String username;
  final String password;
  final String role; // 'supplier' | 'admin'
  final String displayName;

  const UserAccount({
    required this.username,
    required this.password,
    required this.role,
    required this.displayName,
  });

  bool get isAdmin => role == 'admin';
}

/// Shared state of the 4-step tender wizard.
class TenderDraft {
  String invitationId;
  String spec;
  int? quantity;
  double? unitPrice;
  List<String> documents;
  String tenderId; // set when resuming/saving a draft

  TenderDraft({
    this.invitationId = '',
    this.spec = '',
    this.quantity,
    this.unitPrice,
    List<String>? documents,
    this.tenderId = '',
  }) : documents = documents ?? [];

  double get total => (quantity ?? 0) * (unitPrice ?? 0);

  Map<String, dynamic> toJson() => {
        'invitationId': invitationId,
        'spec': spec,
        'quantity': quantity,
        'unitPrice': unitPrice,
        'documents': documents,
        'tenderId': tenderId,
      };

  factory TenderDraft.fromJson(Map<String, dynamic> j) => TenderDraft(
        invitationId: j['invitationId'] as String? ?? '',
        spec: j['spec'] as String? ?? '',
        quantity: (j['quantity'] as num?)?.toInt(),
        unitPrice: (j['unitPrice'] as num?)?.toDouble(),
        documents: (j['documents'] as List?)?.cast<String>().toList(),
        tenderId: j['tenderId'] as String? ?? '',
      );
}
