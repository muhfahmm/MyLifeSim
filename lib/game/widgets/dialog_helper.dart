// lib/game/widgets/dialog_helper.dart
import 'package:flutter/material.dart';

class DialogHelper {
  static Future<void> show({
    required BuildContext context,
    required String title,
    required Widget content,
    List<Widget>? actions,
    bool isNotification = true, // Defaults to true so all activity results become modals
    bool showCloseButton = true, // Set to false when user must choose an action
    bool barrierDismissible = true,
    VoidCallback? onClose,
    Color? headerColor,
  }) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final bool isMobile = screenWidth < 600;

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (isNotification) {
      // Centered scale-animated modal card popup
      final double dialogWidth = isMobile ? (screenWidth - 24) : (screenWidth * 0.90).clamp(320.0, 500.0);
      return showGeneralDialog(
        context: context,
        barrierDismissible: barrierDismissible,
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
        pageBuilder: (dialogContext, anim1, anim2) => PopScope(
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) {
              onClose?.call();
            }
          },
          child: Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: dialogWidth,
              clipBehavior: Clip.antiAlias,
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
                  if (headerColor != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
                      color: headerColor,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                height: 1.2,
                              ),
                            ),
                          ),
                          if (showCloseButton) ...[
                            const SizedBox(width: 8),
                            InkWell(
                              onTap: () {
                                Navigator.of(dialogContext).pop();
                              },
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  size: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  Padding(
                    padding: headerColor != null
                        ? const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 16.0)
                        : const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (headerColor == null)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  title,
                                  style: TextStyle(
                                    fontSize: 18, 
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? Colors.white : Colors.black87,
                                    height: 1.2,
                                  ),
                                ),
                              ),
                              if (showCloseButton) ...[
                                const SizedBox(width: 8),
                                InkWell(
                                  onTap: () {
                                    Navigator.of(dialogContext).pop();
                                  },
                                  borderRadius: BorderRadius.circular(16),
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.close,
                                      size: 18,
                                      color: isDark ? Colors.white70 : Colors.grey.shade600,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        if (headerColor == null) const SizedBox(height: 12),
                        Flexible(
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: DefaultTextStyle(
                              style: TextStyle(
                                fontSize: 13,
                                color: isDark ? Colors.white70 : Colors.black87,
                                height: 1.4,
                              ),
                              child: content,
                            ),
                          ),
                        ),
                        if (actions != null && actions.isNotEmpty) ...[
                          const SizedBox(height: 18),
                          Wrap(
                            alignment: WrapAlignment.end,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 8.0,
                            runSpacing: 8.0,
                            children: actions,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      );
    } else {
      // Fullscreen/Stretching card style for main dashboard pages (Anak-anak, Hubungan, Assets, dll.)
      final double dialogWidth = isMobile ? screenWidth : 500;
      final double dialogHeight = isMobile ? screenHeight : (screenHeight * 0.85).clamp(300, 700);

      final Color effectiveHeaderColor = headerColor ?? (isDark ? Colors.grey.shade900 : Colors.white);
      final bool hasHeaderColor = headerColor != null;

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
              clipBehavior: Clip.antiAlias,
              padding: EdgeInsets.zero,
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
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                      color: effectiveHeaderColor,
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: TextStyle(
                                fontSize: 18, 
                                fontWeight: FontWeight.bold,
                                color: hasHeaderColor
                                    ? Colors.white
                                    : (isDark ? Colors.white : Colors.black87),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.close,
                              color: hasHeaderColor
                                  ? Colors.white
                                  : (isDark ? Colors.white70 : Colors.black54),
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: isMobile ? const EdgeInsets.fromLTRB(16, 12, 16, 8) : const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
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
