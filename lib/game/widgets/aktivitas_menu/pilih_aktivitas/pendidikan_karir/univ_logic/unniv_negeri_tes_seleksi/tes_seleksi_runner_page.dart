import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'tes_seleksi_model.dart';
import 'tes_seleksi_resolver.dart';

class TesSeleksiRunnerPage extends StatefulWidget {
  final Character character;
  final String chosenUniv;
  final String major;
  final String level;
  final VoidCallback onPassSuccess;

  const TesSeleksiRunnerPage({
    super.key,
    required this.character,
    required this.chosenUniv,
    required this.major,
    required this.level,
    required this.onPassSuccess,
  });

  @override
  State<TesSeleksiRunnerPage> createState() => _TesSeleksiRunnerPageState();
}

class _TesSeleksiRunnerPageState extends State<TesSeleksiRunnerPage> {
  late List<QuestionItem> _questions;
  final Map<int, int> _userAnswers = {};
  int _currentIndex = 0;
  bool _submitted = false;

  @override
  void initState() {
    super.initState();
    _questions = getQuestionsForMajor(widget.major);
  }

  void _submitExam() {
    if (_userAnswers.length < _questions.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Harap jawab semua ${_questions.length} soal sebelum mengumpulkan tes!'),
          backgroundColor: Colors.orangeAccent,
        ),
      );
      return;
    }

    int score = 0;
    for (int i = 0; i < _questions.length; i++) {
      if (_userAnswers[i] == _questions[i].correctOptionIndex) {
        score++;
      }
    }

    setState(() {
      _submitted = true;
    });

    final bool passed = score >= 8;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (c) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(
              passed ? Icons.check_circle : Icons.cancel,
              color: passed ? Colors.green : Colors.red,
              size: 28,
            ),
            const SizedBox(width: 8),
            Text(passed ? 'Lolos Seleksi PTN! 🎉' : 'Gagal Seleksi PTN 🚫'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Skor Akhir Kamu: $score / ${_questions.length}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              passed
                  ? 'Selamat! Kamu berhasil menjawab minimal 8 soal dengan benar dan diterima di ${widget.chosenUniv} (${widget.major}).'
                  : 'Maaf, syarat kelulusan tes seleksi minimal 8 dari 10 soal benar. Coba lagi di kesempatan berikutnya.',
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: passed ? Colors.green : Colors.blue,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(c); // Pop dialog
              Navigator.pop(context); // Pop exam page
              if (passed) {
                widget.onPassSuccess();
              }
            },
            child: const Text('Selesai'),
          ),
        ],
      ),
    );
  }

  Future<bool> _showExitConfirmationDialog() async {
    if (_submitted) return true;
    final bool? shouldExit = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Keluar Ujian Seleksi? ⚠️'),
        content: const Text(
          'Apakah kamu yakin ingin keluar dari tes seleksi? Seluruh kemajuan jawaban tes kamu akan hilang!',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(c, true),
            child: const Text('Keluar Tes'),
          ),
        ],
      ),
    );
    return shouldExit ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final currentQ = _questions[_currentIndex];
    final int selectedOption = _userAnswers[_currentIndex] ?? -1;
    final bool isCurrentAnswered = selectedOption != -1;

    return PopScope(
      canPop: _submitted,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        final navigator = Navigator.of(context);
        final bool shouldExit = await _showExitConfirmationDialog();
        if (shouldExit) {
          navigator.pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Tes PTN: ${widget.major}'),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Terjawab: ${_userAnswers.length}/${_questions.length}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              // Progress Bar
              LinearProgressIndicator(
                value: (_currentIndex + 1) / _questions.length,
                backgroundColor: isDark ? Colors.grey[800] : Colors.grey[300],
                color: Colors.blue,
                minHeight: 6,
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Soal
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Soal #${_currentIndex + 1} dari ${_questions.length}',
                            style: TextStyle(
                              color: isDark ? Colors.white70 : Colors.black54,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'Passing Grade: 8/10',
                              style: TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Card Pertanyaan
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            currentQ.questionText,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Choices List
                      ...List.generate(currentQ.options.length, (optIndex) {
                        final bool isSelected = selectedOption == optIndex;
                        final String optionLabel =
                            String.fromCharCode(65 + optIndex); // A, B, C, D

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: InkWell(
                            onTap: _submitted
                                ? null
                                : () {
                                    setState(() {
                                      _userAnswers[_currentIndex] = optIndex;
                                    });
                                  },
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 14),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? (isDark
                                        ? Colors.blue.withOpacity(0.3)
                                        : Colors.blue.shade50)
                                    : (isDark
                                        ? Colors.grey[850]
                                        : Colors.grey[100]),
                                border: Border.all(
                                  color: isSelected
                                      ? Colors.blue
                                      : (isDark
                                          ? Colors.grey[700]!
                                          : Colors.grey[300]!),
                                  width: isSelected ? 2 : 1,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 14,
                                    backgroundColor: isSelected
                                        ? Colors.blue
                                        : (isDark
                                            ? Colors.grey[700]
                                            : Colors.grey[300]),
                                    child: Text(
                                      optionLabel,
                                      style: TextStyle(
                                        color: isSelected
                                            ? Colors.white
                                            : (isDark
                                                ? Colors.white70
                                                : Colors.black87),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      currentQ.options[optIndex],
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: isSelected
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),

              // Navigation Bottom Buttons
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[900] : Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, -2),
                    )
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (_currentIndex > 0)
                      OutlinedButton.icon(
                        onPressed: () {
                          setState(() {
                            _currentIndex--;
                          });
                        },
                        icon: const Icon(Icons.arrow_back),
                        label: const Text('Sebelumnya'),
                      )
                    else
                      const SizedBox.shrink(),
                    if (_currentIndex < _questions.length - 1)
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: isCurrentAnswered
                            ? () {
                                setState(() {
                                  _currentIndex++;
                                });
                              }
                            : null,
                        icon: const Icon(Icons.arrow_forward),
                        label: const Text('Berikutnya'),
                      )
                    else
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                        ),
                        onPressed: isCurrentAnswered ? _submitExam : null,
                        icon: const Icon(Icons.send),
                        label: const Text('Kumpulkan Tes',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
