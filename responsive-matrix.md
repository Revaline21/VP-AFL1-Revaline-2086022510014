# Responsive Matrix - Week 04

Layar yang diuji: Collector Vault (`VaultScreen`). Hasil akhir: `flutter test test/week04_test.dart` menghasilkan 17 kasus lulus (All tests passed).

## Matriks screen × test

| Screen | Small phone (320 dp) | Large phone (430 dp) | Tablet (800 dp) | Landscape | Long text | Empty state | Long list | Keyboard | Dark mode | Notch dan gesture bar |
|---|---|---|---|---|---|---|---|---|---|---|
| Collector Vault | Pass | Pass | Pass | Pass | Pass | Pass | Pass | Pass | Pass | Pass |

## Detail per test

| Test | Hasil | Masalah awal | Perbaikan |
|---|---|---|---|
| Small phone (320 dp) | Pass | Tidak ada kegagalan di test. Nama item dan chip filter berpotensi melebihi lebar layar sempit. | Pencegahan: `maxLines` dan `overflow: TextOverflow.ellipsis` pada nama item. Chip filter dibungkus `SingleChildScrollView` horizontal. |
| Large phone (430 dp) | Pass | Tidak ada masalah. | Tidak perlu perbaikan khusus. Layout tetap satu kolom karena lebar masih di bawah 700 dp. |
| Tablet (800 dp) | Pass | Tampilan hanya melebar mengikuti layar, struktur tidak berubah. | `LayoutBuilder` dengan breakpoint 700 dp: di bawahnya satu kolom (`CustomScrollView`), di atasnya dua panel (summary dan filter di kiri, daftar item di kanan). |
| Landscape | Pass | Test gagal: `RenderFlex overflowed by 148 pixels on the bottom` karena `Column` dengan `Expanded` tidak muat di tinggi landscape. | Body diganti `CustomScrollView` dengan sliver (`SliverToBoxAdapter` dan `SliverList.builder`). |
| Long text (200 karakter) | Pass | Nama panjang berpotensi overflow horizontal di tile. | `maxLines` dan `overflow: TextOverflow.ellipsis` pada nama item. |
| Empty state (0 item) | Pass | Hanya teks "Belum ada item." tanpa ikon dan aksi. `VaultScreen` juga tidak menerima data dari luar. | Method `_emptyState()` berisi ikon, pesan, dan tombol "Tambah item pertama", dengan `Key('empty-state')`. Ditambah parameter `initialItems`. |
| Long list (500 item) | Pass | Layar memakai 3 item hardcoded sehingga daftar besar tidak pernah teruji. | `initialItems` diteruskan dari `VaultApp`. Daftar memakai `.builder` tanpa `shrinkWrap`, item yang dibangun kurang dari 100. |
| Keyboard | Pass | Form `AddItemSheet` tidak bisa di-scroll, berisiko overflow saat keyboard terbuka. | `Column` dibungkus `SingleChildScrollView`, padding bawah mengikuti `viewInsets.bottom`. |
| Dark mode | Pass | Tidak ada kegagalan layout. | Warna memakai `Theme.of(context).colorScheme`, kontras dicek manual. |
| Notch dan gesture bar | Pass | Tidak ada masalah. | Konten berada di dalam `Scaffold` yang menangani inset. |