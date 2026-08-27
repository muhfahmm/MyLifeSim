Ini bukan masalah di `3d_view_page.dart` — layout Transform-nya sudah jauh lebih baik dari sebelumnya (kepala, badan, lengan, kaki sudah punya depth sorting sendiri, hasilnya lebih solid). Masalah lingkaran background di kepala itu **bukan dari Flutter widget-nya, tapi dari gambar `avatarUrl` itu sendiri.**

## Root cause

```dart
Container(
  decoration: BoxDecoration(
    shape: BoxShape.circle,
    color: skinColor,   // <- ini warna Container, TIDAK PERNAH terlihat
    ...
  ),
  child: ClipOval(
    child: Image.network(
      avatarUrl,
      fit: BoxFit.cover,   // <- gambar network menutupi 100% area, termasuk background bawaannya
    ),
  ),
)
```

`ClipOval` hanya memotong bentuk gambar jadi lingkaran — dia **tidak menghapus isi piksel di dalam gambar**. Kalau gambar hasil `avatarUrl` sendiri sudah punya background (warna biru muda/putih pucat yang terlihat di Image 2), background itu ikut ter-render karena `BoxFit.cover` membuat gambar menutupi seluruh area termasuk `color: skinColor` yang kamu set di `Container`. Jadi `skinColor` di situ percuma — tidak akan pernah kelihatan selama gambar network punya background sendiri.

Ini biasanya terjadi karena `AvatarGenerator.getCharacterAvatarUrl` memanggil API avatar (kayak DiceBear, Multiavatar, dll) yang **secara default menyisipkan warna latar ke dalam gambar**, kecuali diminta transparan lewat parameter URL.

## Yang perlu dicek/diperbaiki

Saya belum punya isi `avatar_generator.dart`, jadi saya tidak bisa kasih fix pasti — tapi kemungkinan besar perbaikannya di situ, bukan di `3d_view_page.dart`. Bisa share isi file `lib/avatar/avatar_generator.dart`?

Sambil menunggu, ini pola umum tergantung API yang dipakai:Opsi pertama hampir pasti fix yang paling murah dan tepat, tapi saya perlu lihat isi `getCharacterAvatarUrl` di `avatar_generator.dart` untuk tahu API mana yang dipakai dan parameter apa yang harus ditambahkan. Bisa kirim isi filenya?