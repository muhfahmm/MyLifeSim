Ketika user menekan salah satu menu lisensi (misalnya "SIM A (Mobil)"), alur menu selanjutnya sangat bergantung pada **logika validasi** yang harus kamu bangun. Karena ini game simulasi kehidupan, prosesnya tidak boleh langsung instan (biarkan pemain merasakan "proses").

Berikut adalah saran alur menu yang bisa kamu implementasikan (mulai dari yang paling dasar):

### 1. Skenario Gagal / Validasi (Jika syarat tidak terpenuhi)
Sistem harus mengecek usia dan uang **sebelum** masuk ke proses selanjutnya. Jika gagal, gunakan *Dialog* atau *Snackbar*:
*   **Umur kurang:** `showDialog` menampilkan pesan: *"Kamu belum cukup umur. Kamu baru berumur [X] tahun. Minimal 17 tahun untuk SIM A."*
*   **Uang tidak cukup:** Muncul dialog: *"Uang kamu tidak cukup! Harga lisensi $500.000, saldo kamu hanya $[Saldo]."*
*   **Sudah dimiliki:** Jika user sudah punya SIM A, tombol akan berubah menjadi teks hijau "Sudah Dimiliki" / "Aktif", dan jika dipencet, muncul pesan: *"Kamu sudah memiliki lisensi ini."*
*   **Lisensi Terkunci (Lisensi Pilot dengan ikon gembok):** Jika diklik, muncul pesan: *"Lisensi ini terkunci. Kamu membutuhkan [Kecerdasan 80+] dan Umur 21 tahun untuk membukanya."* (Ini memanfaatkan sistem atribut yang sudah kamu buat!).

### 2. Alur Utama (Jika syarat terpenuhi)
Jika validasi lolos, kamu bisa memilih salah satu dari 3 gaya alur berikut, tergantung seberapa kompleks game yang kamu inginkan:

#### Opsi A: Sistem Ujian / Kuis (Paling Seru & Interaktif)
User diarahkan ke halaman baru (atau dialog) berjudul **"Ujian Teori [Nama Lisensi]"**. 
*   Muncul 3-5 pertanyaan pilihan ganda tentang rambu lalu lintas atau aturan kendaraan.
*   Nilai kelulusan ditentukan oleh **Kecerdasan** dan **Disiplin** karakter kamu. (Misal: Jika Kecerdasan < 40, pertanyaannya lebih sulit atau peluang lulus lebih kecil).
*   Jika lulus: Lanjut ke dialog pembayaran biaya lisensi.
*   Jika gagal: Uang hangus (atau harus bayar lagi), dan muncul pesan *"Kamu gagal ujian. Coba lagi tahun depan!"*

#### Opsi B: Event Teks Acak (Gaya Klasik BitLife)
Ini adalah alur yang paling sering dipakai di BitLife. Setelah menekan menu, muncul *bottom sheet* atau *dialog* berisi rangkaian teks:
1.  **Dialog 1:** *"Kamu mendaftar untuk ujian SIM A. Biaya $500.000. Lanjutkan?"* (Tombol: Ya / Tidak).
2.  **Dialog 2:** Muncul *loading* kecil atau langsung teks: *"Kamu mengikuti tes praktik mengemudi..."*
3.  **Dialog 3 (Hasil):** 
    *   *Sukses:* "Selamat! Kamu lulus ujian dan resmi memiliki SIM A!" -> Uang dipotong.
    *   *Gagal:* "Kamu menabrak tiang saat ujian praktik! Kamu gagal dan harus mengulang tahun depan." -> Uang tetap terpotong atau ada biaya tambahan.

#### Opsi C: Konfirmasi Instan (Paling Simpel untuk Prototipe)
Muncul dialog konfirmasi standar:
*   *"Apakah kamu yakin ingin membeli SIM A seharga $500.000?"* (Tombol: Batal / Bayar).
*   Jika "Bayar" ditekan, langsung potong uang, muncul animasi loading sesaat, lalu muncul dialog *"Selamat! Lisensi kamu aktif."*

---

### 💡 Saran Implementasi Teknis di Flutter:
Karena kamu sudah punya fungsi `_PurchaseSimulationDialog` yang bagus, kamu bisa mengembangkannya.

*   Jika memilih **Opsi B**, kamu bisa membuat `Navigator.push` ke halaman baru (`LicenseProcessPage`) atau menggunakan `showModalBottomSheet` untuk menampilkan "ujian" tersebut secara bertahap (step-by-step).
*   Pastikan untuk **menambahkan properti `List<String> ownedLicenses`** di dalam class `Character` kamu. Ketika lisensi berhasil dibeli, tambahkan nama lisensi ke list tersebut. 
*   **Efek lanjutan:** Jangan lupa simpan logika atribut. Setelah punya SIM A, user harus bisa membeli Mobil di Toko. Setelah punya Paspor, user harus bisa membuka menu "Perjalanan ke Luar Negeri" di halaman utama. Inilah yang membuat game terasa hidup!