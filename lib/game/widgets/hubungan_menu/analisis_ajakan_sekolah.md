# Analisis Persentase Ajakan Romantis di Lingkungan Sekolah

Dokumen ini menganalisis logika, mekanisme pencocokan, serta peluang (persentase) munculnya ajakan pacaran/bercinta di lingkungan sekolah (kelas, kampus, guru, dosen, dan rekan idol).

---

## 1. NPC Sekolah yang Mengajak User (Inisiasi oleh NPC)
Logika ini dikelola di [ajakan_handler.dart](file:///c:/utama/project/project-sendiri/bitlife/lib/game/widgets/hubungan_menu/ajakan_pacaran_makelove/ajakan_handler.dart).

### A. Penyaringan & Kecocokan Orientasi Seksual
Sebelum seseorang masuk ke daftar kandidat, orientasi seksual diperiksa berdasarkan [school_sexuality_logic.dart](file:///c:/utama/project/project-sendiri/bitlife/lib/game/widgets/hubungan_menu/school_sexuality/school_sexuality_logic.dart):
*   **Siswa/Teman Sekelas & Teman Kuliah**:
    *   Laki-laki: 70% Heteroseksual, 15% Biseksual, 15% Gay.
    *   Perempuan: 70% Heteroseksual, 15% Biseksual, 15% Lesbian.
*   **Guru & Dosen**:
    *   Laki-laki: 80% Heteroseksual, 10% Biseksual, 10% Gay.
    *   Perempuan: 70% Heteroseksual, 15% Biseksual, 15% Lesbian.

#### Dampak bagi Karakter Laki-laki vs Perempuan:
*   **Laki-laki**: Peluang kecocokan dengan kandidat laki-laki **30%** (Gay/Bi), sedangkan dengan perempuan **85%** (Straight/Bi).
*   **Perempuan**: Peluang kecocokan dengan kandidat perempuan **30%** (Lesbian/Bi), sedangkan dengan laki-laki **85%** (Straight/Bi).

### B. Peluang Ajakan dari NPC Sekolah
Game menentukan tipe ajakan: **70% Ajak Pacaran** vs **30% Bercinta**.

#### 1. Persentase Ajakan Pacaran:
*   **Lawan Jenis (Straight)**:
    *   Umur 6-10: bertahap naik dari **5% ke 25%**
    *   Umur 11: **35%** | Umur 12: **40%** | Umur 13: **45%** | Umur 14: **50%** | Umur $\ge$ 15: **55%** (Berdasarkan [siswa_siswi_proposal_chance.dart](file:///c:/utama/project/project-sendiri/bitlife/lib/game/widgets/hubungan_menu/school_sexuality/siswa_siswi/siswa_siswi_proposal_chance.dart))
*   **Sesama Jenis (Gay/Lesbian)**:
    *   Umur 6-10: bertahap naik dari **5% ke 25%**
    *   Umur 11: **30%** | Umur 12: **35%** | Umur 13: **40%** | Umur 14: **45%** | Umur $\ge$ 15: **50%** (Berdasarkan [siswa_siswa_proposal_chance.dart](file:///c:/utama/project/project-sendiri/bitlife/lib/game/widgets/hubungan_menu/school_sexuality/siswa_siswa/siswa_siswa_proposal_chance.dart))

#### 2. Persentase Ajakan Bercinta:
*   **Straight & Gay/Lesbian memiliki peluang yang sama**:
    *   Umur 6: **3%** | Umur 7: **7%** | Umur 8: **15%** | Umur 9: **18%** | Umur 10: **23%**
    *   Umur 11: **30%** | Umur 12: **35%** | Umur 13: **40%** | Umur 14: **45%** | Umur $\ge$ 15: **50%**

---

## 2. User yang Mengajak NPC Sekolah (Inisiasi oleh Player)
Peluang keberhasilan saat player mengajak guru/teman sekelas:

### A. Antar Siswa (Siswa-Siswi / Lawan Jenis / Straight)
Diatur di [student_romance_logic.dart](file:///c:/utama/project/project-sendiri/bitlife/lib/game/widgets/hubungan_menu/school_sexuality/siswa_siswi/student_romance_logic.dart):
*   **Ajak Pacaran**: Peluang Sukses = **Nilai Hubungan (`rel`)**.
    *   *Catatan*: Jika seksualitas target tidak cocok, otomatis langsung ditolak (0%).
*   **Bercinta (Make Love)**: Peluang Sukses = **`rel - 20`** (jika sudah pacaran) atau **`rel - 45`** (jika belum pacaran).
    *   *Kehamilan*: Jika bercinta sukses dengan lawan jenis, ada **20% peluang kehamilan**.

### B. Antar Siswa (Sesama Jenis / Gay / Lesbian)
Diatur di [siswa_siswa_logic.dart](file:///c:/utama/project/project-sendiri/bitlife/lib/game/widgets/hubungan_menu/school_sexuality/siswa_siswa/siswa_siswa_logic.dart):
*   **Ajak Pacaran (Gay)**: Peluang Sukses = **`(10 + rel) ~/ 2`**.
*   **Bercinta (Gay)**: Peluang Sukses = **`rel - 20`** (jika sudah pacaran) atau **`rel - 50`** (jika belum pacaran).

### C. Siswa Mengajak Guru Laki-laki / Perempuan
Diatur di [guru_laki_siswi_logic.dart](file:///c:/utama/project/project-sendiri/bitlife/lib/game/widgets/hubungan_menu/school_sexuality/guru_laki_siswi/guru_laki_siswi_logic.dart) dan [guru_laki_siswa_laki_logic.dart](file:///c:/utama/project/project-sendiri/bitlife/lib/game/widgets/hubungan_menu/school_sexuality/guru_laki_siswa_laki/guru_laki_siswa_laki_logic.dart):
*   **Guru Laki-laki ke Siswi Perempuan**:
    *   *Ajak Pacaran*: Peluang Sukses = **`(65 + rel) ~/ 2`**.
    *   *Bercinta*: Peluang Sukses = **`rel - 20`** (jika pacar) atau **`rel - 40`** (jika bukan). Ada **20% peluang kehamilan** jika user perempuan.
*   **Guru Laki-laki ke Siswa Laki-laki (Gay)**:
    *   *Ajak Pacaran*: Peluang Sukses = **`(10 + rel) ~/ 2`**.
    *   *Bercinta*: Peluang Sukses = **`rel - 30`** (jika pacar) atau **`rel - 60`** (jika bukan).
