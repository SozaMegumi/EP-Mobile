# FindProcurement+ (UiTM Mobile eProcurement)

Flutter prototype of the UiTM eProcurement app with two sides:

- **Pembekal (supplier):** login, invitations, 4-step tender wizard, my tenders, orders, invoices, notifications, profile.
- **Pentadbir (admin):** review tenders (award or reject), issue orders, review invoices and mark them paid.

Admin actions update the same stored data, so the supplier side shows them (status, timelines, notifications, home counts).

## Run

```
flutter pub get
flutter run -d chrome       # verified demo target
flutter test                # 20 tests: persistence, wizard, validation, orders, invoices, admin, route guard
flutter analyze
```

Data is stored locally with `shared_preferences` (browser localStorage on web) and seeded from `lib/data/dummy_data.dart` on first run. Use **Set semula data demo** on the profile or admin page to restore the seed data.

## Demo accounts

| Role | Username | Password |
| --- | --- | --- |
| Pembekal | `pembekal.contoh` | `pembekal123` |
| Pentadbir | `admin.uitm` | `admin123` |

## Demo path

1. Log in as pembekal. Open **Pelawaan > Bekalan alat tulis pejabat > Sediakan tawaran** and finish the 4 steps.
2. Log out, log in as pentadbir. **Tawaran**: open the new tender and accept it. **Pesanan**: issue the order.
3. Log in as pembekal. See the notifications, accept the order, create an invoice.
4. As pentadbir, **Invois**: confirm review, then mark paid. The supplier timeline updates.

## Platforms

Only web is verified. Windows desktop needs the Visual Studio "Desktop development with C++" workload. Android needs the Android SDK and an emulator or device.

`database/schema.sql` is the MySQL design for a future server backend. The app does not connect to it.
