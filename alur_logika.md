1. Konsep Dasar: Nilai Kekayaan (Wealth) pada Setiap Karakter
Setiap karakter (termasuk pemain, target interaksi, keluarga, teman, pasangan, dll.) memiliki atribut wealth (nilai kekayaan) yang merepresentasikan jumlah uang yang sedang dimiliki.

Nilai ini ditampilkan di kartu profil (seperti pada gambar yang Anda kirimkan) sebagai bar atau angka, misalnya: $250.

Nilai ini dapat berubah melalui aksi-aksi tertentu (menerima uang saku, memberi uang, berdagang, bekerja, dll).

2. Logika Penentuan Nilai Kekayaan Berdasarkan Usia
Setiap karakter memiliki sumber pendapatan yang berbeda tergantung pada rentang usianya.
Untuk anak-anak dan remaja yang belum bekerja, kekayaan mereka berasal dari uang saku yang diberikan oleh orang tua.
Berikut rentang uang saku yang diterima secara periodik (misalnya setiap minggu atau setiap bulan) berdasarkan usia:

Rentang Usia	Uang Saku yang Diterima
6 – 11 tahun	$1 – $10 per periode
12 – 14 tahun	$20 – $50 per periode
15 – 18 tahun	$100 – $200 per periode
19+ tahun	Bisa bekerja, nilai kekayaan ditentukan oleh pekerjaan / simpanan
Catatan: Nilai kekayaan yang ditampilkan adalah total uang yang sedang dimiliki saat ini, bukan hanya uang saku terakhir. Jadi kita bisa menginisialisasi nilai awal misalnya berdasarkan akumulasi uang saku sejak usia 6 tahun, atau cukup dengan nilai acak dalam rentang di atas sebagai representasi kekayaan saat ini.

3. Aksi "Minta Uang" (Untuk Pemain)
Ketika pemain sedang berada di menu interaksi dengan orang tua (ayah atau ibu kandung/tiri), tersedia aksi “Minta Uang”.
Hasil dari aksi ini dipengaruhi oleh usia pemain:

Usia 6–11 → dapat uang $1 – $10

Usia 12–14 → dapat uang $20 – $50

Usia 15–18 → dapat uang $100 – $200

Alur logika aksi ini:

Pemain menekan tombol “Minta Uang”.

Sistem mengecek usia pemain saat ini.

Sistem menentukan jumlah uang acak dalam rentang sesuai usia.

Jumlah uang tersebut ditambahkan ke wealth pemain.

Muncul dialog hasil (misalnya: “Kamu menerima $25 dari Ayah”).

Aksi ini bisa dibatasi (misalnya hanya bisa dilakukan sekali per minggu dalam game) agar tidak eksploitatif.

4. Logika untuk Target yang Masih Muda (Adik/Kakak/Sepupu usia 6–18)
Ketika pemain berinteraksi dengan adik, kakak, atau sepupu yang berusia 6–18 tahun, maka:

a. Menampilkan Nilai Kekayaan Target
Nilai kekayaan target dihitung dengan logika yang sama berdasarkan usia target, yaitu menggunakan rentang uang saku di atas.

Contoh: Sepupu berusia 10 tahun → kekayaannya sekitar $1–$10 (ditampilkan di kartu profil).

Ini berlaku untuk semua orang, bukan hanya keluarga.

b. Aksi Memberi Uang
Pemain dapat memilih aksi “Memberi Uang” kepada target yang masih muda.

Syarat: Pemain harus memiliki uang cukup.

Alur:

Pemain memilih nominal yang ingin diberikan (atau sistem menentukan nominal acak).
Uang pemain berkurang.
Uang target bertambah sesuai nominal.
Hubungan dengan target bisa naik (misalnya +5 hubungan).
Muncul dialog hasil.
c. Aksi Meminta Uang dari Target?
Tidak disarankan untuk target yang lebih muda dari pemain, karena mereka bergantung pada orang tua mereka sendiri.
Namun jika target adalah kakak yang sudah bekerja (usia > 18), pemain bisa meminta uang dengan logika berbeda (misalnya berdasarkan pendapatan kakak).

5. Alur Umum Penambahan Menu "Nilai Kekayaan" pada UI
Berdasarkan gambar yang Anda berikan (kartu profil dengan “Tingkat Kepuasan” dan “Tingkat Kesuburan”), kita dapat menambahkan baris baru di bawahnya:

Label: “Nilai Kekayaan”

Bar: menampilkan uang yang dimiliki (misalnya $ 250) atau persentase jika ingin dibandingkan dengan batas tertentu.

Warna bar: hijau jika kaya (> $500), kuning jika sedang, merah jika miskin.

Kartu profil ini akan tampil untuk semua orang yang dipilih sebagai target interaksi, sehingga pemain selalu mengetahui kondisi keuangan target.

6. Ringkasan Alur Logika
Inisialisasi kekayaan setiap karakter saat game dimulai:

Untuk usia 6–18: nilai acak dalam rentang uang saku sesuai usia.

Untuk usia 19+: nilai berdasarkan pekerjaan atau simpanan yang sudah ditentukan.

Aksi “Minta Uang” (khusus untuk pemain kepada orang tua):

Tentukan rentang berdasarkan usia pemain.

Tambahkan ke kekayaan pemain.

Aksi “Memberi Uang” kepada target (termasuk adik/kakak/sepupu):

Kurangi kekayaan pemain, tambahkan ke kekayaan target, naikkan hubungan.

Penampilan nilai kekayaan di kartu profil target sebagai informasi tambahan.