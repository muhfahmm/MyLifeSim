Ide yang sangat bagus! Ini akan menambahkan dimensi realisme dan variasi yang kuat ke dalam game, karena konsekuensi hidup di Korea Selatan (18 bulan) akan sangat berbeda dengan hidup di Swiss (pria dan wanita) atau Indonesia (hanya pria, dan terkadang ada pengecualian). 

Karena kamu sudah memiliki struktur folder yang rapi, logika **Wajib Militer** paling cocok diimplementasikan sebagai **Event/Trigger saat karakter "Naik Usia" (Age Up)**, dan dihubungkan ke atribut serta kepribadian.

Berikut adalah rancangan logika dan contoh implementasinya di Dart:

### 1. Logika Dasar Trigger
Saat karakter beranjak usia (misalnya dari 17 ke 18 tahun), aplikasi harus memanggil fungsi `checkMandatoryMilitary(Character character)`.

```dart
// Di dalam logic naik usia (misal: saat tombol "Lanjutkan" ditekan)
void onAgeUp(Character character) {
    character.age++;
    
    // Cek Wajib Militer
    checkMilitaryService(character);
    
    // Refresh UI lainnya...
}
```

### 2. Definisi Negara dan Usia Wajib Militer
Kamu perlu sebuah `Map` atau class penentu. (Perlu diingat, aturan ini bisa kamu *simplify* untuk game, tidak harus 100% akurat dengan hukum real-time).

```dart
// lib/core/services/military_service.dart
const Map<String, int> militaryCountries = {
  'Indonesia': 18, // Pria
  'Korea Selatan': 18, // Pria (kurang lebih 18-21 tahun)
  'Singapura': 18, // Pria
  'Israel': 18, // Pria & Wanita
  'Swiss': 19, // Pria & Wanita
  'Norwegia': 19, // Pria & Wanita
  'Mesir': 18, // Pria
  // Sisanya bisa null atau kosong
};

void checkMilitaryService(Character character) {
  int? draftAge = militaryCountries[character.country];
  
  // Cek umur dan gender (jika negara hanya laki-laki)
  if (draftAge != null && character.age == draftAge) {
      // Jika di Indonesia/Mesir/Korsel, hanya Laki-laki
      if (character.country == 'Indonesia' || character.country == 'Korea Selatan' || character.country == 'Mesir' || character.country == 'Singapura') {
          if (character.gender == 'Laki-laki') {
              showMilitaryEventDialog(context, character);
          }
      } else {
          // Semua gender (Swiss, Israel, Norwegia)
          showMilitaryEventDialog(context, character);
      }
  }
}
```

### 3. Dialog Pilihan & Dampak Atribut (Memakai Kepribadian)
Setelah *trigger* terpanggil, kamu akan memunculkan dialog interaktif. Pilihan harus dipengaruhi oleh kepribadian (Pemberani, Pemalas, Kutu Buku, dll).

```dart
void showMilitaryEventDialog(BuildContext context, Character character) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Panggilan Wajib Militer 🪖'),
      content: Text('Pemerintah ${character.country} telah memanggilmu untuk mengikuti wajib militer. Apa yang akan kamu lakukan?'),
      actions: [
        TextButton(
          onPressed: () { 
             Navigator.pop(ctx);
             // Pilihan 1: Ikut Wajib Militer
             applyMilitaryDecision(character, 'ikut');
          },
          child: const Text('Patuh & Ikut'),
        ),
        TextButton(
          onPressed: () { 
             Navigator.pop(ctx);
             // Pilihan 2: Menghindar (Menurunkan Karma, Resiko Penjara)
             applyMilitaryDecision(character, 'menghindar');
          },
          child: const Text('Menghindar / Kabur'),
        ),
      ],
    ),
  );
}
```

### 4. Fungsi Perubahan Statistik (Logika dalam `applyMilitaryDecision`)
*Catatan: Perbedaan negara dan kepribadian akan mengubah hasilnya.*

```dart
void applyMilitaryDecision(Character character, String decision) {
  if (decision == 'ikut') {
    // Dampak umum mengikuti militer:
    character.discipline = (character.discipline + 25).clamp(0, 100);
    character.health = (character.health + 15).clamp(0, 100);
    character.money += 200; // Gaji selama dinas

    // Efek Kepribadian:
    if (character.traits.contains('Pemberani')) {
        character.happiness = (character.happiness + 20).clamp(0, 100); // Bangga
    } else if (character.traits.contains('Pemalas')) {
        character.happiness = (character.happiness - 15).clamp(0, 100); // Sengsara
    } else if (character.traits.contains('Kutu Buku')) {
        character.intelligence += 5; // Belajar hal teknis
    } else {
        character.happiness = (character.happiness + 5).clamp(0, 100);
    }
    
    // Konsekuensi jangka panjang: Membuka peluang karier militer di masa depan.
    
  } else if (decision == 'menghindar') {
    character.karma = (character.karma - 25).clamp(0, 100);
    character.happiness = (character.happiness + 10).clamp(0, 100); // Senang bebas

    // Konsekuensi random: Tertangkap dan dipenjara
    if (Random().nextInt(100) < 40) {
        character.money -= 500; // Denda
        character.health = (character.health - 10).clamp(0, 100); // Stres
        showEventOutcome('Kamu tertangkap! Kamu dipenjara selama 6 bulan.', character);
    }
  }
}
```

### 5. Koneksi ke Fitur Online
Karena kamu ingin mengimplementasikan fitur online (Lomba), logika Militer ini juga penting untuk **divalidasi di server**.
*   Jika ada pemain yang berada di Korea Selatan dan usianya 18 tahun, server harus memaksa mereka menjalani event ini.
*   Jika pemain *menghindar*, server harus mencatat penurunan Karma dan menambahkan status "Buronan" ke database akun mereka. 
*   Ini juga menciptakan cerita yang sangat berbeda: Pemain yang lulus dari militer bisa memiliki akses ke pekerjaan khusus (seperti "Tentara Bayaran" atau "Polisi Militer") dengan gaji tinggi di fitur online nanti.

**Bonus Saran:**
Untuk membuat lebih mirip BitLife, kamu bisa menambahkan pilihan ketiga: **"Alasan Medis / Pura-pura Sakit"**. Ini akan sangat bergantung pada atribut `Kesehatan` dan `Kecerdasan` (untuk memalsukan surat dokter). Jika gagal, mereka tetap dipaksa militer dan mendapatkan penalti tambahan!

Apakah kamu ingin saya buatkan file contoh lengkap untuk `military_service.dart` yang bisa langsung kamu copy-paste ke dalam proyek?

