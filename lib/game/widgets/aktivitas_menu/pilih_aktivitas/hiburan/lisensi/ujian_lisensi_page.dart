import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/game/widgets/aktivitas_menu/pilih_aktivitas/hiburan/dokter/menu_dokter/dokter_utils.dart'; // we can use fmt

class UjianLisensiPage extends StatefulWidget {
  final Character character;
  final Map<String, dynamic> license;
  final VoidCallback onComplete;

  const UjianLisensiPage({
    super.key,
    required this.character,
    required this.license,
    required this.onComplete,
  });

  @override
  State<UjianLisensiPage> createState() => _UjianLisensiPageState();
}

class _UjianLisensiPageState extends State<UjianLisensiPage> {
  int _currentQuestionIndex = 0;
  int _correctAnswersCount = 0;
  String? _selectedAnswer;

  late final List<Map<String, dynamic>> _questions;

  @override
  void initState() {
    super.initState();
    _questions = _getQuestionsForLicense(widget.license['name']);
    _questions.shuffle(); // Acak urutan pertanyaan
  }

  List<Map<String, dynamic>> _getQuestionsForLicense(String name) {
    if (name.contains('SIM A') || name.contains('SIM C') || name.contains('SIM B')) {
      return [
        {
          'q': 'Apa arti rambu lalu lintas berbentuk segitiga merah dengan tanda seru di dalamnya?',
          'options': [
            'Dilarang parkir dan berhenti di bahu jalan',
            'Peringatan bahaya di depan, pengendara harus waspada',
            'Jalur khusus sepeda motor dan kendaraan roda tiga'
          ],
          'answer': 'Peringatan bahaya di depan, pengendara harus waspada',
        },
        {
          'q': 'Ketika mendekati lampu merah yang menyala, apa yang harus Anda lakukan?',
          'options': [
            'Mempercepat laju kendaraan agar tidak tertinggal',
            'Berhenti dengan tertib sebelum garis batas stop',
            'Tetap berjalan perlahan jika area jalan terlihat sepi'
          ],
          'answer': 'Berhenti dengan tertib sebelum garis batas stop',
        },
        {
          'q': 'Berapa jarak aman minimal kendaraan saat melaju di jalan tol basah / hujan?',
          'options': [
            'Sangat dekat (sekitar 5 meter) agar konsentrasi terjaga',
            'Lebih jauh dari jarak normal karena permukaan jalan licin',
            'Sama seperti jarak normal pada cuaca cerah biasa'
          ],
          'answer': 'Lebih jauh dari jarak normal karena permukaan jalan licin',
        },
        {
          'q': 'Apa yang dimaksud dengan Aquaplaning?',
          'options': [
            'Kondisi ban kehilangan daya cengkeram akibat lapisan air di jalan',
            'Sistem pendingin mesin menggunakan air suling khusus',
            'Teknik mencuci mobil dengan semprotan air tekanan tinggi'
          ],
          'answer': 'Kondisi ban kehilangan daya cengkeram akibat lapisan air di jalan',
        }
      ];
    } else if (name.contains('Paspor')) {
      return [
        {
          'q': 'Apa tujuan utama Anda mengajukan Paspor?',
          'options': [
            'Untuk keperluan perjalanan internasional dan wisata luar negeri',
            'Menghindari pemeriksaan identitas dari aparat penegak hukum',
            'Sebagai pajangan dan koleksi dokumen pribadi di rumah'
          ],
          'answer': 'Untuk keperluan perjalanan internasional dan wisata luar negeri',
        },
        {
          'q': 'Dokumen apa saja yang wajib dilampirkan saat pengajuan paspor baru?',
          'options': [
            'Cukup melampirkan kartu nama bisnis atau kartu pelajar',
            'KTP, Kartu Keluarga, dan Akta Kelahiran atau Ijazah asli',
            'Hanya perlu membawa surat keterangan sehat jasmani'
          ],
          'answer': 'KTP, Kartu Keluarga, dan Akta Kelahiran atau Ijazah asli',
        },
        {
          'q': 'Berapa masa berlaku paspor biasa yang berlaku saat ini bagi WNI?',
          'options': [
            'Hanya berlaku 1 tahun saja semenjak diterbitkan',
            '10 tahun (atau 5 tahun bagi anak di bawah umur/khusus)',
            'Berlaku seumur hidup tanpa perlu perpanjangan lagi'
          ],
          'answer': '10 tahun (atau 5 tahun bagi anak di bawah umur/khusus)',
        }
      ];
    } else {
      // Pilot License
      return [
        {
          'q': 'Apa yang harus dilakukan pilot ketika mendadak terjadi turbulensi udara?',
          'options': [
            'Menjaga kontrol kemudi serta memantau altimeter secara ketat',
            'Langsung mematikan seluruh mesin utama demi keamanan',
            'Segera melompat keluar kabin menggunakan parasut darurat'
          ],
          'answer': 'Menjaga kontrol kemudi serta memantau altimeter secara ketat',
        },
        {
          'q': 'Bagian pesawat terbang manakah yang menghasilkan gaya angkat utama (Lift)?',
          'options': [
            'Sayap pesawat (Wings)',
            'Ekor penyeimbang (Stabilizer)',
            'Baling-baling mesin depan (Propeller)'
          ],
          'answer': 'Sayap pesawat (Wings)',
        },
        {
          'q': 'Apa fungsi utama dari komponen Flap pada sayap pesawat?',
          'options': [
            'Meningkatkan gaya angkat pada kecepatan rendah saat take-off/landing',
            'Menghias badan pesawat agar terlihat lebih aerodinamis',
            'Berfungsi sebagai tangki darurat penyimpan bahan bakar'
          ],
          'answer': 'Meningkatkan gaya angkat pada kecepatan rendah saat take-off/landing',
        },
        {
          'q': 'Alat navigasi altimeter pada kokpit digunakan untuk mengukur apa?',
          'options': [
            'Ketinggian terbang pesawat dari permukaan laut',
            'Kecepatan angin yang berembus di sekitar sayap',
            'Suhu mesin jet turbin selama mengudara'
          ],
          'answer': 'Ketinggian terbang pesawat dari permukaan laut',
        }
      ];
    }
  }

  void _nextOrFinish() {
    if (_selectedAnswer == _questions[_currentQuestionIndex]['answer']) {
      _correctAnswersCount++;
    }

    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedAnswer = null;
      });
    } else {
      _showResult();
    }
  }

  void _showResult() {
    final bool passed = _correctAnswersCount >= (_questions.length * 0.7); // lulus jika >= 70% benar
    final int cost = widget.license['cost'] as int;

    setState(() {
      widget.character.money -= cost;
    });

    String title;
    String content;
    IconData icon;
    Color color;

    if (passed) {
      title = 'Ujian Lulus! 🎉';
      icon = Icons.check_circle;
      color = Colors.green;
      widget.character.ownedLicenses.add(widget.license['name']);
      widget.character.intelligence = (widget.character.intelligence + 4).clamp(0, 100);
      content = 'Selamat! Kamu menjawab $_correctAnswersCount dari ${_questions.length} pertanyaan dengan benar. Kamu resmi mendapatkan ${widget.license['name']}.\n\nBiaya ujian sebesar \$${cost.toString().replaceAllMapped(RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"), (m) => "${m[1]}.")} telah dipotong.';
      widget.character.inbox.add('📋 Lisensi Diperoleh: Selamat! Kamu lulus ujian dan mendapatkan ${widget.license['name']} (+4% Kecerdasan, -\$${cost.toString().replaceAllMapped(RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"), (m) => "${m[1]}.")})');
    } else {
      title = 'Ujian Gagal 😔';
      icon = Icons.cancel;
      color = Colors.red;
      content = 'Sayang sekali. Kamu hanya menjawab $_correctAnswersCount dari ${_questions.length} pertanyaan dengan benar. Kamu dinyatakan GAGAL ujian.\n\nBiaya pendaftaran sebesar \$${cost.toString().replaceAllMapped(RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"), (m) => "${m[1]}.")} tetap dipotong oleh panitia ujian.';
      widget.character.inbox.add('📋 Ujian Lisensi Gagal: Kamu gagal dalam ujian ${widget.license['name']} (-\$${cost.toString().replaceAllMapped(RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"), (m) => "${m[1]}.")})');
    }

    widget.onComplete();

    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(width: 8),
            Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
          ],
        ),
        content: Text(content, style: TextStyle(fontSize: 14, height: 1.4, color: isDark ? Colors.white70 : Colors.black87)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx); // Tutup dialog hasil
              Navigator.pop(context, passed); // Kembali ke menu lisensi
            },
            child: Text('OK', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: isDark ? Colors.white70 : Colors.black87)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final currentQ = _questions[_currentQuestionIndex];
    final progress = (_currentQuestionIndex + 1) / _questions.length;

    return Scaffold(
      appBar: AppBar(
        title: Text('Ujian: ${widget.license['name']}', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
        foregroundColor: isDark ? Colors.white : Colors.black87,
        elevation: 0.5,
      ),
      body: Container(
        color: isDark ? Colors.grey.shade900 : Colors.grey.shade50,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: isDark ? Colors.grey.shade700 : Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade600),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Pertanyaan ${_currentQuestionIndex + 1} dari ${_questions.length}',
              style: TextStyle(
                color: isDark ? Colors.white70 : Colors.black54,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 30),
            // Card pertanyaan
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              color: isDark ? Colors.grey.shade800 : Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  currentQ['q'],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    height: 1.4,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Options list
            Expanded(
              child: ListView(
                children: (currentQ['options'] as List<String>).map((opt) {
                  final isSelected = _selectedAnswer == opt;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _selectedAnswer = opt;
                        });
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? (isDark ? Colors.blue.shade900 : Colors.blue.shade50)
                              : (isDark ? Colors.grey.shade800 : Colors.white),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? Colors.blue.shade600 : (isDark ? Colors.grey.shade700 : Colors.grey.shade200),
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                              color: isSelected
                                  ? Colors.blue.shade600
                                  : (isDark ? Colors.white54 : Colors.grey.shade400),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                opt,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  color: isDark ? Colors.white : Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            // Next button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark ? Colors.blue.shade700 : Colors.blue.shade600,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              onPressed: _selectedAnswer != null ? _nextOrFinish : null,
              child: Text(
                _currentQuestionIndex == _questions.length - 1 ? 'Selesai' : 'Lanjut',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}