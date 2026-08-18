// lib/game/widgets/inbox_menu/inbox_button.dart
import 'package:flutter/material.dart';
import 'package:bitlife/pilih_karakter/character.dart';

class InboxButton extends StatelessWidget {
  final Character character;
  final VoidCallback onRefresh;

  const InboxButton({
    super.key,
    required this.character,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final int count = character.inbox.length;

    return ElevatedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => StatefulBuilder(
            builder: (context, setDialogState) => AlertDialog(
              title: Row(
                children: [
                  const Icon(Icons.inbox, color: Colors.blue),
                  const SizedBox(width: 8),
                  const Text('Kotak Masuk (Inbox)', style: TextStyle(fontWeight: FontWeight.bold)),
                  const Spacer(),
                  if (character.inbox.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.delete_sweep, color: Colors.red),
                      tooltip: 'Bersihkan Semua',
                      onPressed: () {
                        setDialogState(() {
                          character.inbox.clear();
                        });
                        onRefresh();
                      },
                    )
                ],
              ),
              content: character.inbox.isEmpty
                  ? const SizedBox(
                      height: 100,
                      child: Center(
                        child: Text(
                          'Kotak masuk kosong.',
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      ),
                    )
                  : SizedBox(
                      width: double.maxFinite,
                      height: 300,
                      child: ListView.builder(
                        itemCount: character.inbox.length,
                        itemBuilder: (context, index) {
                          final item = character.inbox[index];
                          return Card(
                            elevation: 0,
                            color: Colors.grey.shade50,
                            margin: const EdgeInsets.only(bottom: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(color: Colors.grey.shade200),
                            ),
                            child: ListTile(
                              title: Text(item, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                              trailing: IconButton(
                                icon: const Icon(Icons.close, size: 16, color: Colors.grey),
                                onPressed: () {
                                  setDialogState(() {
                                    character.inbox.removeAt(index);
                                  });
                                  onRefresh();
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Tutup', style: TextStyle(fontWeight: FontWeight.bold)),
                )
              ],
            ),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue.withOpacity(0.2),
        foregroundColor: Colors.blue,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Colors.blue, width: 1.5),
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.mail_outline, size: 28),
              SizedBox(height: 4),
              Text(
                'Inbox',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.blue),
              ),
            ],
          ),
          if (count > 0)
            Positioned(
              right: -10,
              top: -10,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                constraints: const BoxConstraints(
                  minWidth: 18,
                  minHeight: 18,
                ),
                child: Text(
                  '$count',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
