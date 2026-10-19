# Collector Vault

## 1. Chosen Case Study

### Use Case
**Collector Vault** adalah pengelola koleksi pribadi untuk orang yang senang mengoleksi barang fisik seperti action figure, sneaker, dan kartu koleksi. Aplikasi ini memungkinkan orang mencatat apa yang mereka miliki, melihat nilai total koleksi, dan merencanakan barang yang ingin dibeli berikutnya.

### Rumusan Masalah
orang yang mempunyai hobi mengoleksi barang sering kesulitan mengetahui barang-barang mereka:

- Data barang tersebar di catatan, chat, dan spreadsheet yang kurang nyaman dipakai di ponsel.
- Aplikasi catatan umum tidak mengenal konsep **kondisi barang**, padahal kondisi sangat memengaruhi nilai sebuah barang koleksi.
- Sulit melihat **nilai total** koleksi atau seberapa dekat koleksi dengan target pribadi.
- Barang yang ingin dibeli dicatat terpisah dari barang yang sudah dimiliki, sehingga keduanya tidak saling terhubung.

### Target Pengguna
orang yang menginginkan gambaran cepat tentang koleksi mereka lewat ponsel, serta cara sederhana untuk merencanakan pembelian berikutnya. Tidak diperlukan pengetahuan akuntansi atau teknis.

### Ringkasan Solusi
Satu aplikasi dengan empat screen:

1. **Mencatat** barang di **Vault**, lengkap dengan kategori, kondisi, nilai, dan tanggal beli.
2. **Meninjau** koleksi: nilai total, progres menuju target, dan penyaringan berdasarkan kondisi.
3. **Mencari** barang dengan cepat lewat **Search**, lalu membuka halaman **Detail**-nya.
4. **Merencanakan** pembelian di **Wishlist**, lalu memindahkan barang ke Vault setelah dibeli.

### Alasan Memilih Studi Kasus Ini
Studi kasus ini memiliki pengguna yang jelas dan mudah dipahami, struktur multi-screen yang alami, serta aliran data yang lebih dari sekadar daftar biasa: Wishlist mengisi Vault, dan Vault mengisi screen Search dan Detail. Hal ini cocok untuk melatih pengiriman state di Flutter, widget yang dapat dipakai ulang, dan desain Material 3.

---

## 2. Features Implemented
### Screen

| Screen | Fungsi |
|---|---|
| **Vault** (beranda) | Kartu ringkasan, filter kondisi, dan daftar seluruh barang koleksi. |
| **Item Detail** | Menampilkan informasi lengkap satu barang. |
| **Search** | Mencari barang berdasarkan nama atau kategori, dengan filter kondisi. |
| **Wishlist** | Barang yang ingin dibeli beserta harga target. Barang dapat ditandai sebagai sudah dibeli. |

### Fungsionalitas

- **Kartu ringkasan Vault**: nilai total koleksi, jumlah barang, dan progres menuju target (Rp 10.000.000).
- **Tambah barang**: form dalam bottom sheet untuk menambahkan barang baru ke Vault.
- **Hapus barang**: menghapus barang langsung dari daftar.
- **Filter berdasarkan kondisi**: Nice, Not Bad, Good, Fair (filter chip).
- **Detail barang**: kategori, kondisi, nilai, dan tanggal beli.
- **Pencarian**: pencarian langsung (live) berdasarkan nama atau kategori tanpa membedakan huruf besar-kecil, dapat dikombinasikan dengan filter kondisi.
- **Wishlist**: menambah entri (nama, kategori, harga target), melihat total target belanja, dan menghapus entri.
- **Alur Wishlist ke Vault**: menandai barang wishlist sebagai sudah dibeli akan meminta kondisinya, menghapusnya dari wishlist, lalu menambahkannya ke Vault. Nilai total dan jumlah barang di Vault langsung diperbarui.
- **Tampilan kosong (empty state)**: pesan yang ramah saat Vault, Wishlist, atau hasil pencarian kosong.
- **Layout responsif**: dua kolom (ringkasan dan filter di kiri, daftar di kanan) pada layar lebar (700 px ke atas), dan satu kolom yang dapat digulir pada layar sempit.
- **Material 3**: `useMaterial3: true` dengan skema warna teal, serta tema terang dan gelap yang mengikuti pengaturan perangkat.

### Praktik Kualitas Kode

- Screen fitur berada di `lib/Features/Screen/`; widget yang dapat dipakai ulang berada di subfolder `Widget/`.
- Widget kecil dengan satu tujuan (`VaultItemTile`, `ConditionFilterBar`, `VaultSummaryCard`, `AddItemSheet`, `WishlistTile`, `DetailRow`) sebagai ganti satu method `build()` yang besar.
- Model data yang immutable (`VaultItem`, `WishlistItem`) dengan constructor `const`.
- Nilai kondisi yang aman secara tipe melalui enum `Condition` dan extension `label`.
- State disimpan di `VaultScreen` dan diteruskan melalui constructor dan callback (`onSubmit`, `onDelete`, `onBought`), sehingga widget turunan tetap sederhana dan dapat dipakai ulang.

## 3. Project Structure
```
lib/main.dart
lib/features/screen/vault_screen.dart
lib/features/screen/item_detail_screen.dart
lib/features/screen/search_screen.dart
lib/features/screen/wishlist_screen.dart
lib/features/screen/widget
lib/features/screen/widget/vault_item.dart
lib/features/screen/widget/wishlist_item.dart
lib/features/screen/widget/add_item_sheet.dart
lib/features/screen/widget/condition_filter_bar.dart
lib/features/screen/widget/vault_item_tile.dart
lib/features/screen/widget/vault_summary_card.dart
lib/features/screen/widget/wishlist_tile.dart
lib/features/screen/widget/detail_row.dart
```
---

## 5. Setup Instructions

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (stable channel, Dart 3 or newer)
- A device, emulator, or Chrome for running the app
- VS Code or Android Studio with the Flutter plugin

Check your setup:

```bash
flutter doctor
```

### Run the app

```bash
# 1. Clone the repository
git clone <your-repository-url>
cd week04

# 2. Install dependencies
flutter pub get

# 3. Run (pick a device when prompted)
flutter run
```

To run on Chrome:

```bash
flutter run -d chrome
```

### Run the tests

```bash
flutter test
```

### Build a release APK (Android)

```bash
flutter build apk --release
```

The APK is generated at:

```
build/app/outputs/flutter-apk/app-release.apk
```

---

## 6. Keterbatasan

- Data tidak dimasukkan ke database sehingga ketika aplikasi ditutup data akan berubah kembali seperti diawal.
- Target koleksi (Rp 10.000.000) adalah nilai tetap di dalam kode.
- Barang tidak dapat diedit setelah dibuat.

## 7. Rencana Pengembangan

- Menyimpan database (misalnya dengan `shared_preferences` atau `sqflite`).
- Membuat target koleksi yang dapat diatur oleh pengguna.
- Menambahkan fitur edit barang dan lampiran foto.
- Menambahkan filter rentang harga dan tanggal beli pada pencarian.

---
