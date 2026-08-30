Untuk skenario **"Orang tua mengajak keluar negeri saat user belum berusia 17 tahun dan belum punya paspor"**, Anda perlu membuat **alur logika khusus (Event-based)** yang melewati batasan usia individu, karena perjalanan tersebut bukan inisiatif mandiri user, melainkan tanggung jawab orang tua/wali.

Berikut adalah usulan alur logika (pseudo-code/flowchart) yang bisa diterapkan:

### Alur Logika (Pseudo-code)

**1. Trigger (Pemicu Acara)**
*   Sistem mendeteksi adanya event khusus: `OrangTua_Mengajak_Ke_Luar_Negeri`

**2. Kondisi Awal (Cek Status)**
*   `Cek Usia User` -> Apakah `User_Age < 17`? 
    *   **Jika Ya**: Lanjut ke Cek Paspor.
    *   **Jika Tidak**: Buka menu Imigrasi biasa (user bisa mengurus sendiri).

**3. Cek Paspor**
*   `Cek Status_Paspor_User` -> Apakah `User_Has_Passport == False`?
    *   **Jika Ya** (Belum punya): Munculkan Pop-up "Akses Dibatasi" (seperti di gambar).
    *   **Jika Tidak** (Sudah punya): Perjalanan berhasil, langsung pindah ke lokasi.

**4. Penanganan Pop-up "Akses Dibatasi" (Solusi Logis)**
Saat pop-up muncul, tombol "Pergi ke Lisensi" tidak akan berfungsi karena umur belum cukup. Maka, sistem harus memunculkan **Opsi Ketiga** atau tombol baru: **"Minta Orang Tua Menguruskan"** atau **"Ikuti Orang Tua"**.
*   **Jika User Memilih "Mengerti" / Menutup Pop-up**: Batalkan event perjalanan, user tetap di rumah.
*   **Jika User Memilih "Minta Orang Tua Menguruskan"**:
    *   `Cek Status_Paspor_OrangTua` -> Apakah Orang Tua punya paspor?
        *   **Jika Orang Tua Tidak Punya**: Munculkan notifikasi baru: "Orang tuamu juga belum punya paspor! Perjalanan dibatalkan." (User harus menyuruh orang tua mengurus paspor dulu di menu terpisah).
        *   **Jika Orang Tua Punya Paspor**: Sistem memproses pembuatan **Paspor Anak / Surat Perjalanan Anak**.
            *   *Potong Biaya*: Kurangi saldo uang user/keluarga (misal: Rp 350.000).
            *   *Set Status*: Ubah status `User_Has_Passport` menjadi `True` (dengan tipe "Paspor Anak (Didaftarkan oleh Orang Tua)").
            *   *Selesaikan Event*: Perjalanan ke luar negeri berhasil dilakukan. Sistem menambahkan statistik "Pengalaman Keluarga" atau sejenisnya.

---

### Rekomendasi Implementasi dalam Game/App

Agar tidak terjadi "jalan buntu" (deadlock) di usia 17 tahun, Anda bisa menambahkan aturan bahwa **"Paspor Anak"** adalah kategori yang berbeda dari "Paspor Mandiri":
1.  Menu **Imigrasi** tetap terkunci untuk kepentingan mandiri (mengurus sendiri).
2.  Namun, sistem memiliki **flag/penanda khusus** (*special flag*) untuk `Event_OrangTua_Perjalanan`. Saat flag ini aktif, sistem mengabaikan batasan usia 17 tahun dan langsung memproses pembuatan dokumen atas nama wali.
3.  **Alternatif lain (paling sederhana)**: Saat event "Orang Tua Mengajak" muncul, langsung tampilkan dialog:
    *   *"Orang tuamu siap berangkat, tapi kamu belum punya paspor. Ayah/Ibu bersedia menguruskan paspor anak untukmu. Lanjutkan?"*
    *   **Ya**: Potong uang, langsung berangkat.
    *   **Tidak**: Batal.

Dengan logika ini, aturan batasan usia 17 tahun tetap dipertahankan untuk aktivitas mandiri, namun game tetap memberikan ruang cerita (narasi) bagi user yang masih di bawah umur untuk mengikuti kegiatan orang tuanya.


===========================

persentase ajakan

Karena ini adalah desain sistem di dalam game/aplikasi, **tidak ada angka pasti yang tertulis di kode**; persentase tersebut sepenuhnya ditentukan oleh Anda (sebagai developer/desainer game) melalui *Random Number Generator (RNG)* atau logika kondisi.

Namun, jika Anda ingin membuat sistem yang realistis, persentase kemunculan event "Orang tua mengajak keluar negeri" biasanya dikelompokkan berdasarkan **variabel** yang mempengaruhinya. Berikut adalah rekomendasi persentase (probabilitas) yang umum digunakan dalam game simulasi kehidupan:

### 1. Persentase Probabilitas Kemunculan Event (Seberapa sering acara ini muncul?)
Sistem akan melakukan *roll* (lemparan dadu) setiap kali user melakukan "Tidur" atau "Ganti Hari". Jika hasilnya kurang dari persentase di bawah, maka event muncul:

*   **Usia 0 - 9 tahun:** **5% - 10%** (Anak kecil jarang diajak jauh, atau hanya jika ada acara keluarga besar).
*   **Usia 10 - 16 tahun:** **15% - 25%** (Usia paling sering diajak liburan keluarga).
*   **Usia 17 tahun ke atas:** **5%** (Sistem otomatis beralih ke event mandiri jika mereka sudah bisa mengurus paspor sendiri).

**Faktor Pengganda (Modifier):**
*   **Status Ekonomi Keluarga (Kaya/Miskin):** Jika keluarga kaya, persentase dikalikan 2 (misal jadi 30-50%). Jika miskin, dikalikan 0.2 (jadi 3-5%).
*   **Status Hubungan dengan Orang Tua (Baik/Buruk):** Jika hubungan baik, persentase naik. Jika buruk, turun drastis.

---

### 2. Persentase Biaya / Subsidi Orang Tua
Jika event ini muncul dan user memilih opsi "Minta Orang Tua Menguruskan", berapa persen biaya yang ditanggung?
*   **Biaya Paspor Anak (Ditanggung Orang Tua):** **100%** (Biasanya orang tua yang membayar karena user belum punya uang, atau dipotong dari saldo "Uang Keluarga").
*   **Biaya Tiket Pesawat/Akomodasi:** **100%** ditanggung keluarga.
*   *Bisa juga dibuat variasi:* Jika "Kekayaan Orang Tua" di bawah standar, persentase keberhasilan biaya hanya 50% (Orang tua bilang "kita belum punya uang untuk liburan tahun ini").

---

### 3. Persentase Keberhasilan Aksi
Saat pop-up "Akses Dibatasi" muncul dan user menekan tombol "Minta Orang Tua Menguruskan":
*   **Jika Orang Tua Sudah Punya Paspor:** **100% Berhasil** (Tidak ada alasan gagal, sistem langsung memproses pembuatan paspor anak dan memotong biaya).
*   **Jika Orang Tua Belum Punya Paspor:** **0% Berhasil** (Sistem akan menampilkan pesan "Liburan dibatalkan, Ayah/Ibu belum punya paspor").

---

### 💡 Saran Formula Logika (Untuk Kode Program Anda)
Jika Anda ingin membuatnya lebih dinamis, gunakan rumus seperti ini:

```
Probabilitas_Event = (Base_Chance * Usia_Modifier) * Ekonomi_Modifier * Relasi_Modifier

Contoh:
Base_Chance = 10%
Usia_Modifier (10-16 th) = 2.0 (jadi 20%)
Ekonomi (Kaya) = 1.5 (jadi 30%)
Relasi (Baik) = 1.2 (jadi 36%)
```

**Kesimpulan:** Secara *default*, saya sarankan persentase kemunculan event ini di usia anak-anak (di bawah 17) adalah sekitar **20%** per giliran waktu (agar tidak terlalu sering terasa mengganggu, tapi cukup sering untuk terasa realistis). Ini memberi rasa penasaran bagi pemain untuk menabung atau meningkatkan relasi dengan orang tua agar event ini sering muncul!