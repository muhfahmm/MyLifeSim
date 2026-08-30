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
        final double screenWidth = MediaQuery.of(context).size.width;
        final bool isMobile = screenWidth < 600;

        showGeneralDialog(
          context: context,
          barrierDismissible: true,
          barrierColor: Colors.black54,
          barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
          transitionDuration: Duration.zero,
          transitionBuilder: (context, anim1, anim2, child) => child,
          pageBuilder: (context, anim1, anim2) {
            final theme = Theme.of(context);
            final isDark = theme.brightness == Brightness.dark;
            return StatefulBuilder(
              builder: (context, setDialogState) => Center(
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    width: isMobile ? screenWidth : 500,
                    height: isMobile ? MediaQuery.of(context).size.height : null,
                    constraints: isMobile
                        ? null
                        : const BoxConstraints(maxHeight: 750, minHeight: 200),
                    padding: const EdgeInsets.all(24.0),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey.shade900 : Colors.white,
                      borderRadius: isMobile ? BorderRadius.zero : BorderRadius.circular(16),
                      boxShadow: isMobile ? null : [BoxShadow(color: isDark ? Colors.black54 : Colors.black26, blurRadius: 10)],
                    ),
                    child: SafeArea(
                      child: DefaultTextStyle(
                        style: TextStyle(
                          color: isDark ? Colors.white70 : Colors.black87,
                          fontSize: 14,
                        ),
                        child: Column(
                          mainAxisSize: isMobile ? MainAxisSize.max : MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.inbox, color: Colors.blue),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Kotak Masuk (Inbox)',
                                    style: TextStyle(
                                      fontSize: 18, 
                                      fontWeight: FontWeight.bold,
                                      color: isDark ? Colors.white : Colors.black87,
                                    ),
                                  ),
                                ),
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
                                  ),
                                IconButton(
                                  icon: Icon(Icons.close, color: isDark ? Colors.white70 : Colors.black54),
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Flexible(
                              child: character.inbox.isEmpty
                                  ? const SizedBox(
                                      height: 200,
                                      child: Center(
                                        child: Text(
                                          'Kotak masuk kosong.',
                                          style: TextStyle(color: Colors.grey, fontSize: 14),
                                        ),
                                      ),
                                    )
                                  : ListView.builder(
                                      physics: const ClampingScrollPhysics(),
                                      itemCount: character.inbox.length,
                                      itemBuilder: (context, index) {
                                        final item = character.inbox[index];
                                        return Card(
                                          elevation: 0,
                                          color: isDark ? Colors.grey.shade800 : Colors.grey.shade50,
                                          margin: const EdgeInsets.only(bottom: 8),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                            side: BorderSide(color: isDark ? Colors.grey.shade800 : Colors.grey.shade200),
                                          ),
                                          child: ListTile(
                                            title: Text(
                                              item, 
                                              style: TextStyle(
                                                fontSize: 13, 
                                                fontWeight: FontWeight.w500,
                                                color: isDark ? Colors.white : Colors.black87,
                                              ),
                                            ),
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
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
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
