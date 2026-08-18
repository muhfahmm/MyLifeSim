// lib/game/widgets/dialog_helper.dart
import 'package:flutter/material.dart';

class DialogHelper {
  static void show({
    required BuildContext context,
    required String title,
    required Widget content,
    List<Widget>? actions,
  }) {
    final bool isMobile = MediaQuery.of(context).size.width < 600;

    if (isMobile) {
      // --- MODE HP: MUNCUL DARI BAWAH (Bottom Sheet) ---
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) => Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.85,
          ),
          child: Material(
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Flexible(
                    child: SingleChildScrollView(
                      child: content,
                    ),
                  ),
                  if (actions != null) ...[
                    const SizedBox(height: 8),
                    ...actions,
                  ],
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      // --- MODE DESKTOP: MUNCUL LANGSUNG TANPA ANIMASI ---
      showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
        transitionDuration: Duration.zero,
        transitionBuilder: (context, anim1, anim2, child) => child,
        pageBuilder: (context, anim1, anim2) => Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 500,
              constraints: const BoxConstraints(maxHeight: 750, minHeight: 200),
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Flexible(
                    child: SingleChildScrollView(
                      child: content,
                    ),
                  ),
                  if (actions != null) ...[
                    const SizedBox(height: 12),
                    ...actions,
                  ],
                ],
              ),
            ),
          ),
        ),
      );
    }
  }
}
