Sistem Penyakit Instan
Sistem ini bekerja sangat sederhana: di setiap pergantian tahun, ada kemungkinan user terkena penyakit. Jika terkena, kesehatan langsung berkurang sesuai jenis penyakitnya. Setelah tahun itu berganti, status penyakit dianggap hilang (tidak ada efek sisa berupa durasi), tetapi penurunan kesehatan yang sudah terjadi tetap permanen sampai user melakukan aktivitas pemulihan.

1. Cara Menghitung Peluang Sakit
Peluang seorang user terkena penyakit dihitung berbanding terbalik dengan persentase Kesehatan yang tertera di menu awal. Semakin tinggi kesehatan, semakin kecil peluang sakit. Semakin rendah kesehatan, semakin besar peluang sakit.

Rumus yang digunakan adalah:

text
Peluang Sakit (%) = (100 - Kesehatan_Saat_Ini) + 5
Contoh untuk kondisi Aqila sekarang dengan Kesehatan 64%:

Peluang Sakit = (100 - 64) + 5 = 36 + 5 = 41%

Artinya setiap tahun, Aqila memiliki 41% kemungkinan untuk terserang penyakit.

Beberapa contoh patokan tanpa tabel:

Jika Kesehatan 100%, peluang sakit hanya 5% (hampir pasti sehat).

Jika Kesehatan 80%, peluang sakit menjadi 25%.

Jika Kesehatan 50%, peluang sakit menjadi 55%.

Jika Kesehatan 30%, peluang sakit menjadi 75%.

Jika Kesehatan 10%, peluang sakit menjadi 95% (hampir pasti sakit setiap tahun).

2. Daftar Penyakit Berdasarkan Tingkat Keparahan
Semua penyakit bersifat instan, tidak ada durasi, dan tidak ada syarat sembuh. Damage yang diberikan adalah angka acak di dalam rentang yang sudah ditentukan.

Penyakit Ringan (Damage 1% sampai 5%)
Kelompok ini berisi penyakit sehari-hari yang tidak terlalu berbahaya. Contohnya:

Flu ringan (damage 1–3%)

Sakit kepala atau migrain ringan (damage 1–2%)

Batuk berdahak (damage 2–4%)

Alergi musiman (damage 1–3%)

Sakit gigi ringan (damage 2–5%)

Pusing atau vertigo ringan (damage 1–3%)

Diare ringan (damage 2–4%)

Penyakit Sedang (Damage 6% sampai 15%)
Kelompok ini adalah penyakit yang cukup serius dan membutuhkan perhatian medis, tetapi masih dalam tahap yang bisa ditangani. Contohnya:

Tipes atau demam tifoid (damage 8–12%)

Demam Berdarah Dengue (DBD) ringan (damage 10–15%)

Radang paru-paru atau pneumonia ringan (damage 8–13%)

Hepatitis A (damage 7–12%)

Infeksi saluran kemih atau ISK (damage 6–10%)

Disentri atau diare berdarah (damage 9–14%)

Radang usus buntu atau apendisitis (damage 10–15%)

Penyakit Berat (Damage 16% sampai 30%)
Kelompok ini adalah penyakit yang mengancam jiwa dan dapat menyebabkan kesehatan merosot drastis hingga ke titik kritis. Contohnya:

Pneumonia berat (damage 18–25%)

Stroke ringan (damage 20–28%)

Serangan jantung ringan (damage 18–25%)

Gagal ginjal akut (damage 20–30%)

Kanker stadium awal (damage 22–30%)

Meningitis atau radang selaput otak (damage 20–28%)

Tuberkulosis (TBC) aktif (damage 18–25%)

Pankreatitis akut (damage 16–22%)

3. Logika Penentuan Jenis Penyakit Berdasarkan Kesehatan Saat Ini
Setelah dadu peluang menunjukkan bahwa user terkena penyakit, langkah berikutnya adalah menentukan tingkat keparahan penyakit yang akan menimpa user. Penentuan ini bergantung pada angka Kesehatan user saat itu juga.

Aturan keparahannya adalah sebagai berikut:

Jika Kesehatan saat ini berada di angka 70% ke atas
Maka peluangnya adalah 70% mendapatkan penyakit ringan, dan 30% mendapatkan penyakit sedang. Tidak ada kemungkinan terkena penyakit berat sama sekali pada level kesehatan ini.

Jika Kesehatan saat ini berada di antara 40% sampai 69% (ini adalah posisi Aqila dengan 64%)
Maka peluangnya adalah 30% penyakit ringan, 50% penyakit sedang, dan 20% penyakit berat. Pada rentang ini, risiko penyakit berat sudah mulai muncul.

Jika Kesehatan saat ini berada di bawah 40%
Maka peluangnya adalah 0% untuk penyakit ringan, 20% untuk penyakit sedang, dan 80% untuk penyakit berat. Di kondisi ini, tubuh sudah sangat rentan dan hampir pasti akan terkena penyakit yang mematikan jika tidak segera dipulihkan.