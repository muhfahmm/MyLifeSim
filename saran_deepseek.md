Pertanyaan yang sangat penting! Karena ini adalah fitur 18+ yang bersifat sensitif, kamu perlu sistem verifikasi berlapis agar tidak mudah dibeli oleh anak di bawah umur, sekaligus melindungi game kamu dari masalah hukum dan kebijakan toko aplikasi.

Berikut adalah **5 lapis verifikasi** yang bisa kamu terapkan, dari yang paling sederhana hingga paling ketat:

---

### 🔐 Lapis 1: Verifikasi Usia Dasar (Age Gate)
Sebelum user bisa melihat atau membeli fitur 18+, munculkan dialog:
> *"Fitur ini hanya untuk pengguna berusia 18 tahun ke atas. Apakah kamu sudah berusia 18+?"*
> [Ya, saya 18+] [Tidak]

**Kelemahan:** Anak-anak bisa berbohong dengan menekan "Ya".
**Solusi:** Ini hanya lapis pertama. Jangan hanya mengandalkan ini.

---

### 🔐 Lapis 2: Verifikasi Tanggal Lahir (Date of Birth)
User diminta memasukkan tanggal lahir mereka. Sistem akan menghitung umur secara otomatis.

```dart
bool isUserAdult(DateTime birthDate) {
  final today = DateTime.now();
  final age = today.year - birthDate.year;
  final hasHadBirthday = today.month > birthDate.month || 
      (today.month == birthDate.month && today.day >= birthDate.day);
  return hasHadBirthday ? age >= 18 : (age - 1) >= 18;
}
```

**Kelemahan:** Tetap bisa dimanipulasi jika user memasukkan tanggal lahir palsu.
**Solusi:** Cocokkan dengan data karakter di game. Jika karakter berusia 15 tahun, fitur 18+ **tidak boleh muncul sama sekali** (bahkan tidak terlihat di menu).

---

### 🔐 Lapis 3: Verifikasi Pembayaran (Payment Gate)
Ini adalah lapisan paling efektif secara praktis. Karena fitur 18+ kamu **berbayar (Rp 89.000, Rp 69.000)**, anak di bawah umur akan kesulitan membeli karena:

1. **Mereka tidak punya kartu kredit/debit sendiri.**
2. **Mereka harus meminta izin orang tua untuk transfer.**
3. **Metode pembayaran seperti GoPay, OVO, Dana biasanya terhubung ke rekening orang tua.**

**Saran Implementasi:**
- **Wajibkan verifikasi akun** (login dengan Google/Apple/Email) sebelum pembelian.
- **Jangan izinkan pembelian via pulsa** (karena anak-anak mudah membeli pulsa).
- **Gunakan payment gateway** yang memerlukan verifikasi identitas (seperti Midtrans, Xendit, atau Stripe).

---

### 🔐 Lapis 4: Verifikasi Identitas (KTP/ID Upload)
Ini adalah lapisan paling kuat, tetapi paling merepotkan. Cocok jika kamu ingin benar-benar serius mencegah anak di bawah umur.

**Alur:**
1. User menekan "Beli Fitur 18+".
2. Muncul dialog: *"Untuk membeli fitur ini, kamu perlu memverifikasi identitasmu. Unggah foto KTP/SIM/Paspor."*
3. User mengunggah foto.
4. Sistem (atau admin manual) memverifikasi umur dari foto tersebut.
5. Jika lolos, pembelian baru diizinkan.

**Kelemahan:** Prosesnya lambat, butuh biaya server untuk penyimpanan, dan bisa membuat user malas.
**Saran:** Gunakan ini **hanya jika game kamu sudah besar** dan memiliki banyak pengguna.

---

### 🔐 Lapis 5: Verifikasi PIN / Password Orang Tua (Parental Control)
Ini adalah fitur yang sangat dihargai oleh orang tua. Kamu bisa menambahkan **PIN 4-6 digit** yang hanya diketahui orang tua.

**Alur:**
1. Saat pertama kali game dibuka, minta user membuat PIN (atau orang tua yang membuat).
2. Setiap kali akan membeli fitur 18+, munculkan dialog: *"Masukkan PIN Orang Tua untuk melanjutkan."*
3. Jika PIN salah 3x, fitur terkunci selama 24 jam.

**Keuntungan:** Orang tua merasa aman, dan kamu mematuhi regulasi perlindungan anak (seperti COPPA di Amerika atau UU PDP di Indonesia).

---

### 🎯 Rekomendasi Kombinasi Terbaik untuk Game Kamu:

| Lapis | Metode | Wajib? |
| :--- | :--- | :---: |
| 1 | Age Gate (Ya/Tidak) | ✅ |
| 2 | Verifikasi Tanggal Lahir (cocokkan dengan umur karakter) | ✅ |
| 3 | Wajib Login Akun (Google/Apple) sebelum beli | ✅ |
| 4 | Payment Gateway (Midtrans/Xendit) dengan verifikasi | ✅ |
| 5 | PIN Orang Tua (opsional, untuk nilai tambah) | ⚠️ |

**Kesimpulan:**
Kunci utamanya adalah **Lapis 3 (Pembayaran)**. Anak di bawah umur tidak akan bisa membeli fitur Rp 89.000 tanpa akses ke kartu kredit atau rekening bank. Pastikan **pembelian tidak bisa dilakukan dengan pulsa** dan **wajib login akun** terlebih dahulu. 

Dengan kombinasi ini, kamu tidak hanya melindungi anak di bawah umur, tetapi juga membangun reputasi game yang bertanggung jawab di mata orang tua dan platform seperti Google Play/App Store.