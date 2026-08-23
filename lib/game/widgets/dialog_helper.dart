// lib/game/widgets/dialog_helper.dart
import 'package:flutter/material.dart';

class DialogHelper {
  static Future<void> show({
    required BuildContext context,
    required String title,
    required Widget content,
    List<Widget>? actions,
  }) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final bool isMobile = screenWidth < 600;

    // Selalu beri bounded height agar render box tidak kehilangan ukuran.
    // Di mobile, kita buat fullscreen seperti Kotak Masuk (Inbox).
    final double dialogWidth = isMobile ? screenWidth : 500;
    final double dialogHeight = isMobile
        ? screenHeight
        : (screenHeight * 0.85).clamp(300, 700);

    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black54,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      transitionDuration: const Duration(milliseconds: 200),
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(opacity: anim1, child: child);
      },
      pageBuilder: (context, anim1, anim2) => Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: dialogWidth,
            height: dialogHeight,
            padding: isMobile ? const EdgeInsets.fromLTRB(16, 8, 16, 8) : const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: isMobile ? BorderRadius.zero : BorderRadius.circular(16),
              boxShadow: isMobile ? null : [const BoxShadow(color: Colors.black26, blurRadius: 10)],
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
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
      ),
    );
  }
}
