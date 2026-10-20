// Simple data models for the eProcurement supplier flow.
// These are plain Dart classes populated with dummy data (no backend).

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

class Invitation {
  final String id;
  final String title;
  final String agency;
  final String closingDate;
  final String location;
  final InvitationStatus status;

  const Invitation({
    required this.id,
    required this.title,
    required this.agency,
    required this.closingDate,
    required this.location,
    required this.status,
  });
}

class Tender {
  final String id;
  final String title;
  final String submittedDate;
  final double amount;
  final String status; // e.g. "Dihantar", "Draf", "Berjaya"

  const Tender({
    required this.id,
    required this.title,
    required this.submittedDate,
    required this.amount,
    required this.status,
  });
}

class Order {
  final String id;
  final String poNumber;
  final String title;
  final String agency;
  final int quantity;
  final double amount;
  final String status; // e.g. "Pesanan baharu", "Diterima", "Dihantar"

  const Order({
    required this.id,
    required this.poNumber,
    required this.title,
    required this.agency,
    required this.quantity,
    required this.amount,
    required this.status,
  });
}

class Invoice {
  final String id;
  final String invoiceNo;
  final String orderRef;
  final String date;
  final double amount;
  final String status; // e.g. "Dihantar", "Dibayar", "Draf"

  const Invoice({
    required this.id,
    required this.invoiceNo,
    required this.orderRef,
    required this.date,
    required this.amount,
    required this.status,
  });
}

class AppNotification {
  final String title;
  final String body;
  final String time;
  final bool unread;

  const AppNotification({
    required this.title,
    required this.body,
    required this.time,
    this.unread = false,
  });
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
}
