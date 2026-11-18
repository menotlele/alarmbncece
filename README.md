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

## Mockup web (HP di layar laptop)
Ada mockup interaktif versi "bayar atau langganan" di `web_mockup/index.html`. Satu file HTML, tanpa build. Tinggal buka di browser laptop: teks dan panel demo di kiri, HP di kanan.

Bahasa aplikasinya Inggris, harganya dalam dolar (USD), dan format jamnya 12 jam (AM/PM). Maskotnya **Bill**, jam weker yang menagihmu: dia muncul di layar alarm dengan mata dolar dan balon kata-kata yang berganti-ganti. Tampilannya meniru aplikasi Jam bawaan iPhone (font sistem, daftar alarm polos, saklar hijau, roda pemilih waktu, sheet, alert, banner notifikasi) dan ikut mode terang/gelap.

- ⏰ Tab **Alarms**: kartu saldo, daftar alarm, Edit untuk hapus, + untuk tambah, roda jam/menit/AM-PM, Repeat per hari, Label, Snooze, dan Sound (Cha-Ching, Radar, Angry Rooster, Mom Yelling).
- ⏱️ Tab **Timers**: roda hours/min/sec, tombol bulat Start/Pause/Cancel, daftar Recents (instant noodles, boiled egg, focus).
- 🔒 Pas bunyi: layar kunci dengan "slide to stop" → muncul tagihan $0.99 + service fee $0.29. Snooze juga bayar, tarif naik 0,5× tiap kali snooze.
- 👑 Tab **Pro**: langganan $4.99/bulan atau $29.99/tahun, stop gratis. Membatalkan dibujuk dua kali lewat alert.
- 🧠 Stop without paying: jawab 3 soal perkalian (pakai keypad angka) atau tonton iklan fiktif 10 detik.
- 🎛️ Panel demo: bunyikan alarm/timer seketika (tombol `A` / `T`), nyala-matikan suara dan status Pro, reset data.

Semua harga dan pembayaran di mockup ini pura-pura (saldo bohongan, disimpan di `localStorage` browser).

Live di Vercel: https://alarmbncece.vercel.app

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
