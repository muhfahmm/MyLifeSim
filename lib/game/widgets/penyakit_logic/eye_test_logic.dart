import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';
import 'dart:math';
import 'dart:async';

class EyeTestLogic {
  // Daftar variasi tes mata (main char & odd char)
  static final List<Map<String, dynamic>> _eyeTests = [
    // 1. Angka & Huruf Mirip
    {'main': 'A', 'odd': '4'},
    {'main': 'S', 'odd': '5'},
    {'main': 'O', 'odd': '0'},
    {'main': 'I', 'odd': '1'},
    {'main': 'Z', 'odd': '2'},
    {'main': 'V', 'odd': 'U'},
    {'main': 'U', 'odd': 'W'},
    {'main': 'M', 'odd': 'W'},
    {'main': 'K', 'odd': 'X'},
    {'main': '8', 'odd': 'B'},

    // 2. Huruf Kapital Mirip
    {'main': 'E', 'odd': 'F'},
    {'main': 'F', 'odd': 'E'},
    {'main': 'C', 'odd': 'G'},
    {'main': 'G', 'odd': 'C'},
    {'main': 'P', 'odd': 'R'},
    {'main': 'R', 'odd': 'P'},
    {'main': 'Q', 'odd': 'O'},
    {'main': 'D', 'odd': 'O'},
    {'main': 'T', 'odd': 'Y'},
    {'main': 'Y', 'odd': 'T'},
    {'main': 'N', 'odd': 'M'},
    {'main': 'H', 'odd': 'N'},
    {'main': 'K', 'odd': 'R'},
    {'main': 'X', 'odd': 'K'},

    // 3. Angka Mirip
    {'main': '6', 'odd': '9'},
    {'main': '9', 'odd': '6'},
    {'main': '3', 'odd': '8'},
    {'main': 'B', 'odd': '8'},
    {'main': '7', 'odd': '1'},
    {'main': '5', 'odd': '6'},

    // 4. Huruf Kecil & Simbol Mirip
    {'main': 'b', 'odd': 'd'},
    {'main': 'p', 'odd': 'q'},
    {'main': 'l', 'odd': '1'},
    {'main': 'm', 'odd': 'n'},
    {'main': '9', 'odd': 'g'},
    {'main': 'E', 'odd': '3'},
    {'main': 'v', 'odd': 'w'},
    {'main': 'u', 'odd': 'v'},

    // 5. Tantangan Visual Ekstra
    {'main': 'A', 'odd': '4'},
    {'main': 'G', 'odd': '6'},
    {'main': 'C', 'odd': '0'},
    {'main': '8', 'odd': '3'},
    {'main': 'F', 'odd': 'P'},
  ];

  /// Memeriksa apakah karakter perlu melakukan tes mata berdasarkan usia dan riwayat tes
  static void checkGlassesNeed({
    required BuildContext context,
    required Character character,
    required VoidCallback onFinish,
    required VoidCallback onUpdateAvatar,
    required Function(BuildContext context, String fatherName, String motherName, VoidCallback? onDone) showCustodySelection,
  }) {
    // Cek apakah perlu memilih hak asuh setelah orang tua bercerai di tengah game
    if ((character.isFatherDivorced || character.isMotherDivorced) &&
        character.custodyParent == null &&
        character.age < 18 &&
        character.fatherName != null &&
        character.motherName != null &&
        !character.isFatherDeceased &&
        !character.isMotherDeceased) {
      showCustodySelection(context, character.fatherName!, character.motherName!, onFinish);
      return;
    }

    if (character.avatarAccessoriesType != 'blank' && character.avatarAccessoriesType != null) {
      onFinish();
      return; // Sudah pakai kacamata
    }
    final int age = character.age;
    if (age <= 0) {
      onFinish();
      return;
    }

    // Batasi tes hanya pada rentang usia 1-18 dan 40-60
    if (age >= 1 && age <= 18) {
      if (character.eyeTestsCountYoung >= 2) {
        onFinish();
        return;
      }
    } else if (age >= 40 && age <= 60) {
      if (character.eyeTestsCountOld >= 2) {
        onFinish();
        return;
      }
    } else {
      onFinish();
      return; // Tidak ada tes di luar rentang usia tersebut
    }

    int chance = 0;
    if (age >= 1 && age <= 6) {
      chance = 5;
    } else if (age >= 7 && age <= 10) {
      chance = 20;
    } else if (age >= 11 && age <= 18) {
      chance = 25;
    } else if (age >= 40 && age <= 45) {
      chance = 35;
    } else if (age >= 46 && age <= 55) {
      chance = 40;
    } else if (age >= 56 && age <= 60) {
      chance = 40;
    }

    if (Random().nextInt(100) < chance) {
      if (age >= 1 && age <= 18) {
        character.eyeTestsCountYoung++;
      } else if (age >= 40 && age <= 60) {
        character.eyeTestsCountOld++;
      }
      showEyeTestMinigame(
        context: context,
        character: character,
        onFinish: onFinish,
        onUpdateAvatar: onUpdateAvatar,
      );
    } else {
      onFinish();
    }
  }

  /// Menampilkan dialog minigame tes mata interaktif tanpa button
  static void showEyeTestMinigame({
    required BuildContext context,
    required Character character,
    required VoidCallback onFinish,
    required VoidCallback onUpdateAvatar,
  }) {
    final randomTest = _eyeTests[Random().nextInt(_eyeTests.length)];
    final String mainChar = randomTest['main']!;
    final String oddChar = randomTest['odd']!;

    const int rows = 12;
    const int cols = 16;

    final random = Random();
    final int targetRow = random.nextInt(rows);
    final int targetCol = random.nextInt(cols);

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
              countdownTimer ??= Timer.periodic(const Duration(seconds: 1), (timer) {
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
                    character.avatarAccessoriesType = 'prescription01';
                    onUpdateAvatar();

                    showDialog(
                      context: dialogContext,
                      barrierDismissible: false,
                      builder: (timeoutContext) => PopScope(
                        canPop: false,
                        child: AlertDialog(
                          title: const Text('Waktu Habis! 👓', style: TextStyle(fontWeight: FontWeight.bold)),
                          content: Text('Kamu tidak sempat menekan huruf tersebut. Huruf yang berbeda adalah: "$oddChar". Dokter mendiagnosis mata silinder/minus, sehingga kamu harus memakai kacamata.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(timeoutContext);
                                Navigator.pop(dialogContext);
                                onFinish.call();
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
                      'Matamu terasa sedikit buram. Dokter meminta untuk menemukan dan menekan LANGSUNG huruf/angka yang berbeda di kotak berikut dalam 5 detik!',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blueAccent, width: 2),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(rows, (r) {
                          return Row(
                            children: List.generate(cols, (c) {
                              final bool isTarget = (r == targetRow && c == targetCol);
                              final String char = isTarget ? oddChar : mainChar;
                              return Expanded(
                                child: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: answered
                                      ? null
                                      : () {
                                          answered = true;
                                          countdownTimer?.cancel();
                                          if (isTarget) {
                                            showDialog(
                                              context: dialogContext,
                                              barrierDismissible: false,
                                              builder: (successContext) => PopScope(
                                                canPop: false,
                                                child: AlertDialog(
                                                  title: const Text('Fokus Bagus! 🎉', style: TextStyle(fontWeight: FontWeight.bold)),
                                                  content: Text('Kamu berhasil menemukan dan menekan huruf "$oddChar"! Penglihatanmu masih sangat baik, kamu tidak memerlukan kacamata.'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(successContext);
                                                        Navigator.pop(dialogContext);
                                                        onFinish.call();
                                                      },
                                                      child: const Text('Lanjutkan'),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          } else {
                                            character.avatarAccessoriesType = 'prescription01';
                                            onUpdateAvatar();

                                            showDialog(
                                              context: dialogContext,
                                              barrierDismissible: false,
                                              builder: (failContext) => PopScope(
                                                canPop: false,
                                                child: AlertDialog(
                                                  title: const Text('Salah Tebak! 👓', style: TextStyle(fontWeight: FontWeight.bold)),
                                                  content: Text('Jawabanmu salah. Kamu menekan huruf "$mainChar". Huruf yang benar adalah "$oddChar". Penglihatanmu buruk dan sekarang kamu harus memakai kacamata.'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(failContext);
                                                        Navigator.pop(dialogContext);
                                                        onFinish.call();
                                                      },
                                                      child: const Text('OK'),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 2),
                                    child: Text(
                                      char,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                        fontFamily: 'monospace',
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          );
                        }),
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
}
