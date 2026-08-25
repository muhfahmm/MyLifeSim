# Analisis Persentase Ajakan Romantis di Lingkungan Sekolah

Berikut adalah tabel data persentase dan probabilitas ajakan pacaran/bercinta di lingkungan sekolah (kelas, kampus, guru, dosen, dan rekan idol).

---

## 1. NPC Sekolah yang Mengajak User (Inisiasi oleh NPC)

### A. Pembagian Orientasi Seksual NPC Sekolah

| Tipe NPC | Gender NPC | Heteroseksual (Straight) | Biseksual | Gay / Lesbian |
| :--- | :--- | :---: | :---: | :---: |
| **Siswa / Teman** | Laki-laki | 70% | 15% | 15% |
| **Siswa / Teman** | Perempuan | 70% | 15% | 15% |
| **Guru / Dosen** | Laki-laki | 80% | 10% | 10% |
| **Guru / Dosen** | Perempuan | 70% | 15% | 15% |

### B. Peluang Kecocokan (Kandidat Lolos Seleksi)

| Gender User | Gender Kandidat | Persentase Seksualitas Lolos Seleksi | Keterangan |
| :--- | :--- | :---: | :--- |
| **Laki-laki** | Perempuan | **85%** | Lolos jika target Hetero (70%) / Bi (15%) |
| **Laki-laki** | Laki-laki | **30%** | Lolos jika target Gay (15%) / Bi (15%) |
| **Perempuan** | Laki-laki | **85%** | Lolos jika target Hetero (70%) / Bi (15%) |
| **Perempuan** | Perempuan | **30%** | Lolos jika target Lesbian (15%) / Bi (15%) |

### C. Persentase Peluang Ajakan dari NPC Sekolah Berdasarkan Usia

| Usia User | Ajak Pacaran (Straight) | Ajak Pacaran (Gay/Lesbian) | Ajakan Bercinta (Semua Seksualitas) |
| :---: | :---: | :---: | :---: |
| **6** | 5% | 5% | 3% |
| **7** | 10% | 10% | 7% |
| **8** | 15% | 15% | 15% |
| **9** | 20% | 20% | 18% |
| **10** | 25% | 25% | 23% |
| **11** | 35% | 30% | 30% |
| **12** | 40% | 35% | 35% |
| **13** | 45% | 40% | 40% |
| **14** | 50% | 45% | 45% |
| **$\ge$ 15** | 55% | 50% | 50% |

---

## 2. User yang Mengajak NPC Sekolah (Inisiasi oleh Player)

Peluang keberhasilan saat player berinisiatif mengajak guru/teman sekelas (`rel` = Nilai Bar Hubungan saat ini):

### A. Antar Siswa (Siswa-Siswi)

| Tipe Hubungan | Aksi Romantis | Rumus Peluang Keberhasilan | Keterangan |
| :--- | :--- | :---: | :--- |
| **Lawan Jenis (Straight)** | Ajak Pacaran | **`rel` %** | Gagal otomatis (0%) jika target tidak tertarik gender user |
| **Lawan Jenis (Straight)** | Bercinta (Make Love) | **`rel - 20` %** (Pacar)<br>**`rel - 45` %** (Bukan Pacar) | Ada peluang kehamilan **20%** |
| **Sesama Jenis (Gay/Lesbian)**| Ajak Pacaran | **`(10 + rel) ~/ 2` %** | - |
| **Sesama Jenis (Gay/Lesbian)**| Bercinta (Make Love) | **`rel - 20` %** (Pacar)<br>**`rel - 50` %** (Bukan Pacar) | - |

### B. Siswa Mengajak Guru Laki-laki

| Gender User (Siswa) | Aksi Romantis | Rumus Peluang Keberhasilan | Keterangan |
| :--- | :--- | :---: | :--- |
| **Perempuan (Straight)** | Ajak Pacaran | **`(65 + rel) ~/ 2` %** | - |
| **Perempuan (Straight)** | Bercinta (Make Love) | **`rel - 20` %** (Pacar)<br>**`rel - 40` %** (Bukan Pacar) | Ada peluang kehamilan **20%** |
| **Laki-laki (Gay)** | Ajak Pacaran | **`(10 + rel) ~/ 2` %** | - |
| **Laki-laki (Gay)** | Bercinta (Make Love) | **`rel - 30` %** (Pacar)<br>**`rel - 60` %** (Bukan Pacar) | - |
