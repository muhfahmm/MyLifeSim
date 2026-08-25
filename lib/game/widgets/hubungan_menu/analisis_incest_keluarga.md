# Analisis Persentase Ajakan Romantis di Dalam Anggota Keluarga (Incest)

Dokumen ini menganalisis logika, mekanisme pencocokan, serta peluang (persentase) munculnya ajakan romantis dari atau kepada anggota keluarga sendiri (incest) berdasarkan data dari kode sumber game.

---

## 1. NPC yang Mengajak User (Inisiasi oleh Keluarga)
Jika tidak ada ajakan dari lingkungan sekolah/kerja, game akan mengecek peluang ajakan dari keluarga sendiri yang dikelola oleh [family_incest_handler.dart](file:///c:/utama/project/project-sendiri/bitlife/lib/game/widgets/hubungan_menu/ajakan_incest/family_incest_handler.dart). 

Keluarga harus berusia minimal 12 tahun untuk dapat mengajukan ajakan.

### A. Persentase Berdasarkan Hubungan Keluarga:
*   [sibling_incest_handler.dart](file:///c:/utama/project/project-sendiri/bitlife/lib/game/widgets/hubungan_menu/ajakan_incest/sibling_incest_handler.dart) (Saudara Kandung): **15%**
*   [child_incest_handler.dart](file:///c:/utama/project/project-sendiri/bitlife/lib/game/widgets/hubungan_menu/ajakan_incest/child_incest_handler.dart) (Anak Kandung): **15%**
*   [inlaw_incest_handler.dart](file:///c:/utama/project/project-sendiri/bitlife/lib/game/widgets/hubungan_menu/ajakan_incest/inlaw_incest_handler.dart) (Ayah/Ibu Mertua): **15%**
*   [extended_family_incest_handler.dart](file:///c:/utama/project/project-sendiri/bitlife/lib/game/widgets/hubungan_menu/ajakan_incest/extended_family_incest_handler.dart) (Keluarga Besar/Kakek/Nenek/Paman/Bibi): **15%** *(Kakek/Nenek hanya mengajak jika user $\ge$ 10 tahun, keluarga lain $\ge$ 12 tahun)*.
*   **Keponakan**: **10%** *(dihitung dari anak saudara kandung)*.

### B. Persentase Orang Tua Kandung & Tiri:
Peluang ini dipengaruhi oleh **gender user**, **status perceraian orang tua**, dan **hak asuh (custody)**:

*   **Jika Orang Tua Cerai (Divorced)**:
    *   *User Laki-laki + Hak Asuh Ibu*: Ibu Kandung (**30%**), Ayah Kandung (**10%**), Ayah Tiri (**5%**).
    *   *User Laki-laki + Hak Asuh Ayah*: Ibu Tiri (**25%**), Ibu Kandung (**15%**), Ayah Kandung (**5%**).
    *   *User Perempuan + Hak Asuh Ibu*: Ayah Tiri (**40%**), Ayah Kandung (**25%**), Ibu Kandung (**10%**).
    *   *User Perempuan + Hak Asuh Ayah*: Ayah Kandung (**60%**), Ibu Kandung (**10%**), Ibu Tiri (**5%**).
*   **Jika Orang Tua Lengkap / Tidak Cerai**:
    *   *User Laki-laki*: Ayah Kandung (**10%**), Ibu Kandung (**5%**).
    *   *User Perempuan*: Ayah Kandung (**25%**), Ibu Kandung (**10%**).

---

## 2. User yang Mengajak Keluarga (Inisiasi oleh Player)
Untuk ajakan pacaran gay keluarga diatur di [ajakan_pacaran_gay_keluarga.dart](file:///c:/utama/project/project-sendiri/bitlife/lib/game/widgets/hubungan_menu/ajakan_pacaran_makelove/ajakan_pacaran/gay/ajakan_pacaran_gay_keluarga.dart). Peluang keluarga menerima ajakan pacaran dari player adalah:
*   Sepupu: **35%**
*   Anak: **30%**
*   Keponakan: **30%**
*   Ayah: **10%**
*   Adik/Kakak Laki-laki: **5%**
*   Ayah Mertua: **5%**
*   Paman: **5%**
*   Kakek: **5%**
