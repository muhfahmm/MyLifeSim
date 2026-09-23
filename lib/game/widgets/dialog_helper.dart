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
    final bool isMobile = screenWidth < 768;

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (isNotification) {
      // Centered scale-animated modal card popup
      final double dialogWidth = isMobile ? (screenWidth - 48).clamp(280.0, 360.0) : (screenWidth * 0.70).clamp(300.0, 420.0);
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
      // Menu Display: Mobile uses Modal popup, Tablet & Desktop redirect directly as a normal Page (no modal overlay)
      if (!isMobile) {
        // TABLET & DESKTOP: Redirect as a full Page Route
        return Navigator.of(context).push(
          MaterialPageRoute(
            builder: (routeContext) {
              final routeTheme = Theme.of(routeContext);
              final routeIsDark = routeTheme.brightness == Brightness.dark;
              final Color effectiveHeader = headerColor ?? (routeIsDark ? const Color(0xFF1F2937) : Colors.indigo);

              return Scaffold(
                backgroundColor: routeIsDark ? const Color(0xFF111827) : const Color(0xFFF3F4F6),
                appBar: AppBar(
                  title: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  backgroundColor: effectiveHeader,
                  elevation: 2,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.of(routeContext).pop(),
                  ),
                ),
                body: SafeArea(
                  child: Center(
                    child: Container(
                    constraints: const BoxConstraints(maxWidth: 1100),
                    padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: Card(
                              elevation: 2,
                              color: routeIsDark ? const Color(0xFF1F2937) : Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: SingleChildScrollView(
                                  physics: const BouncingScrollPhysics(),
                                  child: DefaultTextStyle(
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: routeIsDark ? Colors.white70 : Colors.black87,
                                    ),
                                    child: content,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if (actions != null && actions.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: actions,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }

      // MOBILE: Modal overlay sheet / fullscreen card style
      final double dialogWidth = screenWidth;
      final double dialogHeight = screenHeight;

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
                borderRadius: BorderRadius.zero,
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
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
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

  /// Utility helper to check if device is mobile layout (< 768px width)
  static bool isMobileLayout(BuildContext context) {
    return MediaQuery.of(context).size.width < 768;
  }

  /// Helper to present responsive menus: Modal on Mobile, Direct Page Redirect on Tablet/Desktop
  static Future<void> showResponsiveMenu({
    required BuildContext context,
    required String title,
    required Widget content,
    List<Widget>? actions,
    Color? headerColor,
  }) {
    return show(
      context: context,
      title: title,
      content: content,
      actions: actions,
      isNotification: false,
      headerColor: headerColor,
    );
  }

  /// Single standardized modal for feature lock notifications (no lock emojis)
  static Future<void> showFeatureLocked({
    required BuildContext context,
    String title = 'Fitur Terkunci',
    required String message,
  }) {
    final cleanTitle = title.replaceAll('🔒', '').replaceAll('🔐', '').replaceAll('🔑', '').trim();
    final cleanMessage = message.replaceAll('🔒', '').replaceAll('🔐', '').replaceAll('🔑', '').trim();
    return show(
      context: context,
      title: cleanTitle.isEmpty ? 'Fitur Terkunci' : cleanTitle,
      content: Text(cleanMessage),
      isNotification: true,
    );
  }
}
