# 💰 Coin Alarm

Aplikasi alarm iseng buat have-fun: **buat matiin alarm, kamu harus "bayar" pakai koin virtual**. Kalau koin habis, selesaikan tantangan buat dapat koin gratis. Semua pakai mata uang bohongan — **tidak ada uang sungguhan** yang terlibat.

## Fitur
- ⏰ Tambah/hapus/nyalakan-matikan alarm (jam & menit).
- 🪙 Saldo koin virtual (awal 500), tersimpan di HP pakai `shared_preferences`.
- 💸 Matiin alarm = bayar 100 koin.
- 🧠 Koin habis? Jawab tantangan matematika buat dapat 100 koin gratis.
- ▶️ Tombol "test" di tiap alarm buat langsung nyobain layar bunyi tanpa nunggu jamnya.
- 😈 Layar alarm pakai `PopScope` — nggak bisa kabur pakai tombol back tanpa "bayar".

## Cara jalanin
```bash
flutter pub get
flutter run
```

## Suara alarm
Taruh file `alarm.mp3` di `assets/sounds/`. Tanpa file itu app tetap jalan (alarm "silent"). Lihat `assets/sounds/README.txt`.

## Struktur
```
lib/
├── main.dart                 # entry point, timer cek alarm, audio
├── models/alarm_model.dart   # model alarm
├── services/
│   ├── coin_service.dart     # kelola saldo koin
│   └── alarm_service.dart    # kelola daftar alarm + penyimpanan
└── screens/
    ├── home_screen.dart      # daftar alarm + saldo
    ├── ringing_screen.dart   # layar alarm bunyi (bayar/tantangan)
    └── challenge_dialog.dart # tantangan matematika
```

## Catatan
Ini proyek iseng untuk belajar/senang-senang, bukan untuk dipublish ke store. Konsep "bayar buat matiin" di sini murni pakai koin virtual (gamifikasi), bukan pembayaran uang sungguhan.
