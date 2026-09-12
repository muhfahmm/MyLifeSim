// lib/game/widgets/aktivitas_menu/pilih_aktivitas/hiburan/peliharaan/pet_lifespan_logic.dart
import 'dart:math';

/// Class helper yang mengatur logika usia, rentang hidup realistis,
/// dan kematian alami hewan peliharaan di MyLifeSim.
class PetLifespanLogic {
  static final Random _random = Random();

  /// Mengembalikan rentang usia hidup realistis (minLifespan - maxLifespan)
  /// berdasarkan tipe hewan peliharaan (Kucing, Anjing, Burung, Ikan, Kelinci, Reptil).
  static Map<String, int> getLifespanRange(String petType) {
    final typeLower = petType.toLowerCase().trim();
    switch (typeLower) {
      case 'kucing':
        return {'min': 12, 'max': 18};
      case 'anjing':
        return {'min': 10, 'max': 15};
      case 'burung':
        return {'min': 15, 'max': 30};
      case 'ikan':
        return {'min': 3, 'max': 8};
      case 'kelinci':
        return {'min': 8, 'max': 12};
      case 'reptil':
        return {'min': 10, 'max': 25};
      default:
        return {'min': 10, 'max': 15};
    }
  }

  /// Menghasilkan usia awal hewan saat diadopsi/dibeli (minimal 1, maksimal 3 tahun).
  static int generateInitialAge() {
    return 1 + _random.nextInt(3); // 1, 2, atau 3 tahun
  }

  /// Menghasilkan maxAge acak yang realistis saat hewan baru diadopsi/dibeli.
  static int generateMaxAge(String petType) {
    final range = getLifespanRange(petType);
    final int minAge = range['min']!;
    final int maxAge = range['max']!;
    return minAge + _random.nextInt(maxAge - minAge + 1);
  }

  /// Menjalankan siklus penambahan usia 1 tahun untuk seluruh hewan peliharaan player.
  /// Mengembalikan daftar pesan notifikasi (misalnya jika ada hewan yang meninggal karena usia tua).
  static List<String> processPetAging(List<Map<String, dynamic>> pets) {
    final List<String> notices = [];
    final List<Map<String, dynamic>> petsToRemove = [];

    for (var pet in pets) {
      // Ambil umur pet saat ini (default 0 jika belum ada)
      int currentAge = pet['age'] as int? ?? 0;
      int nextAge = currentAge + 1;
      pet['age'] = nextAge;

      // Ambil atau set batas usia maksimal pet ini
      final String petType = pet['type'] as String? ?? 'Peliharaan';
      int maxAge = pet['maxAge'] as int? ?? generateMaxAge(petType);
      pet['maxAge'] = maxAge;

      final String petName = pet['name'] as String? ?? 'Peliharaan';
      final String breed = pet['breed'] as String? ?? '';
      final String emoji = pet['emoji'] as String? ?? '🐾';

      // Cek kelayakan bertahan hidup
      bool isDead = false;
      if (nextAge >= maxAge) {
        // Jika sudah mencapai atau melewati batas usia maksimal -> meninggal karena usia tua
        isDead = true;
      } else if (nextAge >= (maxAge - 2)) {
        // Jika mendekati batas usia maksimal (2 tahun terakhir) -> ada peluang meninggal bertahap (35%)
        if (_random.nextInt(100) < 35) {
          isDead = true;
        }
      }

      if (isDead) {
        petsToRemove.add(pet);
        notices.add(
          '🥀 Kabar Duka Peliharaan: $emoji $petName ($breed) meninggal dunia karena usia tua pada umur $nextAge tahun.',
        );
      }
    }

    // Hapus hewan yang meninggal dari list peliharaan
    for (var deadPet in petsToRemove) {
      pets.remove(deadPet);
    }

    return notices;
  }
}
