# Constraint Diagnosis - Week 04

Tiga overflow sengaja dibuat di `lib/error_demo.dart`, lalu diperbaiki satu per satu. Prinsip dasarnya: constraint turun dari parent ke child, ukuran naik dari child ke parent, lalu parent menentukan posisi.

| # | Kasus | Arah overflow | Aturan constraint yang dilanggar |
|---|---|---|---|
| 1 | `Row` + teks panjang | Kanan | Lebar anak non-flex tidak dibatasi |
| 2 | `SizedBox(height: 30)` + `Column` | Bawah | Constraint tinggi ketat (tight) |
| 3 | `SizedBox(height: 200)` + `Column` 8 baris | Bawah | `Column` tidak bisa scroll |

## 1. Row + teks panjang (overflow di kanan)

**Sebelum diperbaiki**

![Overflow Row](images/overflow-row.png)

Error: `A RenderFlex overflowed by N pixels on the right.`

**Aturan yang dilanggar:** `Row` memberi anak non-flex constraint lebar tak terbatas, sehingga `Text` selebar kalimatnya dan melebihi lebar maksimum `Row` (320 dp).

**Kode rusak:**
```dart
SizedBox(
  width: 320,
  child: Row(
    children: [
      Text('Ini adalah kalimat yang sangat panjang sekali sehingga tidak muat di lebar layar'),
    ],
  ),
)
```

**Perbaikan:** bungkus `Text` dengan `Expanded` agar dibatasi oleh sisa lebar `Row`, lalu tambahkan `maxLines` dan `overflow`.
```dart
Row(
  children: [
    Expanded(
      child: Text(
        'Ini adalah kalimat yang sangat panjang sekali sehingga tidak muat di lebar layar',
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    ),
  ],
)
```

**Sesudah diperbaiki**

![Row diperbaiki](images/fixed-row.png)

## 2. SizedBox tinggi tetap + Column (overflow di bawah)

**Sebelum diperbaiki**

![Overflow SizedBox](images/overflow-sizedbox.png)

Error: `A RenderFlex overflowed by 72 pixels on the bottom.`

**Aturan yang dilanggar:** `SizedBox(height: 30)` memberi constraint tinggi yang ketat (tight), sehingga `Column` dipaksa setinggi 30 dp padahal isinya butuh sekitar 102 dp.

**Kode rusak:**
```dart
SizedBox(
  height: 30,
  child: Column(
    children: [
      Text('Baris pertama', style: TextStyle(fontSize: 24)),
      Text('Baris kedua', style: TextStyle(fontSize: 24)),
      Text('Baris ketiga', style: TextStyle(fontSize: 24)),
    ],
  ),
)
```

**Perbaikan:** ganti tinggi tetap dengan batas minimum, supaya `Column` boleh tumbuh mengikuti isinya.
```dart
ConstrainedBox(
  constraints: const BoxConstraints(minHeight: 30),
  child: const Column(
    children: [
      Text('Baris pertama', style: TextStyle(fontSize: 24)),
      Text('Baris kedua', style: TextStyle(fontSize: 24)),
      Text('Baris ketiga', style: TextStyle(fontSize: 24)),
    ],
  ),
)
```

**Sesudah diperbaiki**

![SizedBox diperbaiki](images/fixed-sizedbox.png)

## 3. Column tanpa scroll (overflow di bawah)

**Sebelum diperbaiki**

![Overflow Column](images/overflow-column.png)

Error: `A RenderFlex overflowed by N pixels on the bottom.`

**Aturan yang dilanggar:** `Column` tidak bisa di-scroll dan tingginya dibatasi 200 dp oleh parent, padahal total tinggi anaknya sekitar 376 dp, sehingga isinya meluap ke bawah.

**Kode rusak:**
```dart
SizedBox(
  height: 200,
  child: Column(
    children: [
      Text('Baris 1', style: TextStyle(fontSize: 40)),
      // ... sampai Baris 8
    ],
  ),
)
```

**Perbaikan:** ganti `Column` dengan `ListView` supaya isi yang lebih besar dari ruangnya bisa di-scroll.
```dart
SizedBox(
  height: 200,
  child: ListView(
    children: const [
      Text('Baris 1', style: TextStyle(fontSize: 40)),
      // ... sampai Baris 8
    ],
  ),
)
```

**Sesudah diperbaiki**

![Column diperbaiki](images/fixed-column.png)

## Kesimpulan

- Overflow bukan bug acak. Selalu ada constraint dari parent yang tidak cocok dengan ukuran yang diminta child.
- Tiga perbaikan berbeda untuk tiga penyebab: membatasi lebar anak (`Expanded`), melonggarkan constraint (`minHeight`), dan membuat isi bisa di-scroll (`ListView`).

## Kaitan dengan Collector Vault

Overflow 148 px pada test landscape + keyboard di `VaultScreen` berakar sama dengan kasus 3: `Column` dengan `Expanded` tidak muat di tinggi yang tersisa. Perbaikannya sama, yaitu body diganti `CustomScrollView` supaya bisa di-scroll.