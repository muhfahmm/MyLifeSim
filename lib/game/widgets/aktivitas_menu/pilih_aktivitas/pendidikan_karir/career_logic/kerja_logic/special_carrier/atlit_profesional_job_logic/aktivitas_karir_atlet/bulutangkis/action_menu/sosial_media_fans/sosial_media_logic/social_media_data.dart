// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/career_logic/kerja_logic/special_carrier/atlit_profesional_job_logic/aktivitas_karir_atlet/sepakbola/action_menu/sosial_media_fans/sosial_media_logic/social_media_data.dart

import 'social_media_models.dart';

class SocialMediaData {
  static List<SocialContentType> getContentTypes() {
    return [
      // 1. 📸 Foto Latihan / Dibalik Layar
      SocialContentType(
        id: 'training_photo',
        label: '📸 Foto Latihan / Dibalik Layar',
        description: 'Konten aktivitas latihan intensif dan suasana kerja keras di lapangan.',
        captionOptions: [
          SocialCaptionOption(
            label: '🙏 Rendah Hati',
            styleName: 'Rendah Hati',
            captionText: '"Terima kasih fans yang selalu mendukung! Setiap keringat untuk seragam ini."',
            popularityDelta: 6,
            followersMultiplier: 100,
            engagementDelta: 5,
            karmaDelta: 5,
            relationshipDelta: 4,
            successNarration: '✨ Kontenmu dipuji fans dan pelatih! Banyak pengikut baru mengagumi kerendahan hatimu.',
            failNarration: '⚠️ Kontenmu biasa saja di mata netizen, tidak terlalu banyak sorotan.',
          ),
          SocialCaptionOption(
            label: '😎 Sombong / Agresif',
            styleName: 'Sombong',
            captionText: '"Kalian lihat betapa mudahnya saya menguasai lapangan hari ini?"',
            popularityDelta: 12,
            followersMultiplier: 250,
            engagementDelta: 8,
            karmaDelta: -4,
            relationshipDelta: -3,
            successNarration: '🔥 Postinganmu memicu kehebohan! Fans lawan murka namun pengikutmu naik drastis!',
            failNarration: '😡 Banyak komentar pedas menyerang sifat aroganmu di postingan tersebut.',
          ),
          SocialCaptionOption(
            label: '🤡 Humor / Sarkas',
            styleName: 'Humor',
            captionText: '"Coba tebak, bola mana yang gue gol-kan dan mana yang nyasar ke parkiran?"',
            popularityDelta: 10,
            followersMultiplier: 200,
            engagementDelta: 12,
            karmaDelta: 2,
            relationshipDelta: -2,
            successNarration: '😂 Memes dan postinganmu viral di akun humor bola! Likes membanjiri layar!',
            failNarration: '😅 Candaanmu dianggap agak garing oleh netizen.',
          ),
          SocialCaptionOption(
            label: '📚 Motivasi / Filosofis',
            styleName: 'Motivasi',
            captionText: '"Kesuksesan bukanlah kebetulan. Ini adalah hasil dari kerja keras dan ketekunan."',
            popularityDelta: 5,
            followersMultiplier: 80,
            engagementDelta: 3,
            karmaDelta: 10,
            relationshipDelta: 3,
            successNarration: '💡 Postinganmu dijadikan kutipan inspiratif di medsos.',
            failNarration: '😴 Netizen merasa kutipanmu terlalu klise.',
          ),
        ],
      ),

      // 2. 🏖️ Liburan / Kehidupan Pribadi
      SocialContentType(
        id: 'vacation_lifestyle',
        label: '🏖️ Liburan & Kehidupan Pribadi',
        description: 'Momen berlibur santai di pantai, mengendarai mobil mewah, atau bersantai.',
        captionOptions: [
          SocialCaptionOption(
            label: '🙏 Rendah Hati',
            styleName: 'Rendah Hati',
            captionText: '"Menikmati waktu istirahat sejenak bersama keluarga sebelum kembali bertarung."',
            popularityDelta: 5,
            followersMultiplier: 120,
            engagementDelta: 4,
            karmaDelta: 4,
            relationshipDelta: 2,
            successNarration: '🌿 Fans senang melihat momen hangat dan manusiawimu.',
            failNarration: '😴 Respon netizen biasa saja.',
          ),
          SocialCaptionOption(
            label: '😎 Pamer / Sombong',
            styleName: 'Pamer',
            captionText: '"Bekerja keras, nikmati kemewahan. Hidup ini terlalu singkat untuk biasa saja!"',
            popularityDelta: 14,
            followersMultiplier: 300,
            engagementDelta: 10,
            karmaDelta: -6,
            relationshipDelta: -4,
            successNarration: '💎 Gaya hidup mewahmu menarik perhatian ribuan pengikut baru!',
            failNarration: '😡 Kamu dikritik pedas karena terlalu pamer kemewahan saat performa klub sedang disorot.',
          ),
          SocialCaptionOption(
            label: '🤡 Humor / Sarkas',
            styleName: 'Humor',
            captionText: '"Liburan dulu biar tidak kena mental gara-gara netizen."',
            popularityDelta: 8,
            followersMultiplier: 150,
            engagementDelta: 8,
            karmaDelta: 0,
            relationshipDelta: -1,
            successNarration: '🤣 Sindiran humoris milikmu mengundang banyak tawa di kolom komentar.',
            failNarration: '⚠️ Komentar netizen malah menyerang balik sindiranmu.',
          ),
        ],
      ),

      // 3. 😂 Konten Lucu / Meme
      SocialContentType(
        id: 'funny_meme',
        label: '😂 Konten Lucu / Meme',
        description: 'Unggahan komedi, editan lucu, atau aksi kocak bersama rekan tim.',
        captionOptions: [
          SocialCaptionOption(
            label: '🤡 Humor / Kocak',
            styleName: 'Kocak',
            captionText: '"Muka pas kaget kena tekel dari belakang tapi pura-pura tegar 😂"',
            popularityDelta: 15,
            followersMultiplier: 350,
            engagementDelta: 15,
            karmaDelta: 3,
            relationshipDelta: -2,
            successNarration: '🚀 Meme milikmu meledak dan direpost oleh ratusan akun bola populer!',
            failNarration: '😅 Pelatih menegurmu karena dianggap kurang serius mempersiapkan diri.',
          ),
          SocialCaptionOption(
            label: '📚 Filosofis / Lucu',
            styleName: 'Sarkas',
            captionText: '"Hidup itu seperti offside, kadang kita merasa benar padahal udah kelewatan."',
            popularityDelta: 9,
            followersMultiplier: 180,
            engagementDelta: 9,
            karmaDelta: 5,
            relationshipDelta: 1,
            successNarration: '💡 Netizen menyukai selera humormu yang cerdas.',
            failNarration: '😴 Netizen tidak terlalu paham dengan maksud postinganmu.',
          ),
        ],
      ),

      // 4. 💰 Konten Endorse / Iklan Produk
      SocialContentType(
        id: 'endorse_ad',
        label: '💰 Konten Endorse / Iklan Produk',
        description: 'Mempromosikan brand sepatu, minuman nutrisi, atau produk ternama.',
        captionOptions: [
          SocialCaptionOption(
            label: '🙏 Rendah Hati / Profesional',
            styleName: 'Profesional',
            captionText: '"Bangga bisa bermitra dengan brand ternama yang menunjang performaku di lapangan!"',
            popularityDelta: 4,
            followersMultiplier: 90,
            engagementDelta: 2,
            karmaDelta: -2,
            moneyReward: 3000,
            relationshipDelta: 0,
            successNarration: '💵 Iklan berjalan sukses! Kamu mengantongi \$3.000 dari brand sponsor!',
            failNarration: '⚠️ Iklan kurang mendapat jangkauan tinggi, namun kamu tetap dibayar \$3.000.',
          ),
          SocialCaptionOption(
            label: '😎 Persuasif / Ambisius',
            styleName: 'Ambisius',
            captionText: '"Kalau mau juara seperti saya, wajib pakai produk ini sekarang juga!"',
            popularityDelta: 2,
            followersMultiplier: 50,
            engagementDelta: -2,
            karmaDelta: -5,
            moneyReward: 6000,
            relationshipDelta: -2,
            successNarration: '💰 Promosi agresif membuahkan bonus besar! Kamu mengantongi \$6.000!',
            failNarration: '😡 Netizen mengkritikmu karena akunmu penuh dengan spam iklan berjualan.',
          ),
        ],
      ),

      // 5. 🔥 Pernyataan Kontroversial (Hot Takes)
      SocialContentType(
        id: 'hot_takes',
        label: '🔥 Pernyataan Kontroversial (Hot Takes)',
        description: 'Unggahan berisiko tinggi mengenai keputusan wasit, kritikan liga, atau rival.',
        captionOptions: [
          SocialCaptionOption(
            label: '🔥 Sangat Kontroversial / Pedas',
            styleName: 'Kontroversial',
            captionText: '"Keputusan wasit semalam sungguh lelucon terbesar dalam sejarah sepak bola!"',
            popularityDelta: 25,
            followersMultiplier: 500,
            engagementDelta: 25,
            karmaDelta: -12,
            relationshipDelta: -8,
            successNarration: '⚡ VIRAL TOTAL! Namamu jadi Trending Topic #1 di X (Twitter)! Ribuan pengikut baru membanjiri akunmu!',
            failNarration: '❌ CANCEL CULTURE! Pernyataanmu memicu kemarahan federasi & kamu dipanggil manajemen klub!',
          ),
          SocialCaptionOption(
            label: '🎭 Diplomatis / Kritis',
            styleName: 'Kritis',
            captionText: '"Sepak bola butuh pembenahan teknologi agar keadilan di lapangan tetap terjaga."',
            popularityDelta: 10,
            followersMultiplier: 200,
            engagementDelta: 10,
            karmaDelta: 3,
            relationshipDelta: 1,
            successNarration: '👏 Netizen dan pengamat memuji pemikiran kritismu yang membangun.',
            failNarration: '⚠️ Argumenmu memicu perdebatan sengit di kolom komentar.',
          ),
        ],
      ),
    ];
  }
}
