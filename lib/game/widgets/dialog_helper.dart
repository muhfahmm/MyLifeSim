// lib/game/widgets/dialog_helper.dart
import 'package:flutter/material.dart';

class DialogHelper {
  static Future<void> show({
    required BuildContext context,
    required String title,
    required Widget content,
    List<Widget>? actions,
    bool isNotification = true, // Defaults to true so all activity results become modals
  }) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final bool isMobile = screenWidth < 600;

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (isNotification) {
      // Centered scale-animated modal card popup
      final double dialogWidth = (screenWidth * 0.88).clamp(280, 480);
      return showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierColor: Colors.black54,
        barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
        transitionDuration: const Duration(milliseconds: 200),
        transitionBuilder: (context, anim1, anim2, child) {
          return ScaleTransition(
            scale: CurvedAnimation(
              parent: anim1,
              curve: Curves.easeOutBack,
            ),
            child: FadeTransition(opacity: anim1, child: child),
          );
        },
        pageBuilder: (context, anim1, anim2) => Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: dialogWidth,
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey.shade900 : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: isDark ? Colors.black54 : Colors.black.withAlpha(38),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  )
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min, // Wrap height automatically
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: 18, 
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.grey),
                        onPressed: () => Navigator.pop(context),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Flexible(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: DefaultTextStyle(
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark ? Colors.white70 : Colors.black87,
                          height: 1.4,
                        ),
                        child: content,
                      ),
                    ),
                  ),
                  if (actions != null) ...[
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: actions.map((a) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: a,
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      // Fullscreen/Stretching card style for main dashboard pages (Anak-anak, Hubungan, Assets, dll.)
      final double dialogWidth = isMobile ? screenWidth : 500;
      final double dialogHeight = isMobile ? screenHeight : (screenHeight * 0.85).clamp(300, 700);

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
                color: isDark ? Colors.grey.shade900 : Colors.white,
                borderRadius: isMobile ? BorderRadius.zero : BorderRadius.circular(16),
                boxShadow: isMobile ? null : [BoxShadow(color: isDark ? Colors.black54 : Colors.black26, blurRadius: 10)],
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
                            style: TextStyle(
                              fontSize: 18, 
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close, color: isDark ? Colors.white70 : Colors.black54),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const ClampingScrollPhysics(),
                        child: DefaultTextStyle(
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark ? Colors.white70 : Colors.black87,
                          ),
                          child: content,
                        ),
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
}
