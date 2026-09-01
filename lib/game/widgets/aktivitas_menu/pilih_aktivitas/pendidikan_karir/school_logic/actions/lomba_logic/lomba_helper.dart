// lib/game/widgets/aktivitas_menu/pilih_aktivitas/pendidikan_karir/school_logic/actions/lomba_logic/lomba_helper.dart
import 'package:flutter/material.dart';
import 'package:bitlife/game/widgets/dialog_helper.dart';

class LombaQuizDialog extends StatefulWidget {
  final String title;
  final String category;
  final String question;
  final List<String> options;
  final int correctIndex;
  final VoidCallback onSuccess;
  final VoidCallback onFail;

  const LombaQuizDialog({
    super.key,
    required this.title,
    required this.category,
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.onSuccess,
    required this.onFail,
  });

  @override
  State<LombaQuizDialog> createState() => _LombaQuizDialogState();
}

class _LombaQuizDialogState extends State<LombaQuizDialog> {
  int? selectedOptionIndex;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.emoji_events, color: Colors.amber, size: 28),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.amber.shade100,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              'Kategori: ${widget.category}',
              style: TextStyle(fontSize: 12, color: Colors.amber.shade900, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.question,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            ...List.generate(widget.options.length, (index) {
              final isSelected = selectedOptionIndex == index;
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (isDark ? Colors.amber.shade900.withOpacity(0.4) : Colors.amber.shade100)
                      : (isDark ? Colors.grey.shade800 : Colors.grey.shade100),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected ? Colors.amber : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: ListTile(
                  title: Text(widget.options[index], style: const TextStyle(fontSize: 14)),
                  leading: Radio<int>(
                    value: index,
                    groupValue: selectedOptionIndex,
                    activeColor: Colors.amber,
                    onChanged: (val) {
                      setState(() {
                        selectedOptionIndex = val;
                      });
                    },
                  ),
                  onTap: () {
                    setState(() {
                      selectedOptionIndex = index;
                    });
                  },
                ),
              );
            }),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal', style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber.shade700,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: selectedOptionIndex == null
              ? null
              : () {
                  Navigator.pop(context);
                  if (selectedOptionIndex == widget.correctIndex) {
                    widget.onSuccess();
                  } else {
                    widget.onFail();
                  }
                },
          child: const Text('Jawab & Kirim'),
        ),
      ],
    );
  }
}

void showLombaOutcome(BuildContext context, String title, String message, {VoidCallback? onConfirm}) {
  DialogHelper.show(
    context: context,
    title: title,
    content: Text(message),
    actions: [
      TextButton(
        onPressed: () {
          Navigator.pop(context);
          if (onConfirm != null) onConfirm();
        },
        child: const Text('OK'),
      ),
    ],
  );
}
