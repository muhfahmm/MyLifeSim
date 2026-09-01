Berikut adalah daftar negara yang memiliki pembatasan akses sosial media berdasarkan regulasi dunia nyata. Anda bisa mengimplementasikannya sebagai **kondisi geografis** di dalam game, di mana fitur Sosial Media tidak dapat diakses (atau dibatasi) jika karakter lahir/berada di negara tersebut.

### 🌍 Kelompok Negara dengan Blokir Total (Akses Diblokir Selamanya)
Negara-negara ini memblokir akses ke platform sosial media global (seperti Facebook, Instagram, YouTube, dan Twitter/X) untuk seluruh penduduknya:
*   **China** (Blokir akses luar negeri seperti "Great Firewall") 
*   **Korea Utara** (Blokir total, hanya akses intranet domestik) 
*   **Iran** (Pemblokiran platform seperti Facebook, Twitter, dan YouTube) 
*   **Turkmenistan** (Blokir hampir semua platform sosial media asing) 
*   **Afghanistan** (Pembatasan ketat akses sosial media sejak 2025) 

### 👶 Kelompok Negara dengan Pembatasan Usia (Akses Diblokir Jika Karakter di Bawah 16 Tahun)
Negara-negara ini menerapkan aturan ketat, di mana anak-anak di bawah usia 16 tahun **dilarang** memiliki akun sosial media:
*   **Australia** (Efektif Desember 2025, salah satu regulasi terketat di dunia) 
*   **Indonesia** (Efektif Maret 2026, larangan untuk platform berisiko tinggi) 
*   **Malaysia** (Efektif Juni 2026) 
*   **Inggris** (Proposal larangan untuk anak di bawah 16 tahun) 
*   **Spanyol** (Proposal larangan untuk anak di bawah 16 tahun) 
*   **Turki** (Undang-undang pembatasan akses untuk anak di bawah 15 tahun) 
*   **Denmark** (Larangan untuk di bawah 15 tahun) 
*   **Prancis**, **Polandia**, **Yunani**, **Slovenia** (Proposal larangan untuk anak di bawah 15 tahun) 

### ⚖️ Kelompok Negara dengan Regulasi Ketat (Akses Diblokir Jika Berusia Terlalu Muda)
*   **Rusia** (Pemblokiran platform Meta sejak 2022) 
*   **UAE (Uni Emirat Arab)** (Batasan usia minimum 15 tahun untuk akun sosial media) 
*   **India** (Larangan untuk platform tertentu seperti TikTok, meskipun sebagian besar akses dibuka) 

---

### 💡 Saran Implementasi di Game:
1.  **Jika Karakter di Negara "Blokir Total"**: Saat menekan menu Sosial Media, muncul *pop-up* atau *modal* yang menampilkan pesan: *"Akses Sosial Media diblokir oleh pemerintah negara ini."* Hal ini membuat gameplay terasa sangat realistis.
2.  **Jika Karakter di Negara "Batasan Usia"**: Gunakan logika seperti yang sudah Anda terapkan pada fitur premium 18+. Jika `character.age < 16`, tampilkan pesan terkunci, dan jika `>= 16`, fitur tersebut terbuka normal. Ini juga memberikan alasan realistis mengapa seorang anak kecil tidak bisa bermain TikTok atau Instagram di dalam game.
3.  **Sistem Bonus vs Penalti**: Anda bisa menambahkan efek samping dari pemblokiran ini. Misalnya, di negara yang memblokir sosial media, karakter mungkin memiliki **Kebahagiaan yang sedikit lebih tinggi** (karena tidak terpengaruh *cyberbullying*), atau **Kecerdasan sedikit lebih tinggi** (karena lebih banyak membaca buku daripada *scrolling*).