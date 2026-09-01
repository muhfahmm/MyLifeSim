Untuk halaman ranking ini, masalah utamanya bukan di `ListView.builder`-nya (itu sudah lazy-build, bagus) — masalahnya ada di **cara data dimuat dan distrukturkan**. Kamu memuat ~4140 baris (207 negara × 10 negeri + 10 swasta) sekaligus ke satu list flat, dan proses loading-nya melakukan **ratusan `rootBundle.loadString()` terpisah** secara sequential. Itu bottleneck terbesarnya.

## 1. Restrukturisasi arsitektur halaman (paling berdampak)

Realistisnya tidak ada user yang scroll 4140 item di satu list flat. Pecah jadi 2 level:

- **Halaman 1**: daftar 207 negara (dengan bendera, jumlah univ negeri/swasta)
- **Halaman 2**: setelah tap negara → baru load 20 universitas negara itu

Ini langsung memangkas initial load dari "baca 414 file JSON" jadi "baca 1 file index kecil" (nama negara + iso + count saja), dan baru fetch detail per-negara saat dibutuhkan (on-demand).

## 2. Kalau tetap mau 1 halaman flat: gabungkan JSON di build-time

Alih-alih runtime membaca 400+ file kecil satu-satu lewat `for` loop + `await`, buat **satu file `all_universities.json` gabungan** menggunakan script (Node/Python/Dart) yang dijalankan sekali saat development, hasilnya di-bundle sebagai 1 asset:

```json
{
  "id": {"iso":"ID","negeri":["UI","UGM",...],"swasta":["BINUS","Telkom Univ",...]},
  "us": {"iso":"US","negeri":[...],"swasta":[...]},
  ...
}
```

Runtime tinggal:
```dart
final raw = await rootBundle.loadString('json/nama_unniv/all_universities.json');
final Map<String, dynamic> data = jsonDecode(raw);
```
1 file read + 1 decode, bukan 400+ read. Ini biasanya penghematan I/O terbesar.

## 3. Pindahkan parsing berat ke isolate

`jsonDecode` untuk ~4000 entri di main isolate bisa bikin jank saat startup. Pakai `compute()`:

```dart
List<Map<String, dynamic>> allUnivs = await compute(_parseUniversities, raw);
```

## 4. Precompute search key, jangan `toLowerCase()` tiap filter

Saat ini `_filterData()` memanggil `.toLowerCase()` pada `name` dan `country` setiap kali user mengetik, untuk 4140 item. Simpan versi lowercase sekali saat load:

```dart
univs.add({
  ...,
  'searchKey': '${item.toString()} $countryName'.toLowerCase(),
});
```
Filter tinggal `univ['searchKey'].contains(query)` — jauh lebih murah.

## 5. Debounce search input

`onChanged: (val) => _filterData()` men-trigger filter+`setState` (rebuild) di **setiap keystroke**. Untuk UX yang lebih halus saat mengetik cepat:

```dart
Timer? _debounce;
void _onSearchChanged(String val) {
  _debounce?.cancel();
  _debounce = Timer(const Duration(milliseconds: 250), _filterData);
}
```

## 6. Hindari rebuild seluruh Scaffold saat filter berubah

`setState` di `_filterData()` saat ini rebuild seluruh `build()` (termasuk search bar & chip filter). Bungkus list-nya dengan `ValueListenableBuilder`/`ValueNotifier<List<...>>` supaya hanya bagian `ListView` yang rebuild, bukan seluruh halaman.

---

**Ringkas prioritas:** #1 (pecah jadi 2 halaman) memberi dampak paling besar untuk UX & performa; kalau tidak memungkinkan, #2 (gabungkan JSON) adalah fix teknis paling murah untuk masalah loading lambatmu sekarang.

Mau saya bantu tuliskan versi refactor-nya, mulai dari halaman daftar negara dulu atau langsung script penggabungan JSON-nya?