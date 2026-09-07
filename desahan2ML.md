Karena kamu baru saja mengunggah sistem Visual Novel (`vn_dialogue_overlay.dart`) dengan `VNBackgroundType.bedroom`, saya akan mengulang dan **menyesuaikan ide dialog ini secara langsung ke struktur engine kamu**.

**Aturan Emas (Penting untuk Publikasi):** Jangan pernah menampilkan gambar atau teks yang terlalu vulgar (alat kelamin, tindakan fisik detail). Gunakan teknik **"Fade to Black"** (layar hitam) dan fokus pada *suasana, emosi, napas, dan efek suara (onomatope)*. Ini adalah standar Visual Novel 18+ yang aman untuk Play Store/App Store.

Berikut adalah ide dialog desahan dan rintihan yang bisa langsung kamu masukkan ke dalam `List<VNDialogueNode>`:

### Tahap 1: Foreplay & Sentuhan Awal (Suasana Romantis)
*Background: Bedroom (Kamar Tidur) dengan cahaya redup.*

*   **NPC (Pemalu):** "Mmh... ah... s-sentuh aku di sana... pelan-pelan..." *(Ekspresi: Malu, muka merah)*
*   **NPC (Ekstrovert):** "Hah! Ya, tepat di sana! Jangan berhenti!" *(Ekspresi: Senang/Gairah)*
*   **NPC (Baik Hati):** "Ahh... kamu nyaman? Hah... aku ingin kamu bahagia..." *(Ekspresi: Lembut)*
*   **Player (Narasi):** "Detak jantung kalian mulai menyatu. Kamu mencium lehernya dan merasakan tubuhnya bergetar."
*   **Suara (Onomatope):** *"Hah... hah... ahh..."* (Ditampilkan sebagai teks besar dengan efek bergetar di layar).

### Tahap 2: Momen Puncak (Intensitas Meningkat)
*Di sinilah layar mulai "Fade to Black" (layar berubah menjadi hitam pekat) dan kamu hanya menampilkan suara.*

*   **NPC (Temperamen/Gairah):** "Ahhhhh...! Jangan berhenti... ugh...!" *(Napas tersengal)*
*   **NPC (Pemalu):** "Ah... ah... a-aku tidak bisa berpikir... hah... [Nama Player]..." *(Suara gemetar)*
*   **NPC (Ekstrovert):** "Ahh! Ya, di sana! Aku... ahhh...!" *(Sangat vokal)*
*   **Pilihan untuk Pemain:**
    *   *[Pilihan 1: Biarkan Dia Memimpin]* -> "Ahh... hentakanmu... ah... aku suka..." (Menambah Hubungan +15)
    *   *[Pilihan 2: Ganti Posisi]* -> "Tunggu... biarkan aku yang di atas... hah..." (Menambah Tekad +10)
*   **Narasi Layar Hitam:** *(Lampu kamar berkedip dan meredup. Tubuh kalian saling merapat di bawah selimut. Hanya suara napas dan rintihan yang saling bersahutan...)*

### Tahap 3: Pasca Climax (Aftercare & Kehangatan)
*Napas mulai mereda, muncul bisikan-bisikan sayang.*

*   **NPC (Pemalu):** "Hah... hah... m-merasa malu sekali... jangan lihat aku terus..." *(Sambil menutupi wajah)*
*   **NPC (Ekstrovert):** "Hah... itu luar biasa. Aku tidak sabar mengulanginya lagi..." *(Tersenyum lebar)*
*   **Player:** "Kamu cantik banget malam ini. Istirahat dulu, ya... hah..."
*   **Narasi Akhir:** "Kamu merasakan kehangatan tubuhnya di sampingmu. Kebahagiaanmu meningkat drastis."

---

### 💡 Implementasi Langsung di `VNDialogueOverlay` (Dart)
Kamu bisa memanfaatkan `VNDialogueNode` untuk skrip di atas. Berikut contoh kodenya:

```dart
List<VNDialogueNode> buildMakeLoveScene(Character player, Map<String, dynamic> npc) {
  return [
    VNDialogueNode(
      speakerName: player.name,
      dialogueText: "Malam ini... kita berdua saja.",
      background: VNBackgroundType.bedroom,
      isPlayerSpeaking: true,
      emotion: VNEmotionType.neutral,
    ),
    VNDialogueNode(
      speakerName: npc['name'] ?? 'Pasangan',
      dialogueText: "Hah... kamu yakin? Hah... aku ingin kamu...",
      background: VNBackgroundType.bedroom,
      isPlayerSpeaking: false,
      emotion: VNEmotionType.blush, // atau 'flustered'
    ),
    VNDialogueNode(
      speakerName: player.name,
      dialogueText: "Kita pakai pengaman ya, biar aman.",
      background: VNBackgroundType.bedroom,
      isPlayerSpeaking: true,
      choices: [
        VNChoiceOption(
          text: "Berhenti sejenak untuk berpelukan 💞",
          onSelect: (p, n) {
             // Kode menaikkan hubungan
          },
        ),
        VNChoiceOption(
          text: "Lanjutkan momen panas 🔥",
          onSelect: (p, n) {
             // Kode memicu scene berikutnya
          },
        ),
      ],
    ),
    VNDialogueNode(
      speakerName: npc['name'] ?? 'Pasangan',
      dialogueText: "Ahh... ahh... jangan berhenti... [Nama Player]... ahhhhh...!",
      background: VNBackgroundType.bedroom,
      isPlayerSpeaking: false,
      emotion: VNEmotionType.passion, // Tambahkan emosi 'passion' jika ada
    ),
    // Fade to Black - Cukup tampilkan teks narasi tanpa karakter
    VNDialogueNode(
      speakerName: "Narasi",
      dialogueText: "(Lampu kamar meredup... Hanya desahan dan rintihan yang terdengar di malam itu...)",
      background: VNBackgroundType.bedroom,
      isPlayerSpeaking: false,
    ),
    VNDialogueNode(
      speakerName: npc['name'] ?? 'Pasangan',
      dialogueText: "Hah... hah... kamu... luar biasa...",
      background: VNBackgroundType.bedroom,
      isPlayerSpeaking: false,
    ),
  ];
}
```

*Catatan:* Pada bagian `VNDialogueNode`, pastikan kamu memiliki properti `emotion` (seperti `lust`, `blush`, `passion` atau `pleasure`) di dalam file `vn_dialogue_models.dart` kamu agar ekspresi karakter di `VNCharacterView` bisa berubah mengikuti intensitas adegan! (Contoh: Karakter Pemalu akan terlihat sangat merah dan menunduk, sedangkan Ekstrovert akan terlihat sangat percaya diri).