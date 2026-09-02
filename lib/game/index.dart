// lib/game/index.dart
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'package:bitlife/game/paused_menu/pausedMenu.dart';
import 'dart:math';
import 'dart:async';
import 'package:bitlife/game/widgets/hubungan_menu/relationship_button/parent_remarriage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bitlife/avatar/avatar_generator.dart';
import 'package:bitlife/avatar/avatar_age_rules.dart';
import 'package:bitlife/game/widgets/hubungan_menu/ajakan_pacaran_makelove/ajakan_handler.dart';

// Import widget-widget UI
import 'package:bitlife/game/widgets/kategori_usia/age_category_button.dart';
import 'package:bitlife/game/widgets/assets_menu/assets_button.dart';
import 'package:bitlife/game/widgets/hubungan_menu/relationship_button/relationship_button.dart';
import 'package:bitlife/game/widgets/aktivitas_menu/activity_button.dart';
import 'package:bitlife/game/widgets/kategori_usia/age_up_button.dart';
import 'package:bitlife/game/widgets/kategori_usia/kurangi_umur_button.dart';
import 'package:bitlife/store_page/store_page.dart';
import 'package:bitlife/game/widgets/kategori_usia/next_day_button.dart';
import 'package:bitlife/game/widgets/inbox_menu/inbox_button.dart';
import 'package:bitlife/game/widgets/penyakit_logic/std_logic.dart';
import 'package:bitlife/game/widgets/hubungan_menu/action_menu/notifikasi_ortu/beri_tahu_pacar.dart';
import 'package:bitlife/game/widgets/hubungan_menu/npc_family_view.dart';
import 'package:bitlife/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/univ_logic/univ_menu_page.dart';
import 'package:bitlife/game/widgets/aktivitas_menu/pilih_aktivitas/lainnya/masturbasi/ajakan_masturbasi_dialog.dart';
import 'package:bitlife/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/kerja_logic/kerja_menu.dart';
import 'package:bitlife/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/school_logic/actions/school_generator.dart';
import 'package:bitlife/game/widgets/aktivitas_menu/pilih_aktivitas/hiburan/dokter/dokter_menu.dart';
import 'package:bitlife/game/widgets/hubungan_menu/action_menu/opsi_bercinta/kepuasan_bercinta.dart';
import 'package:bitlife/game/widgets/hubungan_menu/daftar_pasangan_hamil.dart';

class GameScreen extends StatefulWidget {
  final Character character;
  const GameScreen({super.key, required this.character});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late Character _character;
  // Cache avatar URL agar tidak di-rebuild ulang setiap kali state berubah
  late String _avatarUrl;
  bool _isAgingUp = false;

  void _finishAgeUp() {
    if (mounted) {
      setState(() {
        _isAgingUp = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _character = widget.character;
    // Generate avatar URL sekali saja di initState
    _avatarUrl = AvatarAgeRules.getAgeBasedAvatarUrl(
      _character,
      happiness: _character.happiness,
    );
    // Tampilkan pilihan hak asuh saat game baru dimulai jika orang tua sudah cerai
    if ((_character.isFatherDivorced || _character.isMotherDivorced) &&
        _character.custodyParent == null &&
        _character.fatherName != null &&
        _character.motherName != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _showCustodySelectionDialog(context, _character.fatherName!, _character.motherName!);
        }
      });
    }
  }

  // --- LOGIKA RESET ---
  void _resetGame() {
    setState(() {
      _character.age = 0;
      _character.health = 100;
      _character.happiness = 50;
      _character.intelligence = 50;
      _character.money = 0;
      _character.isAlive = true;
      _avatarUrl = AvatarAgeRules.getAgeBasedAvatarUrl(
        _character,
        happiness: _character.happiness,
      );
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('🔄 Semua status berhasil direset!'), backgroundColor: Colors.green),
    );
  }

  // --- LOGIKA TES KESEHATAN MATA ---
  final List<Map<String, dynamic>> _eyeTests = [
    {'text': 'AAAA4AAA', 'odd': '4', 'options': ['A', '4', 'X', 'Y']},
    {'text': 'SSSSS5SSS', 'odd': '5', 'options': ['S', '5', '8', '2']},
    {'text': 'OOOO0OOO', 'odd': '0', 'options': ['O', '0', 'Q', 'C']},
    {'text': 'IIIII1III', 'odd': '1', 'options': ['I', '1', 'L', 'T']},
    {'text': 'ZZZZ2ZZZ', 'odd': '2', 'options': ['Z', '2', '7', 'S']},
    {'text': 'VVVVUvvvv', 'odd': 'U', 'options': ['V', 'U', 'W', 'Y']},
    {'text': 'UUUUWUUU', 'odd': 'W', 'options': ['U', 'W', 'V', 'M']},
    {'text': 'MMMMWMMM', 'odd': 'W', 'options': ['M', 'W', 'N', 'V']},
    {'text': 'KKKKXKKK', 'odd': 'X', 'options': ['K', 'X', 'Y', 'H']},
    {'text': '8888B888', 'odd': 'B', 'options': ['8', 'B', '3', '6']},
  ];

  void _checkGlassesNeed([VoidCallback? onFinish]) {
    // Cek apakah perlu memilih hak asuh setelah orang tua bercerai di tengah game
    if ((_character.isFatherDivorced || _character.isMotherDivorced) &&
        _character.custodyParent == null &&
        _character.age < 18 &&
        _character.fatherName != null &&
        _character.motherName != null &&
        !_character.isFatherDeceased &&
        !_character.isMotherDeceased) {
      _showCustodySelectionDialog(context, _character.fatherName!, _character.motherName!);
      onFinish?.call();
      return;
    }

    if (_character.avatarAccessoriesType != 'blank' && _character.avatarAccessoriesType != null) {
      onFinish?.call();
      return; // Sudah pakai kacamata
    }
    final int age = _character.age;
    if (age <= 0) {
      onFinish?.call();
      return;
    }

    // Batasi tes hanya pada rentang usia 1-18 dan 40-60
    if (age >= 1 && age <= 18) {
      if (_character.eyeTestsCountYoung >= 2) {
        onFinish?.call();
        return;
      }
    } else if (age >= 40 && age <= 60) {
      if (_character.eyeTestsCountOld >= 2) {
        onFinish?.call();
        return;
      }
    } else {
      onFinish?.call();
      return; // Tidak ada tes di luar rentang usia tersebut
    }

    int chance = 0;
    if (age >= 1 && age <= 6) chance = 5;
    else if (age >= 7 && age <= 10) chance = 20;
    else if (age >= 11 && age <= 18) chance = 25;
    else if (age >= 40 && age <= 45) chance = 35;
    else if (age >= 46 && age <= 55) chance = 40;
    else if (age >= 56 && age <= 60) chance = 40;

    if (Random().nextInt(100) < chance) {
      if (age >= 1 && age <= 18) {
        _character.eyeTestsCountYoung++;
      } else if (age >= 40 && age <= 60) {
        _character.eyeTestsCountOld++;
      }
      _showEyeTestMinigame(onFinish);
    } else {
      onFinish?.call();
    }
  }

  void _showEyeTestMinigame([VoidCallback? onFinish]) {
    final randomTest = _eyeTests[Random().nextInt(_eyeTests.length)];
    final String targetText = randomTest['text']!;
    final String oddChar = randomTest['odd']!;
    final List<String> options = List<String>.from(randomTest['options']!);
    options.shuffle();

    int timeLeft = 5;
    Timer? countdownTimer;
    bool answered = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return PopScope(
          canPop: false,
          child: StatefulBuilder(
            builder: (context, setDialogState) {
              if (countdownTimer == null) {
                countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
                  if (timeLeft > 1) {
                    setDialogState(() {
                      timeLeft--;
                    });
                  } else {
                    timer.cancel();
                    if (!answered) {
                      answered = true;
                      setDialogState(() {
                        timeLeft = 0;
                      });
                      setState(() {
                        _character.avatarAccessoriesType = 'prescription01';
                        _avatarUrl = AvatarAgeRules.getAgeBasedAvatarUrl(_character, happiness: _character.happiness);
                      });
                      showDialog(
                        context: dialogContext,
                        barrierDismissible: false,
                        builder: (timeoutContext) => PopScope(
                          canPop: false,
                          child: AlertDialog(
                            title: const Text('Waktu Habis! 👓', style: TextStyle(fontWeight: FontWeight.bold)),
                            content: Text('Kamu tidak sempat membaca huruf tersebut. Kunci jawabannya adalah: "$oddChar". Dokter mendiagnosis mata silinder/minus, sehingga kamu harus memakai kacamata.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(timeoutContext);
                                  Navigator.pop(dialogContext);
                                  onFinish?.call();
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  }
                });
              }

              return AlertDialog(
                title: const Row(
                  children: [
                    Icon(Icons.remove_red_eye, color: Colors.blueAccent),
                    SizedBox(width: 8),
                    Text('Tes Kesehatan Mata 👓', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  ],
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Matamu terasa sedikit buram. Dokter meminta untuk menyebutkan satu huruf/angka yang berbeda dalam teks berikut dalam 5 detik!',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blueAccent, width: 2),
                      ),
                      child: Text(
                        targetText,
                        style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, letterSpacing: 4, color: Colors.black87),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      'Sisa waktu: $timeLeft detik',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: timeLeft <= 2 ? Colors.red : Colors.orange,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text('Pilih huruf/angka yang berbeda:', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 12,
                      children: options.map((opt) {
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: answered
                              ? null
                              : () {
                                  answered = true;
                                  countdownTimer?.cancel();
                                  if (opt == oddChar) {
                                    showDialog(
                                      context: dialogContext,
                                      barrierDismissible: false,
                                      builder: (successContext) => PopScope(
                                        canPop: false,
                                        child: AlertDialog(
                                          title: const Text('Fokus Bagus! 🎉', style: TextStyle(fontWeight: FontWeight.bold)),
                                          content: const Text('Kamu berhasil menemukan huruf yang berbeda! Penglihatanmu masih sangat baik, kamu tidak memerlukan kacamata.'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(successContext);
                                                Navigator.pop(dialogContext);
                                                onFinish?.call();
                                              },
                                              child: const Text('Lanjutkan'),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  } else {
                                    setState(() {
                                      _character.avatarAccessoriesType = 'prescription01';
                                      _avatarUrl = AvatarAgeRules.getAgeBasedAvatarUrl(_character, happiness: _character.happiness);
                                    });
                                    showDialog(
                                      context: dialogContext,
                                      barrierDismissible: false,
                                      builder: (failContext) => PopScope(
                                        canPop: false,
                                        child: AlertDialog(
                                          title: const Text('Salah Tebak! 👓', style: TextStyle(fontWeight: FontWeight.bold)),
                                          content: Text('Jawabanmu salah. Huruf yang benar adalah "$oddChar". Penglihatanmu buruk dan sekarang kamu harus memakai kacamata.'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(failContext);
                                                Navigator.pop(dialogContext);
                                                onFinish?.call();
                                              },
                                              child: const Text('OK'),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }
                                },
                          child: Text(opt, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    ).then((_) {
      countdownTimer?.cancel();
    });
  }

  // --- LOGIKA TAMBAH HARI ---
  void _nextDay() {
    if (!_character.isAlive) return;
    setState(() {
      if (_character.currentDate != null) {
        _character.currentDate = _character.currentDate!.add(const Duration(days: 1));
      } else {
        _character.currentDate = DateTime.now().add(const Duration(days: 1));
      }
    });

    final random = Random();
    // Panggil checkAndGenerateProposal secara langsung agar persentase internal (ml, pacaran, 3some) tetap sama persis seperti saat bertambah umur
    AjakanHandler.checkAndGenerateProposal(_character, random);
    if (_character.activeProposal != null) {
      _checkActiveProposal();
      return;
    }

    // 15% peluang memicu kejadian harian acak biasa jika tidak ada proposal
    if (random.nextInt(100) < 15) {
      final dailyEvents = [
        'Kamu menemukan uang Rp 10.000 di jalan!',
        'Kamu tidak sengaja terpeleset, untungnya tidak terluka.',
        'Tetanggamu menyapamu dengan sangat ramah hari ini.',
        'Hari ini cuaca sangat cerah dan membuat suasana hatimu tenang.',
        'Kamu menghabiskan waktu luang dengan membaca buku favoritmu.',
        'Kamu merasa sangat bugar setelah tidur yang nyenyak tadi malam.',
        'Seorang teman lama mengirimkan pesan menanyakan kabarmu.'
      ];
      final eventText = dailyEvents[random.nextInt(dailyEvents.length)];
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blueAccent, size: 28),
              SizedBox(width: 8),
              Text('Kejadian Hari Ini', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          content: Text(eventText),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  // --- LOGIKA TAMBAH UMUR (DENGAN KELAHIRAN & KEGUGURAN) ---
  void _runAgeUpSequence(List<String> sicknessEvents, VoidCallback onFinish) {
    _handleSicknessSequence(sicknessEvents, () {
      _checkAdikRequestMoney(() {
        _checkSchoolEnrollmentOptions(() {
          _checkChildrenEvents(() {
            _checkGraduationOptions(() {
              _checkEsportPromotion(onFinish);
            });
          });
        });
      });
    });
  }

  void _ageDown() {
    if (!_character.isAlive) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Karakter sudah meninggal!')),
      );
      return;
    }
    if (_character.age <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠️ Usia karakter sudah 0 tahun (tidak bisa dikurangi lagi).'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _character.age -= 1;
      if (_character.currentDate != null) {
        _character.currentDate = DateTime(
          _character.currentDate!.year - 1,
          _character.currentDate!.month,
          _character.currentDate!.day,
        );
      }
      _avatarUrl = AvatarAgeRules.getAgeBasedAvatarUrl(
        _character,
        happiness: _character.happiness,
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('⏪ GodMode: Umur berhasil dikurangi 1 tahun! (Sekarang usia ${_character.age} tahun)'),
        backgroundColor: Colors.purple.shade700,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _ageUp() {
    if (_isAgingUp || !_character.isAlive) return;

    setState(() {
      _isAgingUp = true;
    });

    List<String> events = [];
    events = _character.ageUp();
    _avatarUrl = AvatarAgeRules.getAgeBasedAvatarUrl(
      _character,
      happiness: _character.happiness,
    );

    // Cek kehamilan saat bertambah umur
    if (_character.isPregnant || _character.partnerIsPregnant) {
      // Hitung roll kelahiran (80% berhasil, 20% keguguran)
      int birthRoll = Random().nextInt(100);
      bool isSuccess = birthRoll < 80;

      if (isSuccess) {
        // Logika melahirkan sukses (panggil fungsi lahir)
        _handleBirth(_finishAgeUp);
      } else {
        // Logika keguguran
        _handleMiscarriage(_finishAgeUp);
      }
      return;
    }

    if (!_character.isAlive) {
      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => PopScope(
          canPop: false,
          child: AlertDialog(
            title: const Text('Karakter Meninggal'),
            content: Text('${_character.name} meninggal pada usia ${_character.age} tahun.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  _finishAgeUp();
                },
                child: const Text('Selesai'),
              ),
            ],
          ),
        ),
      );
    } else if (events.isNotEmpty) {
      if (!mounted) return;
      
      final List<String> sicknessEvents = events.where((e) => e.contains('Penyakit Instan')).toList();
      final List<String> otherEvents = events.where((e) => !e.contains('Penyakit Instan')).toList();
      
      if (otherEvents.isNotEmpty) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return PopScope(
              canPop: false,
              child: AlertDialog(
                title: const Row(
                  children: [
                    Icon(Icons.notifications_active, color: Colors.orange, size: 28),
                    SizedBox(width: 8),
                    Text('Kejadian Penting', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: otherEvents.map((e) {
                    final bool isSameSexEvent = e.toLowerCase().contains('gay') || e.toLowerCase().contains('lesbian') || e.contains('🏳️‍🌈');
                    String displayText = e;
                    if (isSameSexEvent) {
                      if (displayText.startsWith('💬')) {
                        displayText = '🏳️‍🌈' + displayText.substring(1);
                      } else if (displayText.startsWith('💍')) {
                        displayText = '🏳️‍🌈' + displayText.substring(1);
                      } else if (displayText.startsWith('🎉')) {
                        displayText = '🏳️‍🌈' + displayText.substring(1);
                      } else if (!displayText.startsWith('🏳️‍🌈')) {
                        displayText = '🏳️‍🌈 ' + displayText;
                      }
                    }
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(displayText, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                    );
                  }).toList(),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _runAgeUpSequence(sicknessEvents, _finishAgeUp);
                    },
                    child: const Text('Mengerti', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            );
          },
        );
      } else {
        _runAgeUpSequence(sicknessEvents, _finishAgeUp);
      }
    } else {
      _runAgeUpSequence([], _finishAgeUp);
    }
  }

  void _handleSicknessSequence(List<String> sicknessList, VoidCallback onDone) {
    if (sicknessList.isEmpty) {
      onDone();
      return;
    }
    final String firstSickness = sicknessList.first;
    _showSicknessModal(firstSickness, () {
      _handleSicknessSequence(sicknessList.sublist(1), onDone);
    });
  }

  void _showSicknessModal(String sicknessEvent, VoidCallback onDone) {
    if (!mounted) return;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: const Row(
            children: [
              Icon(Icons.healing, color: Colors.red, size: 28),
              SizedBox(width: 10),
              Text('Terkena Penyakit 🤒', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch, // Membuat semua button lebar seragam
            children: [
              Text(
                sicknessEvent.contains(': ') ? sicknessEvent.substring(sicknessEvent.indexOf(': ') + 2) : sicknessEvent,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 20),
              const Text(
                'Apa yang ingin kamu lakukan?',
                style: TextStyle(fontSize: 13, fontStyle: FontStyle.italic, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange.shade400,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  Navigator.pop(ctx);
                  _handleTellParents(sicknessEvent, onDone);
                },
                child: const Text('Beritahu Orang Tua', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  Navigator.pop(ctx);
                  // Buka DokterPage
                  DokterMenuHelper.showDokterMenu(context, _character, () {
                    setState(() {});
                    onDone();
                  });
                },
                child: const Text('Pergi ke Dokter', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade500,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  Navigator.pop(ctx);
                  onDone();
                },
                child: const Text('Biarkan saja', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleTellParents(String sicknessEvent, VoidCallback onDone) {
    bool hasParents = (!_character.isMotherDeceased && _character.motherName != null) ||
                      (!_character.isFatherDeceased && _character.fatherName != null);
                      
    if (!hasParents) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Tidak Ada Orang Tua 😔'),
          content: const Text('Kamu tidak memiliki orang tua yang bisa dihubungi saat ini.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                // Karena gagal beritahu ortu, tanya lagi apakah mau ke dokter
                _showSicknessModal(sicknessEvent, onDone);
              },
              child: const Text('Kembali'),
            )
          ],
        ),
      );
      return;
    }
    
    // Logika respon orang tua
    final random = Random();
    final bool isCare = random.nextDouble() < 0.7; // 70% dirawat/dibawa ke dokter
    
    if (isCare) {
      _character.health = (_character.health + 30).clamp(0, 100);
      if (_character.motherRelationship != null) {
        _character.motherRelationship = (_character.motherRelationship! + 10).clamp(0, 100);
      }
      if (_character.fatherRelationship != null) {
        _character.fatherRelationship = (_character.fatherRelationship! + 10).clamp(0, 100);
      }
      setState(() {});
      
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Respons Orang Tua ❤️'),
          content: const Text('Orang tuamu sangat khawatir. Mereka membawamu ke klinik dan merawatmu sampai kondisi kesehatanmu membaik (+30% Kesehatan, +10% Hubungan Orang Tua).'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                onDone();
              },
              child: const Text('Mengerti'),
            )
          ],
        ),
      );
    } else {
      _character.health = (_character.health + 5).clamp(0, 100);
      setState(() {});
      
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Respons Orang Tua 🏠'),
          content: const Text('Orang tuamu menyuruhmu beristirahat di kamar dan membelikanmu obat warung biasa (+5% Kesehatan).'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                onDone();
              },
              child: const Text('Mengerti'),
            )
          ],
        ),
      );
    }
  }

  void _checkAdikRequestMoney(VoidCallback onDone) {
    if (!_character.isAlive || _character.age < 12) {
      onDone();
      return;
    }

    final candidates = _character.siblings.where((sib) {
      final int sibAge = int.tryParse(sib['age'] ?? '0') ?? 0;
      final bool isDeceased = sib['isDeceased'] == 'true';
      final String rel = (sib['relation'] ?? '').toLowerCase();
      final bool isAdik = rel.contains('adik');
      final bool isKakak = rel.contains('kakak');
      
      if (isDeceased) return false;
      if (isAdik) {
        return sibAge >= 6 && sibAge <= 18;
      }
      if (isKakak) {
        // Kakak jika usianya sudah > 12 tahun tidak meminta uang ke user
        return sibAge >= 6 && sibAge <= 12;
      }
      return false;
    }).toList();

    if (candidates.isNotEmpty && Random().nextInt(100) < 20) {
      final candidate = candidates[Random().nextInt(candidates.length)];
      final String name = candidate['name'] ?? 'Saudara';
      final int sibAge = int.tryParse(candidate['age'] ?? '0') ?? 0;
      final String relLabel = candidate['relation'] ?? 'Saudara';
      
      int requestedAmount = 0;
      if (sibAge >= 6 && sibAge <= 11) {
        requestedAmount = Random().nextInt(10) + 1;
      } else if (sibAge >= 12 && sibAge <= 14) {
        requestedAmount = Random().nextInt(31) + 20;
      } else if (sibAge >= 15 && sibAge <= 18) {
        requestedAmount = Random().nextInt(101) + 100;
      }

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          return AlertDialog(
            title: Row(
              children: [
                const Icon(Icons.monetization_on, color: Colors.amber, size: 28),
                const SizedBox(width: 8),
                Text('$name Minta Uang', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ],
            ),
            content: Text(
              '$relLabel, $name (Umur: $sibAge tahun) meminta uang saku sebesar \$$requestedAmount untuk kebutuhan sekolahnya.',
              style: const TextStyle(fontSize: 14),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                  setState(() {
                    int currentRel = int.tryParse(candidate['relationship'] ?? '50') ?? 50;
                    candidate['relationship'] = (currentRel - 8).clamp(0, 100).toString();
                    _character.updateRelationshipValue(name, int.parse(candidate['relationship']!));
                  });
                  showDialog(
                    context: context,
                    builder: (resContext) => AlertDialog(
                      title: const Text('Menolak Permintaan'),
                      content: Text('Kamu menolak memberikan uang kepada $name. Hubungan kalian sedikit merenggang.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(resContext);
                            onDone();
                          },
                          child: const Text('OK'),
                        )
                      ],
                    ),
                  );
                },
                child: const Text('Tolak', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                  if (_character.money < requestedAmount) {
                    showDialog(
                      context: context,
                      builder: (failContext) => AlertDialog(
                        title: const Text('Uang Tidak Cukup'),
                        content: const Text('Uangmu tidak mencukupi untuk memenuhi permintaannya.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(failContext);
                              onDone();
                            },
                            child: const Text('OK'),
                          )
                        ],
                      ),
                    );
                  } else {
                    setState(() {
                      _character.money -= requestedAmount;
                      int currentRel = int.tryParse(candidate['relationship'] ?? '50') ?? 50;
                      candidate['relationship'] = (currentRel + 12).clamp(0, 100).toString();
                      _character.updateRelationshipValue(name, int.parse(candidate['relationship']!));
                      int currentWealth = _character.getTargetWealth(name, candidate['relation'] ?? 'Adik');
                      _character.setTargetWealth(name, candidate['relation'] ?? 'Adik', currentWealth + requestedAmount);
                    });
                    showDialog(
                      context: context,
                      builder: (succContext) => AlertDialog(
                        title: const Text('Permintaan Dipenuhi'),
                        content: Text('Kamu memberikan \$$requestedAmount kepada $name. Dia sangat berterima kasih!'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(succContext);
                              onDone();
                            },
                            child: const Text('OK'),
                          )
                        ],
                      ),
                    );
                  }
                },
                child: const Text('Beri Uang', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
              ),
            ],
          );
        },
      );
    } else {
      onDone();
    }
  }

  void _checkChildrenEvents(VoidCallback onDone) {
    if (!_character.isAlive || _character.children.isEmpty) {
      onDone();
      return;
    }

    final rand = Random();
    final List<Map<String, String>> aliveKids = _character.children.where((c) => c['isDeceased'] != 'true').toList();

    if (aliveKids.isEmpty) {
      onDone();
      return;
    }

    // Ambil satu anak secara acak untuk memicu event agar tidak menumpuk terlalu banyak modal sekaligus
    final child = aliveKids[rand.nextInt(aliveKids.length)];
    final String kidName = child['name'] ?? 'Anak';
    final int childAge = int.tryParse(child['age'] ?? '0') ?? 0;
    final int childIndex = _character.children.indexOf(child);

    // Roll peluang event acak (30% peluang muncul kejadian)
    if (rand.nextInt(100) >= 30) {
      onDone();
      return;
    }

    final int eventRoll = rand.nextInt(5); // 0: Sakit, 1: Minta Uang Jajan/HP, 2: Pacaran, 3: Restu Nikah, 4: Kabar Hamil

    // 1. Logika Anak Sakit (Semua Umur)
    if (eventRoll == 0) {
      final List<String> sicknessTypes = ['Flu Berat 🤒', 'Demam Tinggi 🌡️', 'Demam Berdarah (DBD) 🦟', 'Radang Tenggorokan 🗣️', 'Diare Akut 🚽'];
      final String sickness = sicknessTypes[rand.nextInt(sicknessTypes.length)];
      final int cost = 200 + rand.nextInt(300);

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.healing, color: Colors.red),
              const SizedBox(width: 8),
              Text('Anak Sakit: $kidName 🤒', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          content: Text(
            'Anakmu, $kidName (Umur: $childAge tahun), didiagnosis menderita penyakit $sickness.\n\n'
            'Biaya perawatan medis yang dibutuhkan adalah sebesar \$$cost.',
            style: const TextStyle(fontSize: 14),
          ),
          actions: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () {
                    Navigator.pop(ctx);
                    if (_character.money < cost) {
                      _character.updateRelationshipValue(kidName, -15);
                      showDialog(
                        context: this.context,
                        builder: (resCtx) => AlertDialog(
                          title: const Text('Uang Tidak Cukup 💸', style: TextStyle(fontWeight: FontWeight.bold)),
                          content: const Text('Uangmu tidak mencukupi untuk membiayai pengobatan anakmu. Kondisinya semakin memburuk dan ia merasa kecewa.'),
                          actions: [
                            TextButton(onPressed: () { Navigator.pop(resCtx); onDone(); }, child: const Text('Lanjutkan'))
                          ],
                        ),
                      );
                    } else {
                      _character.money -= cost;
                      _character.updateRelationshipValue(kidName, 20);
                      _character.inbox.add('🏥 Medis Anak: Kamu membayar \$$cost untuk mengobati penyakit $sickness dari $kidName.');
                      setState(() {});
                      showDialog(
                        context: this.context,
                        builder: (resCtx) => AlertDialog(
                          title: const Text('Pengobatan Sukses 🩺', style: TextStyle(fontWeight: FontWeight.bold)),
                          content: Text('Kamu membiayai pengobatan $kidName. Kesehatannya berangsur pulih dan hubungannya denganmu membaik! (+20% hubungan)'),
                          actions: [
                            TextButton(onPressed: () { Navigator.pop(resCtx); onDone(); }, child: const Text('Lanjutkan'))
                          ],
                        ),
                      );
                    }
                  },
                  child: Text('Biayai Pengobatan (\$$cost)', style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    _character.updateRelationshipValue(kidName, -25);
                    _character.inbox.add('💔 Medis Anak: Kamu mengabaikan penyakit $sickness dari $kidName.');
                    setState(() {});
                    showDialog(
                      context: this.context,
                      builder: (resCtx) => AlertDialog(
                        title: const Text('Abaikan Sakit 😔', style: TextStyle(fontWeight: FontWeight.bold)),
                        content: Text('Kamu mengabaikan rasa sakit $kidName. Hubungan kalian memburuk drastis (-25% hubungan).'),
                        actions: [
                          TextButton(onPressed: () { Navigator.pop(resCtx); onDone(); }, child: const Text('Lanjutkan'))
                        ],
                      ),
                    );
                  },
                  child: const Text('Biarkan Saja (Abaikan)', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                ),
              ],
            )
          ],
        ),
      );
    }
    // 2. Logika Minta Uang / Minta Gadget / HP (Usia 6-12 dan Remaja)
    else if (eventRoll == 1) {
      if (childAge >= 6 && childAge <= 12) {
        // Minta uang jajan biasa
        final int amount = 10 + rand.nextInt(20);
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => AlertDialog(
            title: Row(
              children: [
                const Icon(Icons.monetization_on, color: Colors.amber),
                const SizedBox(width: 8),
                Text('Minta Uang Jajan: $kidName 💵', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
            content: Text(
              'Anakmu, $kidName (Umur: $childAge tahun), merengek meminta uang jajan tambahan sebesar \$$amount untuk membeli camilan di sekolah.',
              style: const TextStyle(fontSize: 14),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  _character.updateRelationshipValue(kidName, -10);
                  setState(() {});
                  showDialog(
                    context: this.context,
                    builder: (resCtx) => AlertDialog(
                      title: const Text('Tolak Permintaan 🚫'),
                      content: Text('Kamu menolak memberikan uang jajan. $kidName merengut kesal (-10% hubungan).'),
                      actions: [
                        TextButton(onPressed: () { Navigator.pop(resCtx); onDone(); }, child: const Text('OK'))
                      ],
                    ),
                  );
                },
                child: const Text('Tolak', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  if (_character.money < amount) {
                    showDialog(
                      context: this.context,
                      builder: (resCtx) => AlertDialog(
                        title: const Text('Uang Tidak Cukup 💸'),
                        content: const Text('Uangmu tidak cukup untuk memenuhi permintaan anakmu.'),
                        actions: [
                          TextButton(onPressed: () { Navigator.pop(resCtx); onDone(); }, child: const Text('OK'))
                        ],
                      ),
                    );
                  } else {
                    _character.money -= amount;
                    _character.updateRelationshipValue(kidName, 12);
                    _character.inbox.add('💵 Uang Jajan: Kamu memberikan uang jajan \$$amount kepada $kidName.');
                    setState(() {});
                    showDialog(
                      context: this.context,
                      builder: (resCtx) => AlertDialog(
                        title: const Text('Permintaan Dipenuhi 💖'),
                        content: Text('Kamu memberikan uang jajan kepada $kidName. Dia melompat kegirangan! (+12% hubungan).'),
                        actions: [
                          TextButton(onPressed: () { Navigator.pop(resCtx); onDone(); }, child: const Text('OK'))
                        ],
                      ),
                    );
                  }
                },
                child: const Text('Beri Uang', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );
      } else if (childAge >= 13 && childAge <= 17) {
        // Remaja: Minta Uang Nongkrong / HP Baru
        final bool askForHP = rand.nextBool();
        if (askForHP) {
          final int hpCost = 400 + rand.nextInt(300);
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (ctx) => AlertDialog(
              title: Row(
                children: [
                  const Icon(Icons.phone_android, color: Colors.purple),
                  const SizedBox(width: 8),
                  Text('Minta Gadget: $kidName 📱', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
              content: Text(
                'Anakmu yang sedang beranjak remaja, $kidName (Umur: $childAge tahun), meminta dibelikan smartphone baru seharga \$$hpCost karena HP lamanya sudah lambat dan rusak.',
                style: const TextStyle(fontSize: 14),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    _character.updateRelationshipValue(kidName, -15);
                    setState(() {});
                    showDialog(
                      context: this.context,
                      builder: (resCtx) => AlertDialog(
                        title: const Text('Tolak Permintaan 🚫'),
                        content: Text('Kamu menolak membelikannya HP baru. $kidName mengurung diri di kamarnya karena malu (-15% hubungan).'),
                        actions: [
                          TextButton(onPressed: () { Navigator.pop(resCtx); onDone(); }, child: const Text('OK'))
                        ],
                      ),
                    );
                  },
                  child: const Text('Tolak', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    if (_character.money < hpCost) {
                      showDialog(
                        context: this.context,
                        builder: (resCtx) => AlertDialog(
                          title: const Text('Uang Tidak Cukup 💸'),
                          content: const Text('Kamu tidak memiliki cukup uang untuk membelikan smartphone tersebut.'),
                          actions: [
                            TextButton(onPressed: () { Navigator.pop(resCtx); onDone(); }, child: const Text('OK'))
                          ],
                        ),
                      );
                    } else {
                      _character.money -= hpCost;
                      _character.updateRelationshipValue(kidName, 25);
                      _character.inbox.add('📱 Gadget Anak: Kamu membelikan smartphone baru seharga \$$hpCost untuk $kidName.');
                      setState(() {});
                      showDialog(
                        context: this.context,
                        builder: (resCtx) => AlertDialog(
                          title: const Text('HP Baru Dibeli 📱'),
                          content: Text('Kamu membelikan smartphone baru untuk $kidName. Hubungan kalian meningkat pesat! (+25% hubungan).'),
                          actions: [
                            TextButton(onPressed: () { Navigator.pop(resCtx); onDone(); }, child: const Text('OK'))
                          ],
                        ),
                      );
                    }
                  },
                  child: const Text('Beli HP', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          );
        } else {
          // Minta Uang Nongkrong
          final int hangoutCost = 50 + rand.nextInt(50);
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (ctx) => AlertDialog(
              title: Row(
                children: [
                  const Icon(Icons.people, color: Colors.blue),
                  const SizedBox(width: 8),
                  Text('Minta Uang Nongkrong ☕', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
              content: Text(
                'Anak remajamu, $kidName (Umur: $childAge tahun), meminta uang sebesar \$$hangoutCost agar bisa nongkrong dan jalan-jalan bersama teman-temannya di mall sore ini.',
                style: const TextStyle(fontSize: 14),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    _character.updateRelationshipValue(kidName, -8);
                    setState(() {});
                    showDialog(
                      context: this.context,
                      builder: (resCtx) => AlertDialog(
                        title: const Text('Tolak Permintaan 🚫'),
                        content: Text('Kamu tidak memberi uang jajan nongkrong. Anakmu merengut kesal (-8% hubungan).'),
                        actions: [
                          TextButton(onPressed: () { Navigator.pop(resCtx); onDone(); }, child: const Text('OK'))
                        ],
                      ),
                    );
                  },
                  child: const Text('Tolak', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    if (_character.money < hangoutCost) {
                      showDialog(
                        context: this.context,
                        builder: (resCtx) => AlertDialog(
                          title: const Text('Uang Tidak Cukup 💸'),
                          content: const Text('Uangmu tidak cukup untuk memberi jajan nongkrong.'),
                          actions: [
                            TextButton(onPressed: () { Navigator.pop(resCtx); onDone(); }, child: const Text('OK'))
                          ],
                        ),
                      );
                    } else {
                      _character.money -= hangoutCost;
                      _character.updateRelationshipValue(kidName, 12);
                      _character.inbox.add('☕ Nongkrong Anak: Kamu memberi \$$hangoutCost kepada $kidName untuk nongkrong.');
                      setState(() {});
                      showDialog(
                        context: this.context,
                        builder: (resCtx) => AlertDialog(
                          title: const Text('Uang Nongkrong Diberikan ☕'),
                          content: Text('Kamu memberikan uang jajan nongkrong kepada $kidName. Dia berterima kasih sebelum pergi! (+12% hubungan).'),
                          actions: [
                            TextButton(onPressed: () { Navigator.pop(resCtx); onDone(); }, child: const Text('OK'))
                          ],
                        ),
                      );
                    }
                  },
                  child: const Text('Beri Uang', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          );
        }
      } else {
        onDone();
      }
    }
    // 3. Logika Pacaran Pertama (Remaja 16+)
    else if (eventRoll == 2) {
      if (childAge >= 16 && (child['hasPartner'] ?? 'false') != 'true') {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => AlertDialog(
            title: Row(
              children: [
                const Icon(Icons.favorite, color: Colors.pinkAccent),
                const SizedBox(width: 8),
                Text('Pacaran Pertama: $kidName ❤️', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
            content: Text(
              'Anakmu, $kidName (Umur: $childAge tahun), mengaku tersipu malu bahwa ia sekarang sudah memiliki pacar pertama.\n\n'
              'Dia meminta restu/persetujuan darimu mengenai pacarnya.',
              style: const TextStyle(fontSize: 14),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  _character.updateRelationshipValue(kidName, -30);
                  child['hasPartner'] = 'false';
                  
                  // Efek anak kabur dari rumah (25% peluang)
                  final bool runAway = rand.nextInt(100) < 25;
                  if (runAway) {
                    child['isDeceased'] = 'true'; // Anggap hilang/pergi dari keluarga
                    _character.inbox.add('🚨 Kabur: Karena dilarang pacaran, $kidName kabur dari rumah dan memutus semua hubungan!');
                    _character.happiness = (_character.happiness - 35).clamp(0, 100);
                    setState(() {});
                    showDialog(
                      context: this.context,
                      builder: (resCtx) => AlertDialog(
                        title: const Text('Anak Kabur dari Rumah! 🚨', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                        content: Text('Karena kamu melarang keras hubungan asmaranya, $kidName marah besar, mengemasi barang-barangnya, dan kabur dari rumah! Kamu kehilangan kontak dengannya (-35% kebahagiaan).'),
                        actions: [
                          TextButton(onPressed: () { Navigator.pop(resCtx); onDone(); }, child: const Text('OK'))
                        ],
                      ),
                    );
                  } else {
                    setState(() {});
                    showDialog(
                      context: this.context,
                      builder: (resCtx) => AlertDialog(
                        title: const Text('Melarang Hubungan 🚫'),
                        content: Text('Kamu melarang keras hubungan tersebut. $kidName menangis dan merasa sangat benci padamu (-30% hubungan).'),
                        actions: [
                          TextButton(onPressed: () { Navigator.pop(resCtx); onDone(); }, child: const Text('OK'))
                        ],
                      ),
                    );
                  }
                },
                child: const Text('Larang Keras / Marahi', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  child['hasPartner'] = 'true';
                  _character.updateRelationshipValue(kidName, 30);
                  _character.inbox.add('❤️ Restu Pacaran: Kamu merestui hubungan asmara pertama dari $kidName.');
                  setState(() {});
                  showDialog(
                    context: this.context,
                    builder: (resCtx) => AlertDialog(
                      title: const Text('Restu Diberikan ❤️'),
                      content: Text('Kamu memberi restu hangat untuk hubungan asmaranya. Hubunganmu dengannya meningkat drastis! (+30% hubungan).'),
                      actions: [
                        TextButton(onPressed: () { Navigator.pop(resCtx); onDone(); }, child: const Text('OK'))
                      ],
                    ),
                  );
                },
                child: const Text('Beri Restu Warmly', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );
      } else {
        onDone();
      }
    }
    // 4. Logika Minta Restu Menikah (Usia 20+)
    else if (eventRoll == 3) {
      if (childAge >= 20 && (child['isMarried'] ?? 'false') != 'true') {
        final int weddingCost = 5000 + rand.nextInt(10000);
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => AlertDialog(
            title: Row(
              children: [
                const Icon(Icons.favorite, color: Colors.red),
                const SizedBox(width: 8),
                Text('Minta Restu Menikah: $kidName 💍', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
            content: Text(
              'Anakmu, $kidName (Umur: $childAge tahun), membawa pasangannya ke rumah untuk meminta restu pernikahan dari kamu.\n\n'
              'Pernikahan direncanakan mewah dan membutuhkan biaya sebesar \$$weddingCost dari pihakmu.',
              style: const TextStyle(fontSize: 14),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  _character.updateRelationshipValue(kidName, -20);
                  setState(() {});
                  showDialog(
                    context: this.context,
                    builder: (resCtx) => AlertDialog(
                      title: const Text('Restu Ditolak 🚫'),
                      content: Text('Kamu menolak memberikan restu pernikahan. $kidName merasa sangat terpukul dan menjauhimu (-20% hubungan).'),
                      actions: [
                        TextButton(onPressed: () { Navigator.pop(resCtx); onDone(); }, child: const Text('OK'))
                      ],
                    ),
                  );
                },
                child: const Text('Tolak Restu', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  if (_character.money < weddingCost) {
                    showDialog(
                      context: this.context,
                      builder: (resCtx) => AlertDialog(
                        title: const Text('Uang Tidak Cukup 💸'),
                        content: const Text('Uangmu tidak cukup untuk membiayai resepsi pesta pernikahan anakmu.'),
                        actions: [
                          TextButton(onPressed: () { Navigator.pop(resCtx); onDone(); }, child: const Text('OK'))
                        ],
                      ),
                    );
                  } else {
                    _character.money -= weddingCost;
                    child['isMarried'] = 'true';
                    _character.updateRelationshipValue(kidName, 35);
                    _character.inbox.add('💍 Pernikahan Anak: Kamu membiayai pernikahan $kidName sebesar \$$weddingCost.');
                    setState(() {});
                    showDialog(
                      context: this.context,
                      builder: (resCtx) => AlertDialog(
                        title: const Text('Pernikahan Sukses! 🎉'),
                        content: Text('Kamu merestui dan membiayai resepsi pernikahan $kidName dengan meriah! Hubungan kalian meningkat pesat (+35% hubungan).'),
                        actions: [
                          TextButton(onPressed: () { Navigator.pop(resCtx); onDone(); }, child: const Text('OK'))
                        ],
                      ),
                    );
                  }
                },
                child: Text('Biayai Pernikahan (\$$weddingCost)', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );
      } else {
        onDone();
      }
    }
    // 5. Kabar Kehamilan Anak (Usia 18-35)
    else if (eventRoll == 4) {
      if (childAge >= 18 && childAge <= 35 && (child['pregnantAnnounced'] ?? 'false') != 'true') {
        final bool isMarried = child['isMarried'] == 'true';
        final String relationText = child['gender'] == 'Perempuan' ? 'mengumumkan kehamilannya' : 'mengabarkan bahwa istrinya sedang hamil';
        
        child['pregnantAnnounced'] = 'true';
        _character.inbox.add('🍼 Kabar Cucu: Anakmu, $kidName, $relationText!');
        
        if (!isMarried) {
          // Melahirkan diluar nikah -> Kebahagiaan user turun
          _character.happiness = (_character.happiness - 15).clamp(0, 100);
          setState(() {});
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (ctx) => AlertDialog(
              title: const Row(
                children: [
                  Icon(Icons.child_care, color: Colors.orange),
                  SizedBox(width: 8),
                  Text('Kehamilan di Luar Nikah 🍼', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
              content: Text(
                'Anakmu, $kidName, $relationText!\n\n'
                'Namun, karena mereka belum menikah secara sah, kabar kehamilan ini memicu gosip keluarga besar. Kebahagiaanmu menurun (-15% Kebahagiaan).',
                style: const TextStyle(fontSize: 14),
              ),
              actions: [
                TextButton(onPressed: () { Navigator.pop(ctx); onDone(); }, child: const Text('Mengerti'))
              ],
            ),
          );
        } else {
          _character.happiness = (_character.happiness + 20).clamp(0, 100);
          setState(() {});
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (ctx) => AlertDialog(
              title: const Row(
                children: [
                  Icon(Icons.child_care, color: Colors.green),
                  SizedBox(width: 8),
                  Text('Kabar Cucu Baru! 👶', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
              content: Text(
                'Kabar gembira! Anakmu, $kidName, $relationText!\n\n'
                'Kamu akan segera menimang cucu baru dalam keluarga besar. Kebahagiaanmu melonjak drastis (+20% Kebahagiaan).',
                style: const TextStyle(fontSize: 14),
              ),
              actions: [
                TextButton(onPressed: () { Navigator.pop(ctx); onDone(); }, child: const Text('Selamat! 🎉'))
              ],
            ),
          );
        }
      } else {
        onDone();
      }
    } else {
      onDone();
    }
  }

  void _checkSchoolEnrollmentOptions(VoidCallback onDone) {
    final List<Map<String, String>> kidsToEnroll = [];
    final List<Map<String, String>> kidsGraduated18 = [];

    for (var child in _character.children) {
      final int childAge = int.tryParse(child['age'] ?? '0') ?? 0;
      final String schoolStatusSD = child['schoolSD'] ?? 'Belum Sekolah';
      final String schoolStatusSMP = child['schoolSMP'] ?? 'Belum Sekolah';
      final String schoolStatusSMA = child['schoolSMA'] ?? 'Belum Sekolah';
      final String choice18 = child['choice18'] ?? 'Belum';

      if (childAge == 6 && schoolStatusSD != 'Sekolah Negeri' && schoolStatusSD != 'Sekolah Swasta') {
        kidsToEnroll.add({'name': child['name'] ?? 'Anak', 'age': '6', 'level': 'SD', 'childIndex': _character.children.indexOf(child).toString()});
      } else if (childAge == 12 && schoolStatusSMP != 'Sekolah Negeri' && schoolStatusSMP != 'Sekolah Swasta') {
        kidsToEnroll.add({'name': child['name'] ?? 'Anak', 'age': '12', 'level': 'SMP', 'childIndex': _character.children.indexOf(child).toString()});
      } else if (childAge == 15 && schoolStatusSMA != 'Sekolah Negeri' && schoolStatusSMA != 'Sekolah Swasta') {
        kidsToEnroll.add({'name': child['name'] ?? 'Anak', 'age': '15', 'level': 'SMA', 'childIndex': _character.children.indexOf(child).toString()});
      } else if (childAge == 18 && choice18 == 'Belum') {
        kidsGraduated18.add({'name': child['name'] ?? 'Anak', 'childIndex': _character.children.indexOf(child).toString()});
      }
    }

    void processGraduation18(int idx, VoidCallback finishCallback) {
      if (idx >= kidsGraduated18.length) {
        finishCallback();
        return;
      }
      final kid = kidsGraduated18[idx];
      final String kidName = kid['name']!;
      final int childIndex = int.parse(kid['childIndex']!);

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          final bool isDark = Theme.of(context).brightness == Brightness.dark;
          return PopScope(
            canPop: false,
            child: AlertDialog(
              backgroundColor: isDark ? Colors.grey.shade900 : null,
            title: Row(
              children: [
                Icon(Icons.school, color: Colors.indigo.shade600),
                const SizedBox(width: 8),
                Text('Kelulusan Anak: $kidName 🎓', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
            content: Text(
              'Anakmu, $kidName, telah resmi berusia 18 tahun dan menyelesaikan sekolahnya. Apa yang ingin kamu arahkan untuk masa depannya?',
              style: const TextStyle(fontSize: 14),
            ),
            actions: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      final List<String> allMajors = [
                        'Teknik Informatika', 'Sistem Informasi', 'Teknik Sipil', 'Teknik Elektro', 'Teknik Mesin', 'Arsitektur',
                        'Kedokteran', 'Farmasi', 'Keperawatan',
                        'Manajemen', 'Akuntansi', 'Perbankan & Keuangan',
                        'Hukum', 'Hubungan Internasional', 'Ilmu Komunikasi', 'Psikologi'
                      ];
                      final String randomMajor = allMajors[Random().nextInt(allMajors.length)];
                      
                      _character.children[childIndex]['choice18'] = 'Suruh Kuliah';
                      _character.children[childIndex]['schoolSD'] = 'Kuliah'; // Penanda status kuliah
                      _character.children[childIndex]['schoolSMP'] = 'Kuliah';
                      _character.children[childIndex]['schoolSMA'] = 'Kuliah';
                      _character.children[childIndex]['univMajor'] = randomMajor;
                      _character.inbox.add('🎓 Arah Hidup: Kamu menyuruh $kidName untuk melanjutkan pendidikan ke jenjang Kuliah (Jurusan $randomMajor).');
                      _character.updateRelationshipValue(kidName, 15);
                      setState(() {});
                      showDialog(
                        context: this.context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Keputusan Kuliah 🎓', style: TextStyle(fontWeight: FontWeight.bold)),
                          content: Text('$kidName menuruti saranmu dan mendaftarkan diri ke Universitas mengambil jurusan $randomMajor! Hubungan meningkat (+15% hubungan).'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(ctx);
                                processGraduation18(idx + 1, finishCallback);
                              },
                              child: const Text('Lanjutkan'),
                            )
                          ],
                        ),
                      );
                    },
                    child: const Text('Suruh Kuliah / Sekolah Tinggi', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade700,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      _character.children[childIndex]['choice18'] = 'Suruh Kerja';
                      _character.children[childIndex]['schoolSD'] = 'Bekerja'; // Penanda status bekerja
                      _character.children[childIndex]['schoolSMP'] = 'Bekerja';
                      _character.children[childIndex]['schoolSMA'] = 'Bekerja';
                      _character.inbox.add('💼 Arah Hidup: Kamu menyuruh $kidName untuk mulai bekerja mencari nafkah.');
                      _character.updateRelationshipValue(kidName, 10);
                      setState(() {});
                      showDialog(
                        context: this.context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Keputusan Kerja 💼', style: TextStyle(fontWeight: FontWeight.bold)),
                          content: Text('$kidName mulai menyusun curriculum vitae (CV) dan mencari pekerjaan lowongan terdekat. Hubungan meningkat (+10% hubungan).'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(ctx);
                                processGraduation18(idx + 1, finishCallback);
                              },
                              child: const Text('Lanjutkan'),
                            )
                          ],
                        ),
                      );
                    },
                    child: const Text('Suruh Kerja 💼', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink.shade600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      _character.children[childIndex]['choice18'] = 'Suruh Nikah';
                      _character.inbox.add('💍 Arah Hidup: Kamu menyuruh $kidName untuk segera mencari pasangan hidup dan menikah.');
                      _character.updateRelationshipValue(kidName, -5);
                      setState(() {});
                      showDialog(
                        context: this.context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Suruh Nikah 💍', style: TextStyle(fontWeight: FontWeight.bold)),
                          content: Text('$kidName merasa tertekan atas permintaan menikah muda ini, namun setuju untuk mulai menjalin asmara. Hubungan sedikit menurun (-5% hubungan).'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(ctx);
                                processGraduation18(idx + 1, finishCallback);
                              },
                              child: const Text('Lanjutkan'),
                            )
                          ],
                        ),
                      );
                    },
                    child: const Text('Suruh Nikah 💍', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _character.children[childIndex]['choice18'] = 'Biarkan';
                      _character.inbox.add('🍃 Arah Hidup: Kamu membebaskan $kidName untuk memilih jalannya sendiri.');
                      _character.updateRelationshipValue(kidName, 20);
                      setState(() {});
                      showDialog(
                        context: this.context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Bebaskan Pilihan 🍃', style: TextStyle(fontWeight: FontWeight.bold)),
                          content: Text('$kidName sangat berterima kasih atas kebebasan dan rasa percaya yang kamu berikan! Hubungan meningkat pesat (+20% hubungan).'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(ctx);
                                processGraduation18(idx + 1, finishCallback);
                              },
                              child: const Text('Lanjutkan'),
                            )
                          ],
                        ),
                      );
                    },
                    child: const Text('Biarkan Saja (Bebaskan Pilihan)', style: TextStyle(fontWeight: FontWeight.w600)),
                  ),
                ],
              )
            ],
          ),
          );
        },
      );
    }

    void processKidsEnrollment(int index, VoidCallback next) {
      if (index >= kidsToEnroll.length) {
        processGraduation18(0, next);
        return;
      }
      final kid = kidsToEnroll[index];
      final String kidName = kid['name']!;
      final String schoolLevel = kid['level']!;
      final int childIndex = int.parse(kid['childIndex']!);
      final int childAge = int.parse(kid['age']!);

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => PopScope(
          canPop: false,
          child: AlertDialog(
          title: Row(
            children: [
              Icon(Icons.school, color: Colors.blue.shade700),
              const SizedBox(width: 8),
              Text('Sekolahkan Anak: $schoolLevel', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          content: Text(
            'Anakmu, $kidName, telah memasuki usia $childAge tahun dan siap untuk masuk ke Sekolah $schoolLevel. Pilih jenis sekolah yang ingin kamu daftarkan:',
            style: const TextStyle(fontSize: 14),
          ),
          actions: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    _character.children[childIndex]['school$schoolLevel'] = 'Sekolah Negeri';
                    _character.inbox.add('🏫 Sekolah Anak: $kidName resmi masuk Sekolah Negeri ($schoolLevel) secara gratis.');
                    setState(() {});
                    showDialog(
                      context: this.context,
                      builder: (resContext) => AlertDialog(
                        title: const Text('Pendaftaran Sukses 🎓', style: TextStyle(fontWeight: FontWeight.bold)),
                        content: Text('Kamu berhasil menyekolahkan $kidName ke Sekolah Negeri ($schoolLevel) secara gratis. Anakmu senang sekali!'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(resContext);
                              processKidsEnrollment(index + 1, next);
                            },
                            child: const Text('Lanjutkan'),
                          )
                        ],
                      ),
                    );
                  },
                  child: const Text('Sekolah Negeri (Gratis)', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple.shade600,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    if (_character.money < 1500) {
                      showDialog(
                        context: this.context,
                        builder: (resContext) => AlertDialog(
                          title: const Text('Uang Tidak Cukup 💸', style: TextStyle(fontWeight: FontWeight.bold)),
                          content: const Text('Kamu tidak memiliki cukup uang untuk menyekolahkan anakmu ke Sekolah Swasta (\$1,500).'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(resContext);
                                processKidsEnrollment(index + 1, next);
                              },
                              child: const Text('Lanjutkan'),
                            )
                          ],
                        ),
                      );
                    } else {
                      _character.money -= 1500;
                      _character.children[childIndex]['school$schoolLevel'] = 'Sekolah Swasta';
                      _character.inbox.add('🏫 Sekolah Anak: Kamu membayar \$1,500 untuk menyekolahkan $kidName ke Sekolah Swasta ($schoolLevel).');
                      setState(() {});
                      showDialog(
                        context: this.context,
                        builder: (resContext) => AlertDialog(
                          title: const Text('Pendaftaran Sukses 🎓', style: TextStyle(fontWeight: FontWeight.bold)),
                          content: Text('Kamu membayar \$1,500 untuk menyekolahkan $kidName ke Sekolah Swasta Unggulan ($schoolLevel). Kecerdasan anakmu bertambah!'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(resContext);
                                processKidsEnrollment(index + 1, next);
                              },
                              child: const Text('Lanjutkan'),
                            )
                          ],
                        ),
                      );
                    }
                  },
                  child: const Text('Sekolah Swasta (Berbayar/Premium)', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            )
          ],
        ),
      ),
      );
    }

    final int age = _character.age;
    if (age == 6 || age == 12 || age == 15) {
      String schoolLevel = '';
      if (age == 6) schoolLevel = 'Sekolah Dasar (SD)';
      if (age == 12) schoolLevel = 'Sekolah Menengah Pertama (SMP)';
      if (age == 15) schoolLevel = 'Sekolah Menengah Atas (SMA)';

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => PopScope(
          canPop: false,
          child: AlertDialog(
          title: Row(
            children: [
              Icon(Icons.school, color: Colors.blue.shade700),
              const SizedBox(width: 8),
              Text('Pendaftaran $schoolLevel', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          content: Text(
            'Kamu telah memasuki usia $age tahun dan siap untuk masuk ke $schoolLevel. '
            'Pilih jenis sekolah yang ingin kamu daftarkan:',
            style: const TextStyle(fontSize: 14),
          ),
          actions: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    final String levelKey = age == 6 ? 'SD' : (age == 12 ? 'SMP' : 'SMA');
                    _character.educationHistory[levelKey] = 'Belum Lulus';
                    _character.schoolType = 'Negeri';
                    _character.inbox.add('🏫 Sekolah: Kamu resmi masuk $schoolLevel (Negeri) pada usia $age tahun.');
                    _character.classmates.clear();
                    _character.sdTeachers.clear();
                    _character.smpTeachers.clear();
                    _character.smaTeachers.clear();
                    _character.headmaster = null;
                    _character.bkTeacher = null;
                    SchoolGenerator.generateClassmatesIfEmpty(_character);
                    SchoolGenerator.generateTeachersIfEmpty(_character);
                    setState(() {});
                    processKidsEnrollment(0, onDone);
                  },
                  child: const Text('Sekolah Negeri (Gratis)', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple.shade600,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    final String levelKey = age == 6 ? 'SD' : (age == 12 ? 'SMP' : 'SMA');
                    _character.educationHistory[levelKey] = 'Belum Lulus';
                    _character.schoolType = 'Swasta';
                    _character.inbox.add('🏫 Sekolah: Kamu resmi masuk $schoolLevel (Swasta) pada usia $age tahun.');
                    _character.classmates.clear();
                    _character.sdTeachers.clear();
                    _character.smpTeachers.clear();
                    _character.smaTeachers.clear();
                    _character.headmaster = null;
                    _character.bkTeacher = null;
                    SchoolGenerator.generateClassmatesIfEmpty(_character);
                    SchoolGenerator.generateTeachersIfEmpty(_character);
                    setState(() {});
                    processKidsEnrollment(0, onDone);
                  },
                  child: const Text('Sekolah Swasta (Berbayar/Premium)', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            )
          ],
        ),
      ),
      );
    } else {
      processKidsEnrollment(0, onDone);
    }
  }

  void _checkGraduationOptions([VoidCallback? onDone]) {
    if (_character.age == 18 && _character.univMajor == null && _character.jobName == null) {
      showDialog(
  context: context,
  barrierDismissible: false,
  builder: (dialogContext) {
    final bool isDark = Theme.of(dialogContext).brightness == Brightness.dark;
    return PopScope(
      canPop: false,
      child: AlertDialog(
      backgroundColor: isDark ? Colors.grey.shade900 : null,
      title: Row(
        children: [
          Icon(Icons.school, color: Colors.indigo),
          const SizedBox(width: 8),
          Text(
            'Pilihan Masa Depan 🎓',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
      content: Text(
        'Selamat! Kamu telah resmi lulus dari SMA pada usia 18 tahun. Apa rencana hidupmu selanjutnya?',
        style: TextStyle(
          fontSize: 14,
          color: isDark ? Colors.white70 : Colors.black87,
        ),
      ),
      actions: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                Navigator.pop(dialogContext);
                _checkUniversityGraduationOptions(onDone);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UnivMenuPage(
                      character: _character,
                      onRefresh: () => setState(() {}),
                    ),
                  ),
                );
              },
              child: const Text('Mendaftar Universitas 🎓', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                Navigator.pop(dialogContext);
                _checkUniversityGraduationOptions(onDone);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => KerjaMenuScreen(
                      character: _character,
                      onRefresh: () => setState(() {}),
                    ),
                  ),
                );
              },
              child: const Text('Mencari Pekerjaan 💼', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 8),
            TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                foregroundColor: isDark ? Colors.white70 : Colors.grey.shade700,
              ),
              onPressed: () {
                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Kamu memilih untuk tidak kuliah maupun bekerja saat ini.')),
                );
                _checkUniversityGraduationOptions(onDone);
              },
              child: Text(
                'Tidak Memilih Apapun (Menganggur)',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white70 : Colors.grey.shade700,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
    );
  },
);
    } else {
      _checkUniversityGraduationOptions(onDone);
    }
  }

  void _checkUniversityGraduationOptions([VoidCallback? onDone]) {
    if (_character.justGraduatedStage == 'S1') {
      final String major = _character.justGraduatedMajor ?? '';
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => PopScope(
          canPop: false,
          child: AlertDialog(
          title: Row(
            children: [
              Icon(Icons.school, color: Colors.blue.shade700),
              const SizedBox(width: 8),
              const Text('Kelulusan Kuliah 🎓', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          content: Text(
            '🎓 Kelulusan Kuliah: Selamat! Kamu telah resmi lulus dari jenjang S1 dengan jurusan $major! 🎉\n\n'
            'Pilih langkah selanjutnya untuk masa depanmu:',
            style: const TextStyle(fontSize: 14),
          ),
          actions: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple.shade600,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    _character.justGraduatedStage = null;
                    _checkEsportPromotion(onDone);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UnivMenuPage(
                          character: _character,
                          onRefresh: () => setState(() {}),
                        ),
                      ),
                    );
                  },
                  child: const Text('Lanjut S2 🎓', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    _character.justGraduatedStage = null;
                    _checkEsportPromotion(onDone);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => KerjaMenuScreen(
                          character: _character,
                          onRefresh: () => setState(() {}),
                        ),
                      ),
                    );
                  },
                  child: const Text('Pilih Bekerja 💼', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            )
          ],
        ),
      ),
      );
    } else {
      _checkEsportPromotion(onDone);
    }
  }

  // --- LOGIKA MELAHIRKAN (80%) ---
  void _handleBirth([VoidCallback? onDone]) {
    final Random random = Random();
    final String childGender = random.nextBool() ? 'Laki-laki' : 'Perempuan';
    
    final List<String> boys = (_character.maleFirstNames != null && _character.maleFirstNames!.isNotEmpty) 
        ? _character.maleFirstNames! 
        : Character.globalMaleFirstNames;
    final List<String> girls = (_character.femaleFirstNames != null && _character.femaleFirstNames!.isNotEmpty) 
        ? _character.femaleFirstNames! 
        : Character.globalFemaleFirstNames;
    
    final String childFirstName = childGender == 'Laki-laki' 
        ? (boys.isNotEmpty ? boys[random.nextInt(boys.length)] : '')
        : (girls.isNotEmpty ? girls[random.nextInt(girls.length)] : '');
    
    final List<String> playerParts = _character.name.split(' ');
    final String childLastName = playerParts.length > 1 ? playerParts.last : '';
    final String childName = childLastName.isNotEmpty ? '$childFirstName $childLastName' : childFirstName;

    // Tentukan ayah/ibu dari data kehamilan
    String father = 'Tidak diketahui';
    String mother = 'Tidak diketahui';
    String partnerName = _character.pregnantByPartnerName ?? 'Pasangan';

    if (_character.gender.toLowerCase() == 'laki-laki') {
      father = _character.name;
      mother = partnerName;
    } else {
      father = partnerName;
      mother = _character.name;
    }

    // Tambahkan anak ke daftar children
    _character.children.add({
      'name': childName,
      'gender': childGender,
      'relationship': '80',
      'age': '0',
      'father': father,
      'mother': mother,
      'isDeceased': 'false',
      'trait': 'Sehat',
    });

    // Reset status hamil
    _character.isPregnant = false;
    _character.partnerIsPregnant = false;
    _character.pregnantByPartnerName = null;
    _character.pregnantByPartnerRole = null;

    final bool hasLivingParents = 
        (_character.fatherName != null && !_character.isFatherDeceased) ||
        (_character.motherName != null && !_character.isMotherDeceased) ||
        (_character.stepFatherName != null && !_character.isStepFatherDeceased) ||
        (_character.stepMotherName != null && !_character.isStepMotherDeceased);

    final bool isMarried = _character.partner != null && 
        (_character.partner!['relation'] == 'Suami' || _character.partner!['relation'] == 'Istri');

    // Tampilkan modal keberhasilan lahir
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PopScope(
        canPop: false,
        child: AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.celebration, color: Colors.green, size: 28),
              SizedBox(width: 8),
              Text('Selamat! Bayi Lahir 🍼', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          content: Text(
            'Proses persalinan berjalan lancar!\n\n'
            'Selamat, ${_character.name} telah melahirkan seorang ${childGender == 'Laki-laki' ? 'putra' : 'putri'} bernama $childName.\n\n'
            'Hubunganmu dengan $partnerName semakin erat!',
            style: const TextStyle(fontSize: 14),
          ),
          actions: hasLivingParents
              ? [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _showTellParentsResult(isMarried, onDone);
                    },
                    child: const Text('Beri tahu Orang Tua', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _showHideParentsResult(onDone);
                    },
                    child: const Text('Sembunyikan dari Orang Tua', style: TextStyle(color: Colors.grey)),
                  ),
                ]
              : [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      onDone?.call();
                    },
                    child: const Text('Mengerti', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
        ),
      ),
    );
  }

  void _showTellParentsResult(bool isMarried, [VoidCallback? onDone]) {
    if (!isMarried) {
      // Hamil/Melahirkan di luar nikah -> Ortu marah, hubungan turun
      setState(() {
        if (_character.fatherName != null && !_character.isFatherDeceased) {
          _character.fatherRelationship = (_character.fatherRelationship! - 40).clamp(0, 100);
        }
        if (_character.motherName != null && !_character.isMotherDeceased) {
          _character.motherRelationship = (_character.motherRelationship! - 40).clamp(0, 100);
        }
        if (_character.stepFatherName != null && !_character.isStepFatherDeceased) {
          _character.stepFatherRelationship = (_character.stepFatherRelationship! - 40).clamp(0, 100);
        }
        if (_character.stepMotherName != null && !_character.isStepMotherDeceased) {
          _character.stepMotherRelationship = (_character.stepMotherRelationship! - 40).clamp(0, 100);
        }
      });

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => PopScope(
          canPop: false,
          child: AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.sentiment_very_dissatisfied, color: Colors.red, size: 28),
                SizedBox(width: 8),
                Text('Orang Tua Marah! 😡', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            content: const Text(
              'Orang tuamu sangat terkejut dan marah besar mengetahui kamu melahirkan anak di luar nikah!\n\n'
              'Hubungan kalian memburuk secara drastis (-40% hubungan).',
              style: TextStyle(fontSize: 14),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onDone?.call();
                },
                child: const Text('Mengerti', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      );
    } else {
      // Menikah -> Ortu senang, hubungan naik
      setState(() {
        if (_character.fatherName != null && !_character.isFatherDeceased) {
          _character.fatherRelationship = (_character.fatherRelationship! + 15).clamp(0, 100);
        }
        if (_character.motherName != null && !_character.isMotherDeceased) {
          _character.motherRelationship = (_character.motherRelationship! + 15).clamp(0, 100);
        }
        if (_character.stepFatherName != null && !_character.isStepFatherDeceased) {
          _character.stepFatherRelationship = (_character.stepFatherRelationship! + 15).clamp(0, 100);
        }
        if (_character.stepMotherName != null && !_character.isStepMotherDeceased) {
          _character.stepMotherRelationship = (_character.stepMotherRelationship! + 15).clamp(0, 100);
        }
      });

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => PopScope(
          canPop: false,
          child: AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.sentiment_very_satisfied, color: Colors.green, size: 28),
                SizedBox(width: 8),
                Text('Orang Tua Senang! 🥰', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            content: const Text(
              'Orang tuamu sangat bahagia menyambut kelahiran cucu baru mereka!\n\n'
              'Hubungan kalian semakin erat (+15% hubungan).',
              style: TextStyle(fontSize: 14),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onDone?.call();
                },
                child: const Text('Mengerti', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      );
    }
  }

  void _showHideParentsResult([VoidCallback? onDone]) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PopScope(
        canPop: false,
        child: AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.vpn_key, color: Colors.blueGrey, size: 28),
              SizedBox(width: 8),
              Text('Rahasia Terjaga 🤫', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          content: const Text(
            'Kamu memilih untuk merahasiakan kelahiran anakmu dari orang tua demi menghindari konflik atau ketegangan.',
            style: TextStyle(fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onDone?.call();
              },
              child: const Text('Mengerti', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  // --- LOGIKA KEGUGURAN (20%) ---
  void _handleMiscarriage([VoidCallback? onDone]) {
    String partnerName = _character.pregnantByPartnerName ?? 'Pasangan';

    // Reset status hamil
    _character.isPregnant = false;
    _character.partnerIsPregnant = false;
    _character.pregnantByPartnerName = null;
    _character.pregnantByPartnerRole = null;

    // Penalti kebahagiaan
    _character.happiness = (_character.happiness - 40).clamp(0, 100);

    // Tampilkan modal keguguran
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PopScope(
        canPop: false,
        child: AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.warning, color: Colors.red, size: 28),
              SizedBox(width: 8),
              Text('Keguguran 💔', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          content: Text(
            'Kabar duka menyelimuti keluarga.\n\n'
            'Sayangnya, kehamilan yang dijalani bersama $partnerName tidak berhasil. '
            'Proses persalinan berakhir dengan keguguran.\n\n'
            'Kebahagiaanmu turun drastis (-40%).\n\n'
            'Sabar ya, semoga ada rezeki lain nanti.',
            style: const TextStyle(fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onDone?.call();
              },
              child: const Text('Mengerti', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  // --- LOGIKA NOTIFIKASI AJAKAN KELUARGA ---
  void _checkEsportPromotion([VoidCallback? onDone]) {
    final age = _character.age;
    final job = _character.jobName ?? '';
    if (job.startsWith('Talent Esports') && (age == 17 || age == 18)) {
      if (Random().nextDouble() < 0.70) {
        String team = '';
        if (job.contains('(') && job.contains(')')) {
          team = job.substring(job.indexOf('(') + 1, job.indexOf(')'));
        }
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => PopScope(
            canPop: false,
            child: AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              title: const Row(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 28),
                  SizedBox(width: 10),
                  Text('Tawaran Promosi BA! 🌟', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              content: Text(
                'Manajemen $team sangat puas dengan kinerjamu sebagai Talent. Mereka menawarkanmu naik jabatan menjadi Brand Ambassador Esport ($team) dengan gaji \$2500/tahun!',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    setState(() {
                      _character.setJob('Brand Ambassador Esport ($team)', 2500);
                    });
                    _checkActiveProposal(onDone);
                  },
                  child: const Text('Terima Tawaran', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    _checkActiveProposal(onDone);
                  },
                  child: const Text('Tolak', style: TextStyle(color: Colors.grey)),
                ),
              ],
            ),
          ),
        );
        return;
      }
    }
    _checkActiveProposal(onDone);
  }

  void _checkActiveProposal([VoidCallback? onDone]) {
    if (_character.activeProposal == null) {
      _checkGlassesNeed(onDone);
      return;
    }
    
    final proposal = _character.activeProposal!;
    final String partnerName = proposal['name'];
    final String type = proposal['type']; // 'Ajak Pacaran' atau 'Bercinta'
    final String relation = proposal['relation'];
    final String partnerGender = (proposal['gender'] ?? 'Laki-laki').trim().toLowerCase();
    final String myGender = _character.gender.trim().toLowerCase();
    String dialogTitle = '';
    String dialogBody = '';

    final String role = proposal['role'] ?? 'Keluarga';

    // Parsing nama bersih dan relasi berakhiran "-mu"
    String cleanName = partnerName;
    String relationWithMu = relation;

    if (partnerName.contains('(') && partnerName.endsWith(')')) {
      final int openParen = partnerName.indexOf('(');
      final String contentInside = partnerName.substring(openParen + 1, partnerName.length - 1).trim();
      final String prefixPart = partnerName.substring(0, openParen).trim();
      
      if (relation.toLowerCase().startsWith(prefixPart.toLowerCase())) {
        cleanName = contentInside;
      } else {
        cleanName = prefixPart;
      }
    }

    final String relLower = relation.toLowerCase();
    if (type == 'Masturbasi') {
      // Ambil data dari proposal sebelum di-clear
      final String propGender = partnerGender;
      _character.activeProposal = null;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        AjakanMasturbasiDialog.show(
          context: context,
          character: _character,
          relationType: relation,
          viewerName: cleanName,
          targetGender: propGender,
          onComplete: () {
            setState(() {});
            _checkGlassesNeed();
          },
        );
      });
      return;
    }

    // --- WIDGET BADGE UNTUK LOKASI & WAKTU INTIM (VERSI TERANG) ---
    // --- WIDGET BADGE UNTUK LOKASI & WAKTU INTIM (MENGIKUTI STYLE MASTURBASI) ---
Widget _buildIntimBadge(IconData icon, String label, Color color) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(
      color: color.withOpacity(0.10),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: color.withOpacity(0.35)),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    ),
  );
}
  
    if (relLower == 'ayah' || relLower == 'ayah kandung') {
      relationWithMu = 'Ayahmu';
    } else if (relLower == 'ibu' || relLower == 'ibu kandung') {
      relationWithMu = 'Ibumu';
    } else if (relLower == 'ayah tiri') {
      relationWithMu = 'Ayah Tirimu';
    } else if (relLower == 'ibu tiri') {
      relationWithMu = 'Ibu Tirimu';
    } else if (relLower == 'kakak laki-laki') {
      relationWithMu = 'Kakak Laki-lakimu';
    } else if (relLower == 'kakak perempuan') {
      relationWithMu = 'Kakak Perempuanmu';
    } else if (relLower == 'adik laki-laki') {
      relationWithMu = 'Adik Laki-lakimu';
    } else if (relLower == 'adik perempuan') {
      relationWithMu = 'Adik Perempuanmu';
    } else if (relLower == 'paman') {
      relationWithMu = 'Pamanmu';
    } else if (relLower == 'bibi') {
      relationWithMu = 'Bibimu';
    } else if (relLower == 'sepupu') {
      relationWithMu = 'Sepupumu';
    } else if (relLower == 'kakek') {
      relationWithMu = 'Kakekmu';
    } else if (relLower == 'nenek') {
      relationWithMu = 'Nenekmu';
    } else {
      relationWithMu = '${relation}mu';
    }

    if (type == 'Lamar Nikah') {
      dialogTitle = 'Lamaran Pernikahan! 💍';
      final String who = (relLower == 'pacar' || relLower.isEmpty) ? partnerName : '$relationWithMu, $partnerName';
      dialogBody = '$who ingin mengajakmu bertunangan dan berkomitmen lebih serius! Apakah kamu mau menerima lamarannya dan menjadi tunangannya?';
    } else if (type == 'Rencanakan Nikah') {
      dialogTitle = 'Ajakan Menikah! 💒';
      final String who = (relLower == 'pacar' || relLower.isEmpty) ? partnerName : '$relationWithMu, $partnerName';
      dialogBody = '$who ingin mengajak kalian untuk segera menikah dan meresmikan hubungan kalian! Apakah kamu mau menyetujui rencana pernikahan ini?';
    } else if (type == 'Ajak 3some') {
      dialogTitle = 'Ajakan 3some! 🔥';
      dialogBody = '$partnerName mengajakmu dan pasanganmu yang lain untuk melakukan hubungan intim threesome secara bersama-sama. Apakah kamu mau menerima ajakan threesome ini?';
    } else if (role == 'Guru' || role == 'Dosen' || role == 'Kepala Sekolah' || role == 'Teman Sekelas' || role == 'Teman Kuliah' || role == 'Rekan Kerja' || role == 'Brand Ambassador' || role == 'Pro Player' || role == 'Talent Esports' || role == 'CEO') {
      final isSameSex = myGender == partnerGender;
      final orientationType = isSameSex ? (myGender == 'laki-laki' ? 'Gay' : 'Lesbian') : '';
      
      final String labelWithMu;
      // Logika cerdas untuk menampilkan Mapel / Role spesifik Guru
      if (role == 'Guru' || role == 'Guru BK' || relation.contains('Guru')) {
        // Cek apakah relation mengandung kata "Guru" dan ada mapel setelahnya
        // Contoh relation: "Guru Matematika", "Guru BK", "Guru IPA"
        if (relation.toLowerCase().contains('bk')) {
          labelWithMu = 'Guru BK-mu';
        } else if (relation.contains(' ')) {
          // Ambil kata setelah "Guru " (misal: Matematika, IPA, Bahasa Inggris)
          final List<String> parts = relation.split(' ');
          final String mapel = parts.sublist(1).join(' ');
          labelWithMu = 'Guru $mapel-mu';
        } else {
          labelWithMu = 'Guru-mu';
        }
      } 
      else if (role == 'Dosen') labelWithMu = 'Dosenmu';
      else if (role == 'Kepala Sekolah') labelWithMu = 'Kepala Sekolahmu';
      else if (role == 'Teman Sekelas') labelWithMu = 'Teman Sekelasmu';
      else if (role == 'Teman Kuliah') labelWithMu = 'Teman Kuliahmu';
      else if (role == 'Rekan Kerja') labelWithMu = 'Rekan Kerjamu';
      else if (role == 'Brand Ambassador') labelWithMu = 'Brand Ambassador-mu';
      else if (role == 'Pro Player') labelWithMu = 'Rekan Pro Player-mu';
      else if (role == 'Talent Esports') labelWithMu = 'Rekan Talent-mu';
      else if (role == 'CEO') labelWithMu = 'CEO-mu';
      else labelWithMu = '${role}mu';

      if (type == 'Ajak Pacaran') {
        dialogTitle = orientationType.isNotEmpty ? 'Ajakan $orientationType (Pacaran)!' : 'Ajakan Pacaran!';
        dialogBody = '$labelWithMu, $cleanName secara langsung mengajakmu untuk berpacaran ${orientationType.isNotEmpty ? "sesama jenis ($orientationType)" : ""}. Apakah kamu mau menerima ajakan pacaran tersebut?';
      } else {
        dialogTitle = orientationType.isNotEmpty ? 'Ajakan $orientationType (Bercinta)!' : 'Ajakan Berhubungan Intim!';
        dialogBody = '$labelWithMu, $cleanName secara terang-terangan mengajakmu untuk bersetubuh dan melakukan hubungan intim / make love ${orientationType.isNotEmpty ? "sesama jenis ($orientationType)" : ""}. Apakah kamu mau menerima ajakan bercinta ini?';
      }
    } else {
      if (myGender == 'laki-laki' && partnerGender == 'laki-laki') {
        dialogTitle = type == 'Ajak Pacaran' ? 'Ajakan Gay (Pacaran)!' : 'Ajakan Gay (Bercinta)!';
        dialogBody = type == 'Ajak Pacaran'
            ? '$relationWithMu, $cleanName secara langsung mengajakmu untuk berkomitmen dalam hubungan pacaran sesama jenis (Gay) secara diam-diam. Apakah kamu mau menerima ajakan pacaran tersebut?'
            : '$relationWithMu, $cleanName secara terang-terangan mengajakmu untuk bersetubuh dan melakukan hubungan intim / make love sesama jenis (Gay) secara rahasia. Apakah kamu mau menerima ajakan bercinta tersebut?';
      } else if (myGender == 'perempuan' && partnerGender == 'perempuan') {
        dialogTitle = type == 'Ajak Pacaran' ? 'Ajakan Lesbian (Pacaran)!' : 'Ajakan Lesbian (Bercinta)!';
        dialogBody = type == 'Ajak Pacaran'
            ? '$relationWithMu, $cleanName secara langsung mengajakmu untuk berkomitmen dalam hubungan pacaran sesama jenis (Lesbian) secara diam-diam. Apakah kamu mau menerima ajakan pacaran tersebut?'
            : '$relationWithMu, $cleanName secara terang-terangan mengajakmu untuk bersetubuh dan melakukan hubungan intim / make love sesama jenis (Lesbian) secara rahasia. Apakah kamu mau menerima ajakan bercinta tersebut?';
      } else {
        dialogTitle = type == 'Ajak Pacaran' ? 'Ajakan Pacaran!' : 'Ajakan Berhubungan Intim!';
        dialogBody = type == 'Ajak Pacaran'
            ? '$relationWithMu, $cleanName secara langsung mengajakmu untuk berkomitmen dalam hubungan berpacaran secara diam-diam. Apakah kamu mau menerima ajakan pacaran tersebut?'
            : '$relationWithMu, $cleanName secara terang-terangan mengajakmu untuk bersetubuh dan melakukan hubungan intim / make love secara rahasia malam ini. Apakah kamu mau menerima ajakan bercinta tersebut?';
      }
    }
    
    if (!mounted) return;

    final String relCheck = relation.toLowerCase();
    final bool isParent = relCheck == 'ayah' || relCheck == 'ibu' ||
                          relCheck == 'ayah kandung' || relCheck == 'ibu kandung' ||
                          relCheck == 'ayah tiri' || relCheck == 'ibu tiri' ||
                          relCheck == 'ayah (cerai)' || relCheck == 'ibu (cerai)';
    final bool isFatherProposal = isParent && relCheck.contains('ayah');
    final bool isMotherProposal = isParent && relCheck.contains('ibu');
    final bool isGrandfatherProposal = false;

    bool showReportToMother = (isFatherProposal || isGrandfatherProposal) &&
        (type == 'Ajak Pacaran' || type == 'Bercinta') &&
        (_character.motherName != null && !_character.isMotherDeceased);

    if (_character.gender.toLowerCase() == 'perempuan' &&
        isFatherProposal &&
        (_character.isFatherDivorced || _character.isMotherDivorced) &&
        _character.custodyParent == 'Ayah') {
      showReportToMother = false;
    }

    bool showReportToFather = isMotherProposal &&
        (type == 'Ajak Pacaran' || type == 'Bercinta') &&
        ((_character.fatherName != null && !_character.isFatherDeceased && !_character.isFatherImprisoned) ||
         (_character.stepFatherName != null && !_character.isStepFatherDeceased));

    if (_character.gender.toLowerCase() == 'laki-laki' &&
        isMotherProposal &&
        (_character.isMotherDivorced || _character.isFatherDivorced) &&
        _character.custodyParent == 'Ibu') {
      showReportToFather = false;
    }

    if (_character.partner != null) {
      final String pName = _character.partner!['name']!.toLowerCase();
      if (_character.fatherName != null && (pName.contains(_character.fatherName!.toLowerCase()) || _character.fatherName!.toLowerCase().contains(pName))) {
        showReportToFather = false;
      }
      if (_character.motherName != null && (pName.contains(_character.motherName!.toLowerCase()) || _character.motherName!.toLowerCase().contains(pName))) {
        showReportToMother = false;
      }
    }

    final bool showReportToHeadmaster = (role == 'Guru' || role == 'Dosen' || relCheck.contains('guru') || relCheck.contains('dosen')) &&
        (type == 'Ajak Pacaran' || type == 'Bercinta');

    final bool showReportToTeacher = (role == 'Kepala Sekolah' || relCheck.contains('kepala sekolah')) &&
        (type == 'Ajak Pacaran' || type == 'Bercinta');

    // Pre-generate lokasi & waktu secara acak untuk ajakan bercinta (partner sudah memilih)
    const List<Map<String, dynamic>> _lokasiListIntim = [
      {'name': 'Di Kamar Tidur', 'icon': 0xe283},   // Icons.bed
      {'name': 'Di Kamar Mandi', 'icon': 0xe1c0},   // Icons.bathtub
      {'name': 'Di Ruang Tamu', 'icon': 0xe54f},    // Icons.chair
      {'name': 'Di Mobil', 'icon': 0xe1b9},         // Icons.directions_car
      {'name': 'Di Hotel', 'icon': 0xe3b8},         // Icons.hotel
    ];
    const List<Map<String, dynamic>> _waktuListIntim = [
      {'name': 'Pagi', 'icon': 0xef50},    // Icons.light_mode
      {'name': 'Siang', 'icon': 0xef3d},   // Icons.wb_sunny
      {'name': 'Sore', 'icon': 0xef3f},    // Icons.wb_twilight
      {'name': 'Malam', 'icon': 0xef4a},   // Icons.nightlight_round
    ];
    final _randIntim = Random();
    final String preGeneratedLokasiIntim = type == 'Bercinta'
        ? (_lokasiListIntim[_randIntim.nextInt(_lokasiListIntim.length)]['name'] as String)
        : '';
    final String preGeneratedWaktuIntim = type == 'Bercinta'
        ? (_waktuListIntim[_randIntim.nextInt(_waktuListIntim.length)]['name'] as String)
        : '';
    final Map<String, IconData> _lokasiIkonMap = {
      'Di Kamar Tidur': Icons.bed,
      'Di Kamar Mandi': Icons.bathtub,
      'Di Ruang Tamu': Icons.chair,
      'Di Mobil': Icons.directions_car,
      'Di Hotel': Icons.hotel,
    };
    final Map<String, IconData> _waktuIkonMap = {
      'Pagi': Icons.light_mode,
      'Siang': Icons.wb_sunny,
      'Sore': Icons.wb_twilight,
      'Malam': Icons.nightlight_round,
    };

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final bool isGayOrLesbian = dialogTitle.contains('Gay') || dialogTitle.contains('Lesbian');
        return PopScope(
          canPop: false,
          child: AlertDialog(
          title: Row(
            children: [
              isGayOrLesbian
                  ? const Text('🏳️‍🌈', style: TextStyle(fontSize: 28))
                  : Icon(type == 'Ajak Pacaran' ? Icons.favorite : Icons.heart_broken, color: Colors.pink, size: 28),
              const SizedBox(width: 8),
              Text(dialogTitle, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ],
          ),
          content: (type == 'Bercinta' || type == 'Bersetubuh') && preGeneratedLokasiIntim.isNotEmpty
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(dialogBody, style: const TextStyle(fontSize: 14)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _buildIntimBadge(
                          _lokasiIkonMap[preGeneratedLokasiIntim] ?? Icons.location_on,
                          preGeneratedLokasiIntim,
                          Colors.deepPurple,
                        ),
                        const SizedBox(width: 8),
                        _buildIntimBadge(
                          _waktuIkonMap[preGeneratedWaktuIntim] ?? Icons.access_time,
                          preGeneratedWaktuIntim,
                          Colors.blue.shade700,
                        ),
                      ],
                    ),
                  ],
                )
              : Text(dialogBody, style: const TextStyle(fontSize: 14)),
          actions: [
            if (showReportToMother)
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _executeReportParent(context, partnerName, relation, 'Ibu');
                },
                child: Text(
                  'Laporkan ke Ibu',
                  style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
                ),
              ),
            if (showReportToFather)
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  final String reportTarget = (_character.fatherName != null && !_character.isFatherDeceased && !_character.isFatherImprisoned) ? 'Ayah' : 'Ayah Tiri';
                  _executeReportParent(context, partnerName, relation, reportTarget);
                },
                child: Text(
                  (_character.fatherName != null && !_character.isFatherDeceased && !_character.isFatherImprisoned)
                      ? 'Laporkan ke Ayah'
                      : 'Laporkan ke Ayah Tiri',
                  style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
                ),
              ),
            if (showReportToHeadmaster)
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _executeReportStaff(context, cleanName, role);
                },
                child: const Text(
                  'Laporkan ke Kepala Sekolah',
                  style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
                ),
              ),
            if (showReportToTeacher)
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _executeReportStaff(context, cleanName, role);
                },
                child: const Text(
                  'Laporkan ke Guru',
                  style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
                ),
              ),
            if (_character.partner != null &&
                _character.partner!['name'] != partnerName &&
                !partnerName.contains(_character.partner!['name']!) &&
                !_character.partner!['name']!.contains(partnerName) &&
                (type == 'Ajak Pacaran' || type == 'Bercinta'))
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    _character.activeProposal = null;
                  });

                  BeritahuPacarHelper.executeTellFirstPartner(
                    context: context,
                    character: _character,
                    firstPartnerName: _character.partner!['name']!,
                    secondPartnerName: partnerName,
                    isBercinta: type == 'Bercinta',
                    proposalData: proposal,
                    onComplete: () {
                      setState(() {});
                      _checkGlassesNeed();
                    },
                  );
                },
                child: Text(
                  'Beri tahu ${_character.partner!['name']}',
                  style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
                ),
              ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                if (type == 'Ajak 3some') {
                  setState(() {
                    if (_character.partner != null) {
                      int rel = int.tryParse(_character.partner!['relationship'] ?? '50') ?? 50;
                      _character.partner!['relationship'] = (rel + 20).clamp(0, 100).toString();
                    }
                    if (_character.secondPartner != null) {
                      int rel = int.tryParse(_character.secondPartner!['relationship'] ?? '50') ?? 50;
                      _character.secondPartner!['relationship'] = (rel + 20).clamp(0, 100).toString();
                    }
                    if (_character.thirdPartner != null) {
                      int rel = int.tryParse(_character.thirdPartner!['relationship'] ?? '50') ?? 50;
                      _character.thirdPartner!['relationship'] = (rel + 20).clamp(0, 100).toString();
                    }
                    if (_character.fourthPartner != null) {
                      int rel = int.tryParse(_character.fourthPartner!['relationship'] ?? '50') ?? 50;
                      _character.fourthPartner!['relationship'] = (rel + 20).clamp(0, 100).toString();
                    }
                    if (_character.fifthPartner != null) {
                      int rel = int.tryParse(_character.fifthPartner!['relationship'] ?? '50') ?? 50;
                      _character.fifthPartner!['relationship'] = (rel + 20).clamp(0, 100).toString();
                    }

                    _character.happiness = (_character.happiness + 30).clamp(0, 100);
                    _character.inbox.add('🔥 Sukses 3some: Kamu menerima ajakan 3some dari $partnerName!');
                    _character.activeProposal = null;
                  });

                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Row(
                        children: [
                          Icon(Icons.bolt, color: Colors.purple),
                          SizedBox(width: 8),
                          Text('Sukses Fantastis! 🔥', style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      content: const Text(
                        'Pengalaman 3some kalian berjalan sangat memuaskan dan menyenangkan!',
                        style: TextStyle(fontSize: 14),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _checkGlassesNeed(onDone);
                          },
                          child: const Text('OK', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  );
                } else if (type == 'Lamar Nikah') {
                  setState(() {
                    if (_character.partner != null && _character.partner!['name'] == partnerName) {
                      _character.partner!['relation'] = 'Tunangan';
                    } else if (_character.secondPartner != null && _character.secondPartner!['name'] == partnerName) {
                      _character.secondPartner!['relation'] = 'Tunangan';
                    } else if (_character.thirdPartner != null && _character.thirdPartner!['name'] == partnerName) {
                      _character.thirdPartner!['relation'] = 'Tunangan';
                    } else if (_character.fourthPartner != null && _character.fourthPartner!['name'] == partnerName) {
                      _character.fourthPartner!['relation'] = 'Tunangan';
                    } else if (_character.fifthPartner != null && _character.fifthPartner!['name'] == partnerName) {
                      _character.fifthPartner!['relation'] = 'Tunangan';
                    }
                    for (var sp in _character.secretPartners) {
                      if (sp['name'] == partnerName) sp['relation'] = 'Tunangan';
                    }
                    final String who = (relLower == 'pacar' || relLower.isEmpty)
                        ? partnerName
                        : '$relationWithMu ($partnerName)';
                    _character.inbox.add(
                      '💍 Pertunangan: Kamu menerima lamaran dari $who! Kalian kini resmi bertunangan. Rencanakan pernikahan kalian bersama!'
                    );
                    _character.happiness = (_character.happiness + 25).clamp(0, 100);
                    _character.activeProposal = null;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('💍 Selamat! Kamu kini bertunangan dengan $partnerName!'),
                      backgroundColor: Colors.pinkAccent,
                    ),
                  );
                  _checkGlassesNeed(onDone);
                } else if (type == 'Rencanakan Nikah') {
                  setState(() {
                    final spouseRelation = partnerGender == 'perempuan' ? 'Istri' : 'Suami';
                    if (_character.partner != null && _character.partner!['name'] == partnerName) {
                      _character.partner!['relation'] = spouseRelation;
                    } else if (_character.secondPartner != null && _character.secondPartner!['name'] == partnerName) {
                      _character.secondPartner!['relation'] = spouseRelation;
                    } else if (_character.thirdPartner != null && _character.thirdPartner!['name'] == partnerName) {
                      _character.thirdPartner!['relation'] = spouseRelation;
                    } else if (_character.fourthPartner != null && _character.fourthPartner!['name'] == partnerName) {
                      _character.fourthPartner!['relation'] = spouseRelation;
                    } else if (_character.fifthPartner != null && _character.fifthPartner!['name'] == partnerName) {
                      _character.fifthPartner!['relation'] = spouseRelation;
                    }
                    for (var sp in _character.secretPartners) {
                      if (sp['name'] == partnerName) sp['relation'] = spouseRelation;
                    }
                    final String who = (relLower == 'pacar' || relLower.isEmpty)
                        ? partnerName
                        : '$relationWithMu ($partnerName)';
                    _character.inbox.add(
                      '💒 Pernikahan: Kamu resmi menikah dengan $who! Selamat menjalani kehidupan bersama!'
                    );
                    _character.happiness = (_character.happiness + 40).clamp(0, 100);
                    _character.activeProposal = null;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('💒 Selamat! Kamu kini resmi menikah dengan $partnerName!'),
                      backgroundColor: Colors.pink,
                    ),
                  );
                  _checkGlassesNeed(onDone);
                } else if (type == 'Ajak Pacaran') {
                  setState(() {
                    final String relationRole = (_character.partner != null && !_character.isAnyPartnerNameMatching(partnerName)) ? 'Pacar (Selingkuhan)' : (role == 'Guru' ? 'Pacar (Guru)' : 'Pacar');

                    int initialRelationship = 50;
                    final String lowerCleanName = cleanName.toLowerCase();
                    if (_character.motherName != null &&
                        _character.motherName!.toLowerCase() == lowerCleanName) {
                      initialRelationship = _character.motherRelationship ?? 50;
                    } else if (_character.fatherName != null &&
                        _character.fatherName!.toLowerCase() == lowerCleanName) {
                      initialRelationship = _character.fatherRelationship ?? 50;
                    } else if (_character.stepMotherName != null &&
                        _character.stepMotherName!.toLowerCase() == lowerCleanName) {
                      initialRelationship = _character.stepMotherRelationship ?? 50;
                    } else if (_character.stepFatherName != null &&
                        _character.stepFatherName!.toLowerCase() == lowerCleanName) {
                      initialRelationship = _character.stepFatherRelationship ?? 50;
                    }

                    final String? familySkinColor = () {
                      final String lowerName = partnerName.toLowerCase();
                      if (_character.fatherName != null && _character.fatherName!.toLowerCase() == lowerName) {
                        return _character.fatherSkinColor;
                      }
                      if (_character.motherName != null && _character.motherName!.toLowerCase() == lowerName) {
                        return _character.motherSkinColor;
                      }
                      if (_character.stepFatherName != null && _character.stepFatherName!.toLowerCase() == lowerName) {
                        return _character.stepFatherSkinColor;
                      }
                      if (_character.stepMotherName != null && _character.stepMotherName!.toLowerCase() == lowerName) {
                        return _character.stepMotherSkinColor;
                      }
                      for (var sib in _character.siblings) {
                        final String sibName = sib['name'] ?? '';
                        if (sibName.toLowerCase() == lowerName) {
                          return sib['skinColor'];
                        }
                      }
                      return null;
                    }();

                    final Map<String, String> newPartnerData = {
                      'name': partnerName,
                      'gender': proposal['gender']?.toString() ?? 'Perempuan',
                      'age': proposal['age']?.toString() ?? '20',
                      'relationship': initialRelationship.toString(),
                      'relation': relationRole,
                      if (familySkinColor != null) 'skinColor': familySkinColor,
                    };

                    _character.addPartnerToFreeSlot(newPartnerData);

                    if (_character.partner != null && !_character.isAnyPartnerNameMatching(partnerName)) {
                      _character.inbox.add(
                        '🤫 Rahasia: Kamu menerima ajakan pacaran dari $partnerName sebagai selingkuhan!'
                      );
                    } else {
                      _character.inbox.add(
                        '💖 Hubungan Baru: Kamu menerima ajakan pacaran dari $role-mu, $partnerName. Sekarang kalian resmi berpacaran.'
                      );
                    }

                    _character.activeProposal = null;
                  });

                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text((_character.partner != null && !_character.isAnyPartnerNameMatching(partnerName))
                          ? '🤫 Hubungan Rahasia dimulai dengan $partnerName!'
                          : '💖 Kamu menerima ajakan dari $partnerName!'),
                      backgroundColor: Colors.pink,
                    ),
                  );
                  _checkGlassesNeed(onDone);
                } else {
                  _showIncomingCondomDialog(proposal);
                }
              },
              child: Text(
                (type == 'Bercinta' || type == 'Bersetubuh')
                    ? 'Terima hubungan intim'
                    : ((type == 'Ajak Pacaran' && _character.partner != null && !_character.isAnyPartnerNameMatching(partnerName)) ? 'Terima menjadi selingkuhan' : 'Terima'),
                style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  if (type == 'Ajak 3some') {
                    _character.inbox.add('📢 Tolak 3some: Kamu menolak ajakan 3some dari $partnerName.');
                  } else {
                    _character.inbox.add(
                      '💔 Penolakan: Kamu menolak ajakan ${type == "Ajak Pacaran" ? "pacaran" : "bercinta"} dari $partnerName.'
                    );
                  }
                  
                  _character.activeProposal = null;
                });
                
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(type == 'Ajak 3some'
                        ? '💔 Kamu menolak ajakan 3some dari $partnerName.'
                        : '💔 Kamu menolak ajakan dari $partnerName.'),
                    backgroundColor: Colors.red,
                  ),
                );
                _checkGlassesNeed(onDone);
              },
              child: const Text('Tolak', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        );
      },
    );
  }

  // --- RESTORED CLASS METHOD CLOSURE ---

  void _executeReportParent(BuildContext context, String partnerName, String relation, String reportTarget) {
    final rand = Random();
    final int roll = rand.nextInt(100);
    final bool isJailed = roll < 40; // 40% chance of prison + divorce

    setState(() {
      final String relationLower = relation.toLowerCase();

      if (reportTarget == 'Ibu') {
        // Dilaporkan ke Ibu (pelakunya Ayah Kandung atau Ayah Tiri)
        if (relationLower.contains('tiri')) {
          final String originalName = _character.stepFatherName ?? partnerName;
          _character.stepFatherName = null; // Diceraikan / dihapus
          _character.stepFatherRelationship = 0;

          if (isJailed) {
            _character.inbox.add('🚨 Laporan Polisi: Kamu melaporkan Ayah Tirimu, $originalName, ke Ibumu. Ibumu sangat marah, menceraikannya, dan melaporkannya ke polisi. Ayah tirimu kini dipenjara!');
          } else {
            _character.inbox.add('💔 Perceraian: Kamu melaporkan Ayah Tirimu, $originalName, ke Ibumu. Ibumu sangat marah dan memutuskan untuk menceraikannya.');
          }
        } else {
          _character.isFatherDivorced = true;
          _character.fatherRelationship = 0;

          if (isJailed) {
            _character.inbox.add('🚨 Laporan Polisi: Kamu melaporkan Ayahmu, $partnerName, ke Ibumu. Ibumu sangat marah, menceraikannya, dan melaporkannya ke polisi. Ayahmu kini dipenjara!');
          } else {
            _character.inbox.add('💔 Perceraian: Kamu melaporkan Ayahmu, $partnerName, ke Ibumu. Ibumu sangat marah dan memutuskan untuk menceraikannya.');
          }

          // Karena Ayah diceraikan, Ibu kandung kini menjadi janda.
          // Berikan kesempatan Ibu kandung menikah lagi (menghasilkan Ayah Tiri).
          ParentRemarriage.checkAndApplyRemarriage(_character, rand, []);
        }

        // Hubungan dengan Ibu meningkat karena melapor
        _character.motherRelationship = ((_character.motherRelationship ?? 50) + 15).clamp(0, 100);
      } else {
        // Dilaporkan ke Ayah / Ayah Tiri (pelakunya Ibu Kandung)
        _character.isMotherDivorced = true;
        _character.motherRelationship = 0;

        if (isJailed) {
          final int prisonYears = rand.nextInt(5) + 1; // 1-5 years
          _character.isMotherImprisoned = true;
          _character.motherPrisonYears = prisonYears;
          _character.custodyParent = null; // resets custody since she is in prison
          _character.inbox.add('🚨 Laporan Polisi: Kamu melaporkan Ibumu, $partnerName, ke $reportTarget. $reportTarget sangat marah, menceraikannya, dan melaporkannya ke polisi. Ibumu kini dipenjara selama $prisonYears tahun!');
        } else {
          _character.inbox.add('💔 Perceraian: Kamu melaporkan Ibumu, $partnerName, ke $reportTarget. $reportTarget sangat marah dan memutuskan untuk menceraikannya.');
        }

        // Karena Ibu diceraikan/dipenjara, Ayah kandung (jika ada) kini menjadi duda.
        // Berikan kesempatan Ayah kandung menikah lagi (menghasilkan Ibu Tiri).
        if (!isJailed) {
          ParentRemarriage.checkAndApplyRemarriage(_character, rand, []);
        }

        // Hubungan dengan Ayah / Ayah Tiri meningkat
        if (reportTarget == 'Ayah Tiri') {
          _character.stepFatherRelationship = ((_character.stepFatherRelationship ?? 50) + 15).clamp(0, 100);
        } else {
          _character.fatherRelationship = ((_character.fatherRelationship ?? 50) + 15).clamp(0, 100);
        }
      }

      _character.activeProposal = null;
    });

    final String customContent = isJailed
        ? 'Laporanmu berhasil! $partnerName telah dilaporkan ke polisi oleh $reportTarget, diceraikan, dan kini mendekam di penjara selama ${_character.motherPrisonYears} tahun.'
        : '$reportTarget sangat terkejut mendengarnya dan memutuskan untuk menceraikan $partnerName secara langsung!';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(isJailed ? Icons.gavel : Icons.heart_broken, color: isJailed ? Colors.red : Colors.orange, size: 28),
            const SizedBox(width: 8),
            Text(
              isJailed ? 'Laporan Polisi Sukses! 🚨' : 'Orang Tua Bercerai! 💔',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        content: Text(
          customContent,
          style: const TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showCustodySelectionDialog(context, _character.fatherName ?? 'Ayah', _character.motherName ?? 'Ibu');
            },
            child: const Text('OK', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showCustodySelectionDialog(BuildContext context, String fatherName, String motherName) {
    final bool fatherAliveAndFree = _character.fatherName != null && !_character.isFatherDeceased && !_character.isFatherImprisoned;
    final bool stepFatherAliveAndFree = _character.stepFatherName != null && !_character.isStepFatherDeceased;
    final bool motherAliveAndFree = _character.motherName != null && !_character.isMotherDeceased && !_character.isMotherImprisoned;

    // Jika user berusia 18 tahun ke atas, tidak perlu hak asuh
    if (_character.age >= 18) {
      return;
    }

    // Kasus 1: Keduanya (ayah kandung/tiri dan ibu kandung) hidup bebas
    // User bisa memilih. Pilihan ayah adalah Ayah Kandung (jika ada) atau Ayah Tiri.
    final String fatherOrStepFatherLabel = fatherAliveAndFree ? fatherName : (_character.stepFatherName ?? 'Ayah Tiri');
    final bool hasFatherOption = fatherAliveAndFree || stepFatherAliveAndFree;
    final bool hasMotherOption = motherAliveAndFree;

    if (!hasFatherOption && !hasMotherOption) {
      // Kasus khusus: Semua meninggal / dipenjara -> Hidup sendiri di rumah yang ditinggalkan
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.gavel, color: Colors.red),
              SizedBox(width: 8),
              Text('Hidup Sendiri 🏡', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          content: const Text(
            'Kedua orang tuamu telah tiada atau dipenjara. Karena tidak ada wali yang tersisa, kamu dipaksa untuk hidup mandiri dan menempati rumah peninggalan ibumu.',
            style: TextStyle(fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _character.custodyParent = null;
                  _character.inbox.add('🏡 Hidup Mandiri: Kamu menempati rumah peninggalan ibumu setelah dia dipenjara.');
                });
              },
              child: const Text('OK', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );
      return;
    }

    // Jika hanya ada 1 pilihan tersisa karena salah satu meninggal/dipenjara
    if (hasFatherOption && !hasMotherOption) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.home, color: Colors.blue),
              SizedBox(width: 8),
              Text('Pilih Hak Asuh 🏡', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          content: Text(
            'Karena ibumu dipenjara/wafat, hak asuh kamu otomatis jatuh kepada $fatherOrStepFatherLabel.',
            style: const TextStyle(fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  if (fatherAliveAndFree) {
                    _character.fatherRelationship = ((_character.fatherRelationship ?? 50) + 20).clamp(0, 100);
                    _character.custodyParent = 'Ayah';
                  } else {
                    _character.stepFatherRelationship = ((_character.stepFatherRelationship ?? 50) + 20).clamp(0, 100);
                    _character.custodyParent = 'Ayah Tiri';
                  }
                  _character.inbox.add('🏡 Hak Asuh: Hak asuhmu jatuh ke tangan $fatherOrStepFatherLabel.');
                });
              },
              child: const Text('OK', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );
      return;
    }

    if (!hasFatherOption && hasMotherOption) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.home, color: Colors.pink),
              SizedBox(width: 8),
              Text('Pilih Hak Asuh 🏡', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          content: Text(
            'Karena ayahmu dipenjara/wafat, hak asuh kamu otomatis jatuh kepada Ibumu ($motherName).',
            style: const TextStyle(fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _character.motherRelationship = ((_character.motherRelationship ?? 50) + 20).clamp(0, 100);
                  _character.custodyParent = 'Ibu';
                  _character.inbox.add('🏡 Hak Asuh: Hak asuhmu jatuh ke tangan Ibumu ($motherName).');
                });
              },
              child: const Text('OK', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );
      return;
    }

    // Jika keduanya ada, tampilkan modal pilihan (Ayah Kandung / Ayah Tiri vs Ibu)
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.home, color: Colors.blue),
            SizedBox(width: 8),
            Text('Pilih Hak Asuh 🏡', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
        content: const Text(
          'Karena orang tuamu bercerai, kamu harus memilih untuk tinggal bersama siapa.',
          style: TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                if (fatherAliveAndFree) {
                  _character.fatherRelationship = ((_character.fatherRelationship ?? 50) + 20).clamp(0, 100);
                  _character.custodyParent = 'Ayah';
                } else {
                  _character.stepFatherRelationship = ((_character.stepFatherRelationship ?? 50) + 20).clamp(0, 100);
                  _character.custodyParent = 'Ayah Tiri';
                }
                _character.inbox.add('🏡 Hak Asuh: Kamu memilih untuk ikut tinggal bersama $fatherOrStepFatherLabel.');
              });
              _checkGlassesNeed();
            },
            child: Text('Ikut Ayah ($fatherOrStepFatherLabel)', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _character.motherRelationship = ((_character.motherRelationship ?? 50) + 20).clamp(0, 100);
                if (fatherAliveAndFree) {
                  _character.fatherRelationship = ((_character.fatherRelationship ?? 50) - 15).clamp(0, 100);
                } else {
                  _character.stepFatherRelationship = ((_character.stepFatherRelationship ?? 50) - 15).clamp(0, 100);
                }
                _character.custodyParent = 'Ibu';
                _character.inbox.add('🏡 Hak Asuh: Kamu memilih untuk ikut tinggal bersama Ibumu ($motherName).');
              });
              _checkGlassesNeed();
            },
            child: Text('Ikut Ibu ($motherName)', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.pink)),
          ),
        ],
      ),
    );
  }

  void _executeReportStaff(BuildContext context, String partnerName, String role) {
    final rand = Random();
    final int roll = rand.nextInt(100);
    final bool isFired = roll < 70; // 70% chance of being fired

    setState(() {
      if (isFired) {
        final String nameLower = partnerName.toLowerCase();
        
        // Hapus guru SD, SMP, SMA
        _character.sdTeachers.removeWhere((t) => (t['name'] ?? '').toLowerCase() == nameLower || nameLower.contains((t['name'] ?? '').toLowerCase()));
        _character.smpTeachers.removeWhere((t) => (t['name'] ?? '').toLowerCase() == nameLower || nameLower.contains((t['name'] ?? '').toLowerCase()));
        _character.smaTeachers.removeWhere((t) => (t['name'] ?? '').toLowerCase() == nameLower || nameLower.contains((t['name'] ?? '').toLowerCase()));
        
        // Hapus dosen
        _character.univLecturers.removeWhere((t) => (t['name'] ?? '').toLowerCase() == nameLower || nameLower.contains((t['name'] ?? '').toLowerCase()));

        // Hapus kepala sekolah jika cocok
        if (_character.headmaster != null &&
            ((_character.headmaster!['name'] ?? '').toLowerCase() == nameLower || nameLower.contains((_character.headmaster!['name'] ?? '').toLowerCase()))) {
          _character.headmaster = null;
        }
        if (_character.sdHeadmaster != null &&
            ((_character.sdHeadmaster!['name'] ?? '').toLowerCase() == nameLower || nameLower.contains((_character.sdHeadmaster!['name'] ?? '').toLowerCase()))) {
          _character.sdHeadmaster = null;
        }
        if (_character.smpHeadmaster != null &&
            ((_character.smpHeadmaster!['name'] ?? '').toLowerCase() == nameLower || nameLower.contains((_character.smpHeadmaster!['name'] ?? '').toLowerCase()))) {
          _character.smpHeadmaster = null;
        }

        _character.inbox.add('🚨 Laporan Sekolah: Kamu melaporkan $partnerName ($role). Laporanmu diterima dan yang bersangkutan resmi dipecat dari sekolah!');
      } else {
        _character.inbox.add('📢 Laporan Sekolah: Laporanmu terhadap $partnerName ($role) ditolak karena kurangnya bukti.');
      }
      
      _character.activeProposal = null;
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(isFired ? Icons.check_circle : Icons.error, color: isFired ? Colors.green : Colors.red, size: 28),
            const SizedBox(width: 8),
            Text(
              isFired ? 'Laporan Diterima! 🚨' : 'Laporan Ditolak! 📢',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        content: Text(
          isFired
              ? 'Laporanmu diproses. Pihak sekolah memutuskan untuk memecat $partnerName secara tidak hormat!'
              : 'Pihak sekolah mengabaikan laporanmu karena dianggap tidak memiliki bukti yang cukup. $partnerName tetap bertugas.',
          style: const TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _checkGlassesNeed();
            },
            child: const Text('OK', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showIncomingCondomDialog(Map<String, dynamic> proposal) {
    final String partnerName = proposal['name'];
    final String relation = proposal['relation'];
    final String myGender = _character.gender.trim().toLowerCase();
    final String partnerGender = (proposal['gender'] ?? 'Laki-laki').trim().toLowerCase();
    final bool isHetero = myGender != partnerGender;

    // Jika sesama jenis (Gay/Lesbian), lewati dialog kondom dan langsung eksekusi tanpa kondom
    if (!isHetero) {
      _executeIncomingBercinta(proposal, false);
      return;
    }

    String riskInfo = '';
    String whoGetsPregnant = '';
    int ageMin = 0, ageMax = 0;

    if (isHetero) {
      if (myGender == 'perempuan' && partnerGender == 'laki-laki') {
        whoGetsPregnant = 'Kamu hamil';
        ageMin = 8; ageMax = 45;
      } else if (myGender == 'laki-laki' && partnerGender == 'perempuan') {
        whoGetsPregnant = 'Pasanganmu hamil';
        ageMin = 9; ageMax = 65;
      }

      bool isAgeValid = _character.age >= ageMin && _character.age <= ageMax;
      if (isAgeValid) {
        double fertility = _getIncomingFertilityRate(_character.age, myGender);
        riskInfo = 'Jika TIDAK memakai pengaman: Ada ${(fertility * 100).toInt()}% risiko $whoGetsPregnant! (Usia saat ini ${_character.age} tahun, kesuburan ${(fertility * 100).toInt()}%)';
      } else {
        riskInfo = 'Jika TIDAK memakai pengaman: Risiko 0% karena usia saat ini (${_character.age} tahun) berada di luar masa subur. (Syarat: Minimal $ageMin - Maksimal $ageMax tahun)';
      }
    } else {
      riskInfo = 'Kombinasi gender: Kamu ($myGender) & Pasangan ($partnerGender) -> Risiko hamil 0% (Tidak memungkinkan secara biologis).';
    }

    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.health_and_safety, color: Colors.blue, size: 28),
            SizedBox(width: 8),
            Text('Gunakan Pengaman?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Apa kamu ingin menggunakan kondom untuk mencegah kehamilan?',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 12),
            Text(
              'Gender: Kamu (${_character.gender}) & $relation ($partnerGender)',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.blueGrey),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Text(
                riskInfo,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.blue),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _executeIncomingBercinta(proposal, true);
            },
            child: const Text('Ya, pakai', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _executeIncomingBercinta(proposal, false);
            },
            child: const Text('Tidak', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  double _getIncomingFertilityRate(int age, String gender) {
    final String g = gender.trim().toLowerCase();
    if (g == 'perempuan') {
      if (age < 8 || age > 45) return 0.0;
      if (age >= 8 && age <= 13) return 0.35;
      if (age >= 14 && age <= 19) return 0.55;
      if (age >= 20 && age <= 29) return 0.85;
      if (age >= 30 && age <= 39) return 0.65;
      if (age >= 40 && age <= 45) return 0.30;
    } else {
      if (age < 9 || age > 65) return 0.0;
      if (age >= 9 && age <= 13) return 0.35;
      if (age >= 14 && age <= 19) return 0.55;
      if (age >= 20 && age <= 29) return 0.85;
      if (age >= 30 && age <= 39) return 0.75;
      if (age >= 40 && age <= 49) return 0.55;
      if (age >= 50 && age <= 65) return 0.35;
    }
    return 0.0;
  }

  void _executeIncomingBercinta(Map<String, dynamic> proposal, bool useCondom) {
    final String partnerName = proposal['name'];
    final String relation = proposal['relation'];
    final String myGender = _character.gender.trim().toLowerCase();
    final String partnerGender = (proposal['gender'] ?? 'Laki-laki').trim().toLowerCase();
    final Random random = Random();

    setState(() {
      _character.happiness = (_character.happiness + 20).clamp(0, 100);
      _updateFamilyRelationship(partnerName, 15);
      _character.addTabooSecret(partnerName, relation, 'Bercinta');

      if (!useCondom && myGender != partnerGender) {
        double myFertility = _getIncomingFertilityRate(_character.age, myGender);
        if (myGender == 'perempuan' && partnerGender == 'laki-laki') {
          double finalChance = _character.birthControlActive ? 0.05 : myFertility;
          if (!_character.isPregnant && myFertility > 0 && random.nextDouble() < finalChance) {
            _character.isPregnant = true;
            _character.pregnantByPartnerName = partnerName;
            _character.pregnantByPartnerRole = proposal['role'] ?? relation;
            _character.inbox.add(
              '🍼 Kabar Kehamilan: Kamu hamil dari hasil hubungan intim dengan $partnerName!'
            );
          }
        } else if (myGender == 'laki-laki' && partnerGender == 'perempuan') {
          // Ambil daftar nama pasangan yang sudah hamil (jika ada)
          final String currentPartners = _character.pregnantByPartnerName ?? '';
          final bool isAlreadyPregnantByThisPartner = currentPartners.split(', ').map((e) => e.trim().toLowerCase()).contains(partnerName.trim().toLowerCase());

          // Jika pasangan ini BELUM hamil, dan roll berhasil:
          if (!isAlreadyPregnantByThisPartner && myFertility > 0 && random.nextDouble() < myFertility) {
            // Tambahkan nama pasangan baru ke daftar
            if (currentPartners.isEmpty) {
              _character.pregnantByPartnerName = partnerName;
            } else {
              _character.pregnantByPartnerName = '$currentPartners, $partnerName';
            }
            
            _character.partnerIsPregnant = true;
            _character.pregnantByPartnerRole = proposal['role'] ?? relation;
            _character.inbox.add(
              '👶 Kabar Kehamilan: Pasangan/keluargamu, $partnerName, hamil dari hasil hubungan intim denganmu!'
            );
          }
        }
      }

      // Jalankan logika penularan penyakit seksual (STD) jika tidak pakai pengaman
      if (!useCondom) {
        // Panggil std_logic.dart helper
        importPenyakitSTDCheck(proposal);
      }

      _character.inbox.add(
        '💋 Aktivitas Mesra: Kamu menerima ajakan bercinta dari $partnerName. Kalian menghabiskan waktu intim bersama.'
      );
      _character.activeProposal = null;
    });

    int relValue = 50;
    if (partnerName.startsWith('Ayah')) {
      if (partnerName.contains('Tiri')) {
        relValue = _character.stepFatherRelationship ?? 50;
      } else {
        relValue = _character.fatherRelationship ?? 50;
      }
    } else if (partnerName.startsWith('Ibu')) {
      relValue = _character.motherRelationship ?? 50;
    } else {
      for (var sib in _character.siblings) {
        final String expectedLabel = '${sib['name']} (${sib['relation']})';
        if (expectedLabel == partnerName) {
          relValue = int.tryParse(sib['relationship'] ?? '50') ?? 50;
          break;
        }
      }
    }

    String addText = '';
    final String currentPartners = _character.pregnantByPartnerName ?? '';
    final bool isThisPartnerPregnant = currentPartners.split(', ').map((e) => e.trim().toLowerCase()).contains(partnerName.trim().toLowerCase());

    if (isThisPartnerPregnant) {
      if (_character.isPregnant) {
        addText = 'Kamu hamil! 🍼';
      } else if (_character.partnerIsPregnant) {
        addText = '$relation hamil! 👶';
      }
    }

    MLEnjoymentModal.show(
      context: context,
      character: _character,
      partnerName: partnerName,
      partnerRelation: relation,
      relationshipValue: relValue,
      additionalText: addText.isNotEmpty ? addText : null,
      onComplete: () {
        _checkGlassesNeed();
      },
    );
  }

  void importPenyakitSTDCheck(Map<String, dynamic> proposal) {
    // Memanggil handleSTDCheckNoContext di std_logic.dart (tanpa modal UI)
    final String partnerName = proposal['name'];
    final String relation = proposal['relation'];
    final String role = proposal['role'] ?? relation;
    final Random random = Random();
    
    handleSTDCheckNoContext(_character, role, partnerName, random);
  }

  void _updateFamilyRelationship(String targetName, int changeAmount) {
    if (targetName.startsWith('Ayah')) {
      if (targetName.contains('Tiri')) {
        _character.stepFatherRelationship = ((_character.stepFatherRelationship ?? 50) + changeAmount).clamp(0, 100);
      } else {
        _character.fatherRelationship = ((_character.fatherRelationship ?? 50) + changeAmount).clamp(0, 100);
      }
    } else if (targetName.startsWith('Ibu')) {
      _character.motherRelationship = ((_character.motherRelationship ?? 50) + changeAmount).clamp(0, 100);
    } else {
      for (var sib in _character.siblings) {
        final String expectedLabel = '${sib['name']} (${sib['relation']})';
        if (expectedLabel == targetName) {
          int currentRel = int.tryParse(sib['relationship'] ?? '50') ?? 50;
          sib['relationship'] = (currentRel + changeAmount).clamp(0, 100).toString();
          break;
        }
      }
    }
  }

  // --- LOGIKA KATEGORI USIA ---
  Map<String, dynamic> _getAgeData(int age) {
    if (age <= 4) {
      return {'label': 'Bayi', 'icon': Icons.baby_changing_station, 'color': Colors.green};
    } else if (age <= 12) {
      return {'label': 'Anak-anak', 'icon': Icons.child_care, 'color': Colors.blueAccent};
    } else if (age <= 19) {
      return {'label': 'Remaja', 'icon': Icons.face, 'color': Colors.purple};
    } else if (age <= 59) {
      return {'label': 'Dewasa', 'icon': Icons.person, 'color': Colors.blue};
    } else {
      return {'label': 'Tua', 'icon': Icons.face_retouching_natural, 'color': Colors.grey};
    }
  }

  // --- FUNGSI SIMPAN PROGRESS ---
  void _saveProgress() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('💾 Fitur Simpan Progress belum diimplementasikan!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  // --- FUNGSI MULAI GAME BARU ---
  void _startNewGame() {
    _resetGame();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('🔄 Game Baru dimulai! Buat karakter baru lagi.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ageData = _getAgeData(_character.age);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('BitLife'),
        centerTitle: true,
        backgroundColor: theme.scaffoldBackgroundColor,
        foregroundColor: theme.colorScheme.onSurface,
        elevation: 0,
        leading: Builder(
          builder: (context) {
            final date = _character.currentDate ?? DateTime.now();
            final months = [
              'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
              'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
            ];
            final formattedDate = "${date.day} ${months[date.month - 1]} ${date.year}";

            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
                Text(
                  formattedDate,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.blueGrey.shade200 : Colors.blueGrey,
                  ),
                ),
              ],
            );
          },
        ),
        leadingWidth: 170, // Beri space yang cukup untuk hamburger + tanggal
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Center(
              child: NextDayButton(
                onPressed: _character.isAlive ? _nextDay : null,
              ),
            ),
          ),
        ],
      ),
      drawer: PausedMenu(
        character: _character,
        onPurchaseCompleted: () {
          setState(() {});
        },
        onRestart: _resetGame,
        onSaveProgress: _saveProgress,
        onNewGame: _startNewGame,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Character Card Info
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.blue.shade50,
                            child: Image(
                              image: AvatarImageCache.getImageProvider(_avatarUrl), // Gunakan cache URL
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                );
                              },
                              width: 60,
                              height: 60,
                            ),
                          ),
                          const SizedBox(height: 4),
                          // Display Tanggal Lahir & Tanggal Sekarang
                          (() {
                            final months = [
                              'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
                              'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
                            ];
                            final birth = _character.birthDate ?? DateTime.now();
                            final formattedBirth = "${birth.day} ${months[birth.month - 1]} ${birth.year}";
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 2.0),
                              child: Text(
                                'Tanggal Lahir: $formattedBirth',
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isDark ? Colors.blueGrey.shade300 : Colors.blueGrey),
                              ),
                            );
                          })(),
                          Text(_character.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),
                          (() {
                            final String talent = _character.specialTalent;
                            if (talent == 'None' || talent == 'Tidak Ada' || talent.isEmpty) {
                              return const SizedBox.shrink();
                            }
                            String emoji = '✨';
                            if (talent.contains('Akting')) emoji = '🎭';
                            else if (talent.contains('Kriminalitas')) emoji = '🔫';
                            else if (talent.contains('Pengedar')) emoji = '🌿';
                            else if (talent.contains('Modeling')) emoji = '📸';
                            else if (talent.contains('Musik')) emoji = '🎵';
                            else if (talent.contains('Olahraga')) emoji = '🏀';

                            return Padding(
                              padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.orange.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.orange.withOpacity(0.35)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(emoji, style: const TextStyle(fontSize: 12)),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Talenta: $talent',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.orange,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          })(),
                          Text('Gender: ${_character.gender} • ${_character.birthOrderLabel} (Anak ${_character.birthOrder == 1 ? 'Pertama' : 'ke-${_character.birthOrder}'})', style: TextStyle(fontSize: 12, color: isDark ? Colors.blueGrey.shade300 : Colors.blueGrey, fontWeight: FontWeight.w500)),
                          const SizedBox(height: 2),
                          Text('Kebangsaan: ${_character.birthCountry ?? _character.location} • Tinggal di: ${_character.currentCity != null ? '${_character.currentCity}, ' : ''}${_character.location}', style: TextStyle(fontSize: 12, color: isDark ? Colors.blueGrey.shade300 : Colors.blueGrey, fontWeight: FontWeight.w500)),
                          Text('Umur: ${_character.age} Tahun', style: TextStyle(fontSize: 14, color: isDark ? Colors.white54 : Colors.grey)),
                          const SizedBox(height: 2),
                          (() {
                            if (_character.jobName != null) {
                              return Text(
                                'Pekerjaan: ${_character.jobName}',
                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.green),
                              );
                            } else if (_character.univMajor != null) {
                              return Text(
                                'Pendidikan: ${_character.univMajor!.split(" (").first}',
                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.blue),
                              );
                            } else if (_character.age >= 6 && _character.age < 18) {
                              String school = 'SD';
                              if (_character.age >= 12 && _character.age < 15) school = 'SMP';
                              else if (_character.age >= 15) school = 'SMA';
                              return Text(
                                'Pendidikan: $school',
                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.blue),
                              );
                            } else if (_character.age >= 18) {
                              return Text(
                                'Status: Pengangguran',
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: isDark ? Colors.white54 : Colors.grey),
                              );
                            }
                            return const SizedBox.shrink();
                          }()),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Stats - 1 Column Layout (1-1-1-1) to fill vertical space
                  _buildStatRow('Kesehatan', _character.health, Colors.red),
                  const SizedBox(height: 10),
                  _buildStatRow('Kebahagiaan', _character.happiness, Colors.green),
                  const SizedBox(height: 10),
                  _buildStatRow('Kecerdasan', _character.intelligence, Colors.blue),
                  const SizedBox(height: 10),
                  _buildStatRow('Keuangan', _character.money, Colors.amber, isMoney: true),
                  const SizedBox(height: 10),
                  _buildStatRow('Disiplin', _character.discipline, Colors.purple),
                  const SizedBox(height: 10),
                  _buildSexualityRow('Seksualitas', _character.sexuality),
                  const SizedBox(height: 10),
                  InboxButton(
                    character: _character,
                    onRefresh: () {
                      setState(() {
                        _avatarUrl = AvatarAgeRules.getAgeBasedAvatarUrl(
                          _character,
                          happiness: _character.happiness,
                        );
                      });
                    },
                  ),

                  // --- STATUS KEHAMILAN (PERBAIKAN) ---
                  if (_character.isPregnant || _character.partnerIsPregnant) ...[
                    const SizedBox(height: 10),
                    InkWell(
                      onTap: _character.partnerIsPregnant
                          ? () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DaftarPasanganHamilScreen(character: _character),
                                ),
                              ).then((_) {
                                if (mounted) setState(() {});
                              });
                            }
                          : null,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.pink.shade50,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.pink.shade200, width: 1.2),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _character.isPregnant ? Icons.pregnant_woman : Icons.child_care,
                              color: Colors.pink,
                              size: 18,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _character.isPregnant 
                                ? 'Status: Hamil 🍼' 
                                : () {
                                    final String partnersPregnant = _character.pregnantByPartnerName ?? '';
                                    if (partnersPregnant.contains(', ')) {
                                      int jumlahHamil = partnersPregnant.split(', ').length;
                                      return 'Status: $jumlahHamil Pasangan Hamil 👶';
                                    } else if (partnersPregnant.isNotEmpty) {
                                      return 'Status: Pasangan Hamil ($partnersPregnant) 👶';
                                    }
                                    return 'Status: Pasangan Hamil 👶';
                                  }(),
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.pink,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],

                  // Jika karakter mati
                  if (!_character.isAlive)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Center(
                        child: Text(
                          '💀 Karakter telah meninggal pada usia ${_character.age} tahun',
                          style: const TextStyle(fontSize: 16, color: Colors.red, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

                    // Sticky Bottom Actions Outer Wrapper (Protruding FAB Style + 100% Hit-Test)
          SizedBox(
            width: double.infinity,
            height: 115,
            child: Stack(
              alignment: Alignment.bottomCenter,
              clipBehavior: Clip.none,
              children: [
                // Background Container (Draws border line at top: 28)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  top: 28,
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.scaffoldBackgroundColor,
                      boxShadow: [
                        BoxShadow(
                          color: isDark ? Colors.black38 : Colors.black.withOpacity(0.06),
                          blurRadius: 10,
                          offset: const Offset(0, -4),
                        ),
                      ],
                      border: Border(
                        top: BorderSide(color: theme.dividerColor, width: 1),
                      ),
                    ),
                  ),
                ),
                SafeArea(
                  top: false,
                  child: SizedBox(
                    height: 115,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      clipBehavior: Clip.none,
                      children: [
                        // Row 4 tombol utama di bawah
                        Positioned(
                          left: 4,
                          right: 4,
                          bottom: 10,
                          height: 52,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2),
                                child: AgeCategoryButton(
                                  character: _character,
                                  ageData: ageData,
                                  age: _character.age,
                                  gender: _character.gender ?? 'Laki-laki',
                                  location: _character.location ?? 'Indonesia',
                                  health: _character.health,
                                  happiness: _character.happiness,
                                  intelligence: _character.intelligence,
                                  money: _character.money,
                                  appearance: _character.appearance ?? 50,
                                ),
                              )),
                              Expanded(child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2),
                                child: AssetsButton(
                                  character: _character,
                                  onRefresh: () {
                                    setState(() {
                                      _avatarUrl = AvatarAgeRules.getAgeBasedAvatarUrl(
                                        _character,
                                        happiness: _character.happiness,
                                      );
                                    });
                                  },
                                ),
                              )),
                              Expanded(child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2),
                                child: RelationshipButton(
                                  character: _character,
                                  isAlive: _character.isAlive,
                                  onRefresh: () {
                                    setState(() {
                                      _avatarUrl = AvatarAgeRules.getAgeBasedAvatarUrl(
                                        _character,
                                        happiness: _character.happiness,
                                      );
                                    });
                                  },
                                ),
                              )),
                              Expanded(child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2),
                                child: ActivityButton(
                                  character: _character,
                                  isAlive: _character.isAlive,
                                  onRefresh: () {
                                    setState(() {
                                      _avatarUrl = AvatarAgeRules.getAgeBasedAvatarUrl(
                                        _character,
                                        happiness: _character.happiness,
                                      );
                                    });
                                  },
                                  onWork: () {
                                    setState(() {
                                      _character.money += 100;
                                      _avatarUrl = AvatarAgeRules.getAgeBasedAvatarUrl(
                                        _character,
                                        happiness: _character.happiness,
                                      );
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Mendapatkan uang 100!')),
                                    );
                                  },
                                  onExercise: () {
                                    setState(() {
                                      _character.health += 10;
                                      _avatarUrl = AvatarAgeRules.getAgeBasedAvatarUrl(
                                        _character,
                                        happiness: _character.happiness,
                                      );
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Kesehatan +10!')),
                                    );
                                  },
                                ),
                              )),
                            ],
                          ),
                        ),
                        // Tombol Tambah Umur & Kurangi Umur (Besar & Menonjol Tinggi di Atas Garis + Hover 100% Aktif!)
                        Positioned(
                          top: 2,
                          child: StorePage.isGodModeUnlocked
                              ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    KurangiUmurButton(
                                      onPressed: _ageDown,
                                    ),
                                    const SizedBox(width: 8),
                                    AgeUpButton(
                                      onPressed: (_character.isAlive && !_isAgingUp) ? _ageUp : null,
                                    ),
                                  ],
                                )
                              : AgeUpButton(
                                  onPressed: (_character.isAlive && !_isAgingUp) ? _ageUp : null,
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showStatGuide(String label) {
    String title = '';
    IconData icon = Icons.info;
    Color iconColor = Colors.grey;
    List<Map<String, String>> tips = [];

    if (label == 'Kesehatan') {
      title = 'Panduan Kesehatan 🩺';
      icon = Icons.favorite;
      iconColor = Colors.red;
      tips = [
        {'emoji': '🏋️‍♂️', 'title': 'Gym & Olahraga', 'desc': 'Lakukan olahraga rutin untuk menjaga kebugaran tubuh.'},
        {'emoji': '🏥', 'title': 'Berobat ke Dokter', 'desc': 'Segera obati penyakitmu melalui menu Dokter jika terserang penyakit.'},
        {'emoji': '🧘‍♂️', 'title': 'Meditasi', 'desc': 'Lakukan meditasi di menu Pikiran & Tubuh untuk menjaga kesehatan mental.'},
        {'emoji': '🥗', 'title': 'Pola Hidup Sehat', 'desc': 'Hindari alkohol, narkoba, dan aktivitas ekstrem yang membahayakan tubuh.'},
      ];
    } else if (label == 'Kebahagiaan') {
      title = 'Panduan Kebahagiaan 💚';
      icon = Icons.emoji_emotions;
      iconColor = Colors.green;
      tips = [
        {'emoji': '✈️', 'title': 'Liburan & Jalan-jalan', 'desc': 'Pergi berlibur atau jalan-jalan bersama keluarga & pasangan.'},
        {'emoji': '🎬', 'title': 'Hiburan & Nonton', 'desc': 'Kunjungi bioskop atau nikmati aktivitas hiburan lainnya.'},
        {'emoji': '🎁', 'title': 'Hubungan Sosial', 'desc': 'Habiskan waktu bersama keluarga/pasangan dan beri mereka hadiah.'},
        {'emoji': '🧘‍♂️', 'title': 'Meditasi', 'desc': 'Kurangi tingkat stres dengan bermeditasi secara berkala.'},
      ];
    } else if (label == 'Kecerdasan') {
      title = 'Panduan Kecerdasan 🧠';
      icon = Icons.lightbulb;
      iconColor = Colors.blue;
      tips = [
        {'emoji': '📚', 'title': 'Membaca Buku', 'desc': 'Baca buku bermanfaat secara rutin melalui menu Aktivitas.'},
        {'emoji': '🏛️', 'title': 'Mengunjungi Perpustakaan', 'desc': 'Pergi ke perpustakaan umum untuk memperluas wawasan.'},
        {'emoji': '🎓', 'title': 'Belajar Lebih Giat', 'desc': 'Pilih opsi belajar ekstra di sekolah atau perkuliahan.'},
        {'emoji': '🧩', 'title': 'Minigame', 'desc': 'Latih otak dengan memenangkan minigame memori atau tes kacamata.'},
      ];
    } else if (label == 'Disiplin') {
      title = 'Panduan Disiplin 💜';
      icon = Icons.psychology;
      iconColor = Colors.purple;
      tips = [
        {'emoji': '💼', 'title': 'Belajar & Kerja Giat', 'desc': 'Kerjakan tugas sekolah atau pekerjaan dengan sungguh-sungguh.'},
        {'emoji': '🥋', 'title': 'Latihan Bela Diri', 'desc': 'Ikuti kelas bela diri untuk melatih fokus dan kontrol diri.'},
        {'emoji': '🧘‍♂️', 'title': 'Meditasi Fokus', 'desc': 'Lakukan meditasi untuk memperkuat konsentrasi.'},
        {'emoji': '⚠️', 'title': 'Hindari Bolos', 'desc': 'Jangan pernah membolos sekolah atau kerja agar disiplin tidak merosot.'},
      ];
    }

    if (tips.isEmpty) return;

    showDialog(
      context: context,
      builder: (ctx) {
        final bool isDark = Theme.of(ctx).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Icon(icon, color: iconColor, size: 24),
              const SizedBox(width: 8),
              Text(
                title, 
                style: TextStyle(
                  fontWeight: FontWeight.bold, 
                  fontSize: 16,
                  color: isDark ? Colors.white : Colors.black87
                )
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: tips.map((tip) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(tip['emoji']!, style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tip['title']!, 
                              style: TextStyle(
                                fontWeight: FontWeight.bold, 
                                fontSize: 13,
                                color: isDark ? Colors.white : Colors.black87
                              )
                            ),
                            const SizedBox(height: 2),
                            Text(
                              tip['desc']!, 
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark ? Colors.white70 : Colors.black54
                              )
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: iconColor,
              ),
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Mengerti', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  // --- WIDGET STAT BAR ---
  Widget _buildStatRow(String label, int value, Color color, {bool isMoney = false}) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final bool hasGuide = label == 'Kesehatan' || label == 'Kebahagiaan' || label == 'Kecerdasan' || label == 'Disiplin';
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                if (hasGuide) ...[
                  GestureDetector(
                    onTap: () => _showStatGuide(label),
                    child: Icon(
                      Icons.info_outline,
                      size: 15,
                      color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(width: 4),
                ],
                Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              ],
            ),
            Text(isMoney ? '\$$value' : '$value%', style: const TextStyle(fontSize: 12)),
          ],
        ),
        const SizedBox(height: 4),
        if (!isMoney)
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: (value.clamp(0, 100)) / 100.0,
              backgroundColor: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
              color: color,
              minHeight: 12,
            ),
          ),
      ],
    );
  }

  // --- WIDGET STAT BAR UNTUK SEKSUALITAS (STRING) ---
  Widget _buildSexualityRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.pink.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.pink.withOpacity(0.3)),
              ),
              child: Text(
                value,
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.pink),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
      ],
    );
  }
}