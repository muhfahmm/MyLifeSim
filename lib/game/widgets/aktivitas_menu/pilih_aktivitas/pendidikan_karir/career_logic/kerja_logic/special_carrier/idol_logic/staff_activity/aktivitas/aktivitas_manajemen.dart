import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/game/widgets/dialog_helper.dart';
import 'pages_menu/halaman_rekrut_trainee_baru.dart';

class AktivitasManajemenPage extends StatefulWidget {
  final Character character;
  final VoidCallback onRefresh;

  const AktivitasManajemenPage({
    super.key,
    required this.character,
    required this.onRefresh,
  });

  @override
  State<AktivitasManajemenPage> createState() => _AktivitasManajemenPageState();
}

class _AktivitasManajemenPageState extends State<AktivitasManajemenPage> {
  bool get _isGMOrDeputyGM {
    final role = (widget.character.jobName ?? '').toLowerCase();
    return role == 'general manager' || role == 'deputy general manager' || role.contains('gm');
  }

  bool get _isTrainer {
    final role = (widget.character.jobName ?? '').toLowerCase();
    return role.contains('pelatih') || role.contains('trainer') || role.contains('koreografer');
  }

  bool get _isProductionOrCreative {
    final role = (widget.character.jobName ?? '').toLowerCase();
    return role.contains('engineer') ||
        role.contains('kreatif') ||
        role.contains('editor') ||
        role.contains('fotografer') ||
        role.contains('videografer') ||
        role.contains('desainer') ||
        role.contains('medsos') ||
        role.contains('stage') ||
        role.contains('sound') ||
        role.contains('lighting');
  }

  void _lakukanAktivitasStaf(String tipe, int stressCost, int disciplineGain) {
    setState(() {
      widget.character.happiness = (widget.character.happiness - stressCost).clamp(0, 100);
      widget.character.discipline = (widget.character.discipline + disciplineGain).clamp(0, 100);

      // Improve relationship with a random staff member or idol member
      final sourceList = widget.character.idolStaff.isNotEmpty
          ? widget.character.idolStaff
          : widget.character.idolMainMembers;
      if (sourceList.isNotEmpty) {
        final rand = Random();
        final idx = rand.nextInt(sourceList.length);
        final person = sourceList[idx];
        int currentRel = int.tryParse(person['relationship'] ?? '50') ?? 50;
        person['relationship'] = (currentRel + rand.nextInt(5) + 3).clamp(0, 100).toString();
      }

      // Add news entry based on activity
      String newsText = '';
      if (tipe.contains('Evaluasi')) {
        newsText = '📊 Evaluasi Agensi: Sesi evaluasi kinerja idol dan trainer diselesaikan oleh ${widget.character.name} demi performa optimal.';
      } else if (tipe.contains('Perencanaan') || tipe.contains('Konser')) {
        newsText = '🎪 Pengumuman Konser: Konsep pertunjukan panggung dan show teater baru telah resmi disusun oleh tim manajemen agensi!';
      } else if (tipe.contains('Promosi') || tipe.contains('Media') || tipe.contains('Medsos')) {
        newsText = '📣 Liputan Media: Kampanye promosi besar-besaran dan jadwal media digital resmi dirilis oleh agensi idol!';
      } else if (tipe.contains('Keuangan') || tipe.contains('Anggaran')) {
        newsText = '💰 Rapat Keuangan: Rapat alokasi anggaran operasional dan fasilitas agensi sukses dilaksanakan oleh manajemen.';
      } else if (tipe.contains('Vokal') || tipe.contains('Koreografi') || tipe.contains('Pelatihan') || tipe.contains('Fisik') || tipe.contains('Bimbingan')) {
        newsText = '🎓 Pelatihan Idol: ${widget.character.name} telah melaksanakan "$tipe" secara intensif untuk meningkatkan performa member!';
      } else if (tipe.contains('Gladi') || tipe.contains('Sound') || tipe.contains('Lighting') || tipe.contains('Editing') || tipe.contains('Video')) {
        newsText = '🎬 Produksi & Teater: Tim produksi menyelesaikan "$tipe" demi kelancaran pertunjukan teater idol!';
      } else {
        newsText = '📋 Operasional Staf: ${widget.character.name} melaksanakan "$tipe" untuk mendukung kelancaran kegiatan agensi.';
      }
      widget.character.idolNews.add(newsText);
      if (widget.character.idolNews.length > 50) {
        widget.character.idolNews.removeAt(0);
      }
    });
    widget.onRefresh();

    DialogHelper.show(
      context: context,
      title: 'Aktivitas Staf ✨',
      content: Text(
        'Kamu melaksanakan "$tipe". Kedisiplinan dan profesionalisme tim meningkat (Kedisiplinan: ${widget.character.discipline}%).\n'
        'Hubungan dengan rekan kerja/idol juga semakin erat! Kebahagiaanmu berkurang -$stressCost% karena lelah bekerja.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Kerja Bagus!'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    String pageTitle = 'Aktivitas Staf 💼';
    if (_isGMOrDeputyGM) {
      pageTitle = 'Aktivitas Eksekutif & Manajemen 💼';
    } else if (_isTrainer) {
      pageTitle = 'Aktivitas Pelatihan Idol 🎓';
    } else if (_isProductionOrCreative) {
      pageTitle = 'Aktivitas Produksi & Media 🎬';
    } else {
      pageTitle = 'Aktivitas Operasional Staf 📋';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(pageTitle),
        backgroundColor: Colors.pink.shade700,
        foregroundColor: Colors.white,
      ),
      backgroundColor: isDark ? Colors.grey.shade900 : Colors.grey.shade50,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // GM & Deputy GM ONLY: Perekrutan & Fitur Manajemen Eksekutif
          if (_isGMOrDeputyGM) ...[
            Builder(builder: (context) {
              final bool alreadyRecruitedThisYear =
                  widget.character.lastRecruitAge != null &&
                      widget.character.lastRecruitAge == widget.character.age;

              return _buildActionCard(
                title: 'Perekrutan Generasi Trainee Baru 📋',
                desc: alreadyRecruitedThisYear
                    ? 'Perekrutan generasi trainee baru telah dilaksanakan tahun ini (1 kali / tahun).'
                    : 'Mengorganisir audisi dan seleksi kandidat member idol generasi baru (Disiplin +6%, Kebahagiaan -4%)',
                isDisabled: alreadyRecruitedThisYear,
                onTap: () {
                  if (alreadyRecruitedThisYear) {
                    DialogHelper.show(
                      context: context,
                      title: 'Audisi Sudah Dilaksanakan',
                      content: const Text(
                        'Perekrutan generasi trainee baru hanya dapat dilaksanakan 1 kali dalam 1 tahun.\n\n'
                        'Tunggu hingga usia Anda bertambah (tahun berikutnya) untuk membuka audisi generasi baru kembali.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Mengerti'),
                        ),
                      ],
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HalamanRekrutTraineeBaru(
                          character: widget.character,
                          onRefresh: () {
                            if (mounted) setState(() {});
                            widget.onRefresh();
                          },
                        ),
                      ),
                    );
                  }
                },
              );
            }),
            _buildActionCard(
              title: 'Evaluasi Kinerja Idol & Trainer 📊',
              desc: 'Meninjau perkembangan kemampuan vokal, tari, dan performa teater member (Disiplin +5%, Kebahagiaan -3%)',
              onTap: () => _lakukanAktivitasStaf('Evaluasi Kinerja Idol & Trainer', 3, 5),
            ),
            _buildActionCard(
              title: 'Perencanaan Konser & Show Teater 🎪',
              desc: 'Menyusun setlist, konsep lighting, sound system, serta jadwal pertunjukan panggung (Disiplin +8%, Kebahagiaan -5%)',
              onTap: () => _lakukanAktivitasStaf('Perencanaan Konser & Show Teater', 5, 8),
            ),
            _buildActionCard(
              title: 'Kampanye Promosi & Media Sosial 📣',
              desc: 'Mengkoordinasi perilisan media, jadwal interview, serta konten digital resmi (Disiplin +4%, Kebahagiaan -2%)',
              onTap: () => _lakukanAktivitasStaf('Kampanye Promosi & Media Sosial', 2, 4),
            ),
            _buildActionCard(
              title: 'Rapat Anggaran & Keuangan Agensi 💰',
              desc: 'Mengatur alokasi anggaran operasional teater, kostum, dan gaji staf (Disiplin +7%, Kebahagiaan -4%)',
              onTap: () => _lakukanAktivitasStaf('Rapat Anggaran & Keuangan Agensi', 4, 7),
            ),
          ]

          // TRAINER (Pelatih Vokal, Pelatih Tari, Pelatih Akting/MC)
          else if (_isTrainer) ...[
            _buildActionCard(
              title: 'Latihan Olah Vokal & Harmoni 🎤',
              desc: 'Melatih pernapasan, kestabilan pitch, dan harmoni vokal para idol (Disiplin +5%, Kebahagiaan -3%)',
              onTap: () => _lakukanAktivitasStaf('Latihan Olah Vokal & Harmoni', 3, 5),
            ),
            _buildActionCard(
              title: 'Pelatihan Koreografi & Fisik 💃',
              desc: 'Melatih gerakan tari panggung dan ketahanan fisik para member (Disiplin +6%, Kebahagiaan -4%)',
              onTap: () => _lakukanAktivitasStaf('Pelatihan Koreografi & Fisik', 4, 6),
            ),
            _buildActionCard(
              title: 'Evaluasi Teknik Panggung Member 📊',
              desc: 'Menilai ekspresi wajah, kontak mata, dan kepercayaan diri member teater (Disiplin +4%, Kebahagiaan -2%)',
              onTap: () => _lakukanAktivitasStaf('Evaluasi Teknik Panggung Member', 2, 4),
            ),
            _buildActionCard(
              title: 'Bimbingan Mental & Karakter Idol 🧠',
              desc: 'Memberikan motivasi dan membangun kedisiplinan mental para member (Disiplin +3%, Kebahagiaan -2%)',
              onTap: () => _lakukanAktivitasStaf('Bimbingan Mental & Karakter Idol', 2, 3),
            ),
          ]

          // TIM PRODUKSI & KREATIF (Sound, Lighting, Stage, Fotografer, Medsos)
          else if (_isProductionOrCreative) ...[
            _buildActionCard(
              title: 'Gladi Bersih & Setup Panggung Teater 🎪',
              desc: 'Memastikan tata letak panggung, properti, dan blocking pertunjukan sempurna (Disiplin +6%, Kebahagiaan -4%)',
              onTap: () => _lakukanAktivitasStaf('Gladi Bersih & Setup Panggung Teater', 4, 6),
            ),
            _buildActionCard(
              title: 'Pengawasan Tata Suara & Sound Check 🎛️',
              desc: 'Mengatur kualitas mikrofon, equalizer, dan efek suara panggung (Disiplin +5%, Kebahagiaan -3%)',
              onTap: () => _lakukanAktivitasStaf('Pengawasan Tata Suara & Sound Check', 3, 5),
            ),
            _buildActionCard(
              title: 'Dokumentasi Visual & Konten Medsos 📸',
              desc: 'Mengambil foto/video resmi pertunjukan dan mengunggah konten promo (Disiplin +4%, Kebahagiaan -2%)',
              onTap: () => _lakukanAktivitasStaf('Dokumentasi Visual & Konten Medsos', 2, 4),
            ),
            _buildActionCard(
              title: 'Editing & Rilis Video Promo Teater 🎬',
              desc: 'Mengedit cuplikan pertunjukan teater untuk dipublikasikan ke penggemar (Disiplin +5%, Kebahagiaan -3%)',
              onTap: () => _lakukanAktivitasStaf('Editing & Rilis Video Promo Teater', 3, 5),
            ),
          ]

          // STAF OPERASIONAL LAINNYA (Merchandise, Toko, MUA, Keamanan, Admin, HRD)
          else ...[
            _buildActionCard(
              title: 'Pelayanan Official Merchandise & Store 🛍️',
              desc: 'Mengelola stok produk resmi idol dan melayani fans di toko teater (Disiplin +4%, Kebahagiaan -2%)',
              onTap: () => _lakukanAktivitasStaf('Pelayanan Official Merchandise & Store', 2, 4),
            ),
            _buildActionCard(
              title: 'Pemeriksaan & Perawatan Kostum Teater 👗',
              desc: 'Memastikan kebersihan, kerapihan, dan ketersediaan kostum panggung member (Disiplin +5%, Kebahagiaan -3%)',
              onTap: () => _lakukanAktivitasStaf('Pemeriksaan & Perawatan Kostum Teater', 3, 5),
            ),
            _buildActionCard(
              title: 'Penjualan Tiket & Keamanan Teater 🎟️',
              desc: 'Menjaga ketertiban pintu masuk dan sistem antrean pertunjukan teater (Disiplin +5%, Kebahagiaan -3%)',
              onTap: () => _lakukanAktivitasStaf('Penjualan Tiket & Keamanan Teater', 3, 5),
            ),
            _buildActionCard(
              title: 'Administrasi & Koordinasi Fasilitas Agensi 📁',
              desc: 'Mengurus dokumen operasional dan kenyamanan fasilitas tempat latihan (Disiplin +4%, Kebahagiaan -2%)',
              onTap: () => _lakukanAktivitasStaf('Administrasi & Koordinasi Fasilitas Agensi', 2, 4),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required String title,
    required String desc,
    required VoidCallback onTap,
    bool isDisabled = false,
  }) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isDisabled
              ? Colors.grey.shade300
              : (isDark ? Colors.pink.shade700 : Colors.pink.shade100.withAlpha(128)),
        ),
      ),
      color: isDisabled
          ? (isDark ? Colors.grey.shade900 : Colors.grey.shade100)
          : (isDark ? Colors.grey.shade800 : Colors.white),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: isDisabled
                ? Colors.grey
                : (isDark ? Colors.white : Colors.black87),
          ),
        ),
        subtitle: Text(
          desc,
          style: TextStyle(
            fontSize: 12,
            color: isDisabled ? Colors.grey.shade500 : (isDark ? Colors.white70 : Colors.grey),
          ),
        ),
        trailing: Icon(
          isDisabled ? Icons.lock : Icons.arrow_forward_ios,
          size: 14,
          color: isDisabled
              ? Colors.grey
              : (isDark ? Colors.white54 : Colors.grey),
        ),
        onTap: onTap,
      ),
    );
  }
}
