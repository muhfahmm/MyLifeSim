Menambahkan Faktor Usia ke Sistem Penyakit Tahunan
Sistem penyakit saat ini hanya mengandalkan health untuk menentukan peluang sakit dan tingkat keparahan. Untuk membuatnya lebih realistis, kita bisa menambahkan usia sebagai faktor pengali (ageFactor) yang meningkatkan peluang sakit dan kecenderungan penyakit berat seiring bertambahnya usia.

1. Konsep Dasar
Usia muda (0–17 tahun): Sistem imun masih berkembang, risiko sedang, tetapi penyakit berat jarang.

Usia dewasa (18–39 tahun): Risiko normal (baseline).

Usia paruh baya (40–59 tahun): Risiko meningkat, lebih rentan penyakit kronis.

Lansia (≥60 tahun): Risiko sangat tinggi, penyakit berat lebih mungkin terjadi.

2. Modifikasi pada PenyakitManager.checkAnnualDisease()
Kita akan menambahkan langkah-langkah berikut:

Hitung ageFactor berdasarkan usia karakter.

Modifikasi sicknessChance dengan mengalikan faktor usia (kemudian di-clamp ke 0–100).

Modifikasi distribusi keparahan – pada usia lanjut, kemungkinan penyakit berat naik, penyakit ringan turun.

4. Penjelasan Perubahan
Komponen	Sebelumnya	Setelah Modifikasi
Peluang Sakit	Hanya berdasarkan health	Dikalikan dengan ageFactor (0.7–2.0) lalu di-clamp ke 0–100
Distribusi Keparahan	Tetap berdasarkan health saja (kode lama)	Sekarang berdasarkan age + health (usia tua cenderung berat)
Threshold Keparahan	Health ≥70: 70% ringan, 30% sedang; Health <30: 40% sedang, 60% berat	Threshold berubah sesuai kelompok usia: anak-anak lebih banyak ringan, lansia lebih banyak berat
Penyesuaian Kesehatan Rendah	(tidak ada)	Jika health < 40, threshold ringan dan sedang diturunkan (berat naik)
5. Contoh Skenario
Karakter usia 10 tahun, health 80:

ageFactor = 0.7, sicknessChance dari health 80 = 15 → finalChance = 10.5 ≈ 11%.

Threshold: ringan 60, sedang 90 → hanya 10% berat.

Karakter usia 65 tahun, health 80:

ageFactor = 2.0, sicknessChance = 15 → finalChance = 30%.

Threshold: ringan 15, sedang 50 → 50% berat (karena usia tua).

Karakter usia 30 tahun, health 30:

ageFactor = 1.0, sicknessChance = 30 + (50-30)=50 → finalChance = 50%.

Threshold: ringan 50, sedang 85, tapi karena health <40, dikurangi setengah: ringan 25, sedang 60 → 40% berat.

6. Saran Tambahan (Opsional)
Faktor Gaya Hidup (misal: merokok, alkohol, olahraga) – bisa ditambahkan sebagai pengali tambahan.

Faktor Genetik – jika karakter memiliki riwayat penyakit tertentu, peluang kambuh meningkat.

Variasi Musiman – beberapa penyakit lebih umum di musim hujan (bisa ditambahkan acak).

Dengan modifikasi di atas, sistem penyakit menjadi lebih dinamis, realistis, dan menantang seiring bertambahnya usia karakter, memberikan efek jangka panjang yang lebih bermakna dalam gameplay.