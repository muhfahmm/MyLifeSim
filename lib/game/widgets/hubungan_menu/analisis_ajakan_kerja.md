# Analisis Persentase Ajakan Romantis di Lingkungan Kerja

Dokumen ini menganalisis logika, mekanisme pencocokan, serta peluang (persentase) munculnya ajakan romantis (pacaran/bercinta) dari rekan kerja (coworkers).

---

## 1. NPC Coworker Mengajak User (Inisiasi oleh NPC)
Logika di lingkungan kerja diatur di [ajakan_handler.dart](file:///c:/utama/project/project-sendiri/bitlife/lib/game/widgets/hubungan_menu/ajakan_pacaran_makelove/ajakan_handler.dart) untuk ajakan dari NPC Coworker kepada user.

Ketika kandidat terpilih adalah Rekan Kerja, persentase kemunculan proposal didasarkan pada orientasi jenis kelamin:

### A. Sesama Jenis (Gay / Lesbian)
*   **Peluang Ajak Pacaran**: **20%**
    *   Menggunakan check logic dari `AjakanPacaranGayCoworker` / `AjakanPacaranLesbianCoworker`
*   **Peluang Ajak Hubungan Intim (Bercinta)**: **10%**
    *   Menggunakan check logic dari `AjakanMlGayCoworker` / `AjakanMlLesbianCoworker`
*   **Total Peluang Terjadi Proposal**: **30%**

### B. Lawan Jenis (Straight / Heteroseksual)
*   **Peluang Ajak Pacaran**: **30%**
    *   Menggunakan check logic dari `AjakanPacaranHeteroCoworker`
*   **Peluang Ajak Hubungan Intim (Bercinta)**: **30%**
    *   Menggunakan check logic dari `AjakanMlHeteroCoworker`
*   **Total Peluang Terjadi Proposal**: **60%**

---

## 2. Faktor Pengurang (Peredam Aktivitas Proposal)
Jika user sudah memiliki pasangan lawan jenis (opposite-sex partner), game secara otomatis meredam proposal baru dari rekan kerja/pihak lain dengan peluang berikut:
*   Jika proposal baru adalah **sesama jenis (Gay/Lesbian)**: Ada peluang **90%** ajakan tersebut akan **dibatalkan/dihapus** secara otomatis.
*   Jika proposal baru adalah **lawan jenis (Straight)** dari orang baru: Ada peluang **85%** ajakan tersebut akan **dibatalkan/dihapus** secara otomatis.
