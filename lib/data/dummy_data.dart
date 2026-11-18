import '../models/app_models.dart';

/// Seed data. It is copied into the persistent store on first run only;
/// after that the screens read from [AppStore], not from here.
class DummyData {
  DummyData._();

  /// Demo accounts (passwords are for the prototype only).
  static const List<UserAccount> users = [
    UserAccount(
      username: 'pembekal.contoh',
      password: 'pembekal123',
      role: 'supplier',
      displayName: 'Pembekal Mantap Sdn. Bhd.',
    ),
    UserAccount(
      username: 'admin.uitm',
      password: 'admin123',
      role: 'admin',
      displayName: 'Pentadbir UiTM',
    ),
  ];

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
      quantity: 50,
      unit: 'rim',
      description: 'Pembekalan kertas A4 80gsm berwarna putih untuk kegunaan '
          'pejabat. Pembekal perlu menyediakan tawaran mengikut '
          'spesifikasi teknikal dan harga yang ditetapkan.',
      deliveryPlace: 'Stor pusat, UiTM Shah Alam',
      specifications: specifications,
    ),
    Invitation(
      id: 'INV-CONTOH-002',
      title: 'Toner pencetak',
      agency: 'UiTM Puncak Alam',
      closingDate: '22 Okt 2026 · 17:00 petang',
      location: 'Puncak Alam, Selangor',
      status: InvitationStatus.baru,
      quantity: 6,
      unit: 'unit',
      description: 'Pembekalan toner pencetak laser untuk kegunaan jabatan. '
          'Pembekal perlu menyatakan jenama dan jaminan produk.',
      deliveryPlace: 'Stor jabatan, UiTM Puncak Alam',
      specifications: [
        'Pilih spesifikasi',
        'Toner hitam · asli',
        'Toner hitam · serasi',
        'Toner berwarna · asli',
      ],
    ),
    Invitation(
      id: 'INV-CONTOH-003',
      title: 'Perabot bilik mesyuarat',
      agency: 'UiTM Shah Alam',
      closingDate: '30 Okt 2026 · 12:00 tengah hari',
      location: 'Shah Alam, Selangor',
      status: InvitationStatus.aktif,
      quantity: 12,
      unit: 'set',
      description: 'Pembekalan dan pemasangan perabot bilik mesyuarat '
          'termasuk meja dan kerusi eksekutif.',
      deliveryPlace: 'Bilik mesyuarat utama, UiTM Shah Alam',
      specifications: [
        'Pilih spesifikasi',
        'Meja & 10 kerusi · kayu',
        'Meja & 10 kerusi · logam',
      ],
    ),
    Invitation(
      id: 'INV-CONTOH-004',
      title: 'Perkhidmatan penyelenggaraan penyaman udara',
      agency: 'UiTM Dengkil',
      closingDate: '05 Okt 2026 · ditutup',
      location: 'Dengkil, Selangor',
      status: InvitationStatus.tutup,
      quantity: 20,
      unit: 'unit',
      description: 'Perkhidmatan penyelenggaraan berkala penyaman udara '
          'untuk bangunan pentadbiran.',
      deliveryPlace: 'Bangunan pentadbiran, UiTM Dengkil',
      specifications: [
        'Pilih spesifikasi',
        'Servis berkala · 4 kali setahun',
      ],
    ),
    Invitation(
      id: 'INV-CONTOH-005',
      title: 'Bekalan alat tulis pejabat',
      agency: 'UiTM Shah Alam',
      closingDate: '28 Okt 2026 · 17:00 petang',
      location: 'Shah Alam, Selangor',
      status: InvitationStatus.baru,
      quantity: 20,
      unit: 'kotak',
      description: 'Pembekalan alat tulis pejabat termasuk pen, pensel dan '
          'klip kertas untuk kegunaan jabatan.',
      deliveryPlace: 'Stor pusat, UiTM Shah Alam',
      specifications: [
        'Pilih spesifikasi',
        'Set alat tulis asas',
        'Set alat tulis lengkap',
      ],
    ),
  ];

  static const List<Tender> tenders = [
    Tender(
      id: 'TWR-CONTOH-011',
      invitationId: 'INV-CONTOH-001',
      title: 'Bekalan kertas A4',
      submittedDate: '14 Okt 2026',
      amount: 2308.00,
      status: 'Dihantar',
      spec: 'Kertas A4 80gsm · putih',
      quantity: 50,
      unitPrice: 46.16,
      documents: ['Sijil_pendaftaran.pdf'],
      preparedAt: '14 Okt 2026 · 08:30 pagi',
      submittedAt: '14 Okt 2026 · 09:00 pagi',
    ),
    Tender(
      id: 'TWR-CONTOH-010',
      invitationId: 'INV-CONTOH-002',
      title: 'Toner pencetak',
      submittedDate: '10 Okt 2026',
      amount: 1800.00,
      status: 'Dihantar',
      spec: 'Toner hitam · asli',
      quantity: 6,
      unitPrice: 300.00,
      documents: ['Sijil_pendaftaran.pdf'],
      preparedAt: '10 Okt 2026 · 08:30 pagi',
      submittedAt: '10 Okt 2026 · 09:00 pagi',
    ),
    Tender(
      id: 'TWR-CONTOH-009',
      invitationId: 'INV-CONTOH-003',
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
      issuedAt: '12 Okt 2026 · 09:15 pagi',
    ),
    Order(
      id: 'PO-CONTOH-015',
      poNumber: 'PO-CONTOH-015',
      title: 'Bekalan kertas A4',
      agency: 'UiTM Shah Alam',
      quantity: 50,
      amount: 2308.00,
      status: 'Diterima',
      issuedAt: '12 Okt 2026 · 09:15 pagi',
      acceptedAt: '12 Okt 2026 · 10:40 pagi',
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
      id: 'N-S-004',
      title: 'Pelawaan baharu diterima',
      body: 'Bekalan kertas A4 · UiTM Shah Alam',
      time: '2 jam lalu',
      unread: true,
    ),
    AppNotification(
      id: 'N-S-003',
      title: 'Tawaran anda telah dihantar',
      body: 'Toner pencetak · TWR-CONTOH-010',
      time: 'Semalam',
      unread: true,
    ),
    AppNotification(
      id: 'N-S-002',
      title: 'Pesanan tempatan baharu',
      body: 'Toner pencetak · PO-CONTOH-018',
      time: '2 hari lalu',
    ),
    AppNotification(
      id: 'N-S-001',
      title: 'Invois telah dibayar',
      body: 'INV-CONTOH-015 · RM2,308.00',
      time: '3 hari lalu',
    ),
    AppNotification(
      id: 'N-A-002',
      title: 'Tawaran baharu diterima',
      body: 'Bekalan kertas A4 · TWR-CONTOH-011',
      time: '2 hari lalu',
      unread: true,
      audience: Audience.admin,
    ),
    AppNotification(
      id: 'N-A-001',
      title: 'Invois baharu menunggu semakan',
      body: 'INV-CONTOH-018 · RM1,800.00',
      time: '3 hari lalu',
      unread: true,
      audience: Audience.admin,
    ),
  ];

  static const List<String> specifications = [
    'Pilih spesifikasi',
    'Kertas A4 80gsm · putih',
    'Kertas A4 70gsm · putih',
    'Kertas A4 100gsm · premium',
  ];
}
