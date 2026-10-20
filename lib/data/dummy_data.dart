import '../models/app_models.dart';

/// Static dummy data used across all screens (no backend wiring).
class DummyData {
  DummyData._();

  static const CompanyProfile company = CompanyProfile(
    name: 'Pembekal Mantap Sdn. Bhd.',
    registrationNo: '201901234567 (1234567-A)',
    category: 'Bekalan pejabat & percetakan',
    email: 'penjual@contoh.com',
    phone: '03-1234 5678',
    address: 'No. 12, Jalan Perindustrian 4,\n40000 Shah Alam, Selangor',
  );

  static const List<Invitation> invitations = [
    Invitation(
      id: 'INV-CONTOH-001',
      title: 'Bekalan kertas A4',
      agency: 'UiTM Shah Alam',
      closingDate: '18 Okt 2026 · 12:00 tengah hari',
      location: 'Shah Alam, Selangor',
      status: InvitationStatus.baru,
    ),
    Invitation(
      id: 'INV-CONTOH-002',
      title: 'Toner pencetak',
      agency: 'UiTM Puncak Alam',
      closingDate: '22 Okt 2026 · 17:00 petang',
      location: 'Puncak Alam, Selangor',
      status: InvitationStatus.baru,
    ),
    Invitation(
      id: 'INV-CONTOH-003',
      title: 'Perabot bilik mesyuarat',
      agency: 'UiTM Shah Alam',
      closingDate: '30 Okt 2026 · 12:00 tengah hari',
      location: 'Shah Alam, Selangor',
      status: InvitationStatus.aktif,
    ),
    Invitation(
      id: 'INV-CONTOH-004',
      title: 'Perkhidmatan penyelenggaraan penyaman udara',
      agency: 'UiTM Dengkil',
      closingDate: '05 Okt 2026 · ditutup',
      location: 'Dengkil, Selangor',
      status: InvitationStatus.tutup,
    ),
  ];

  static const List<Tender> tenders = [
    Tender(
      id: 'TWR-CONTOH-011',
      title: 'Bekalan kertas A4',
      submittedDate: '14 Okt 2026',
      amount: 2308.00,
      status: 'Dihantar',
    ),
    Tender(
      id: 'TWR-CONTOH-010',
      title: 'Toner pencetak',
      submittedDate: '10 Okt 2026',
      amount: 1800.00,
      status: 'Dihantar',
    ),
    Tender(
      id: 'TWR-CONTOH-009',
      title: 'Perabot bilik mesyuarat',
      submittedDate: '-',
      amount: 0.00,
      status: 'Draf',
    ),
  ];

  static const List<Order> orders = [
    Order(
      id: 'PO-CONTOH-018',
      poNumber: 'PO-CONTOH-018',
      title: 'Toner pencetak',
      agency: 'UiTM Puncak Alam',
      quantity: 6,
      amount: 1800.00,
      status: 'Pesanan baharu',
    ),
    Order(
      id: 'PO-CONTOH-015',
      poNumber: 'PO-CONTOH-015',
      title: 'Bekalan kertas A4',
      agency: 'UiTM Shah Alam',
      quantity: 50,
      amount: 2308.00,
      status: 'Diterima',
    ),
  ];

  static const List<Invoice> invoices = [
    Invoice(
      id: 'INV-CONTOH-018',
      invoiceNo: 'INV-CONTOH-018',
      orderRef: 'PO-CONTOH-018',
      date: '14 Okt 2026',
      amount: 1800.00,
      status: 'Dihantar',
    ),
    Invoice(
      id: 'INV-CONTOH-015',
      invoiceNo: 'INV-CONTOH-015',
      orderRef: 'PO-CONTOH-015',
      date: '12 Okt 2026',
      amount: 2308.00,
      status: 'Dibayar',
    ),
  ];

  static const List<AppNotification> notifications = [
    AppNotification(
      title: 'Pelawaan baharu diterima',
      body: 'Bekalan kertas A4 · UiTM Shah Alam',
      time: '2 jam lalu',
      unread: true,
    ),
    AppNotification(
      title: 'Tawaran anda telah dihantar',
      body: 'Toner pencetak · TWR-CONTOH-010',
      time: 'Semalam',
      unread: true,
    ),
    AppNotification(
      title: 'Pesanan tempatan baharu',
      body: 'Toner pencetak · PO-CONTOH-018',
      time: '2 hari lalu',
    ),
    AppNotification(
      title: 'Invois telah dibayar',
      body: 'INV-CONTOH-015 · RM2,308.00',
      time: '3 hari lalu',
    ),
  ];

  static const List<TimelineStep> orderTimeline = [
    TimelineStep(
      title: 'Pesanan dikeluarkan',
      subtitle: '12 Okt 2026 · 09:15 pagi',
      done: true,
    ),
    TimelineStep(
      title: 'Pesanan diterima pembekal',
      subtitle: '12 Okt 2026 · 10:40 pagi',
      done: true,
    ),
    TimelineStep(
      title: 'Penghantaran',
      subtitle: 'Dalam proses',
      done: false,
    ),
    TimelineStep(
      title: 'Penerimaan oleh UiTM',
      subtitle: 'Menunggu pengesahan',
      done: false,
    ),
  ];

  static const List<TimelineStep> invoiceTimeline = [
    TimelineStep(
      title: 'Invois disediakan',
      subtitle: '14 Okt 2026',
      done: true,
    ),
    TimelineStep(
      title: 'Invois dihantar',
      subtitle: '14 Okt 2026',
      done: true,
    ),
    TimelineStep(
      title: 'Semakan kewangan',
      subtitle: 'Dalam proses',
      done: false,
    ),
    TimelineStep(
      title: 'Pembayaran',
      subtitle: 'Menunggu',
      done: false,
    ),
  ];

  static const List<String> specifications = [
    'Pilih spesifikasi',
    'Kertas A4 80gsm · putih',
    'Kertas A4 70gsm · putih',
    'Kertas A4 100gsm · premium',
  ];
}
