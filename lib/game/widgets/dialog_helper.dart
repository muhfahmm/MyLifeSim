// lib/game/widgets/dialog_helper.dart
import 'package:flutter/material.dart';

class DialogHelper {
  static void show({
    required BuildContext context,
    required String title,
    required Widget content,
    List<Widget>? actions,
  }) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 600;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black54,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      transitionDuration: Duration.zero,
      transitionBuilder: (context, anim1, anim2, child) => child,
      pageBuilder: (context, anim1, anim2) => Center(
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
              color: Colors.white,
              borderRadius: isMobile ? BorderRadius.zero : BorderRadius.circular(16),
              boxShadow: isMobile ? null : [BoxShadow(color: Colors.black26, blurRadius: 10)],
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: isMobile ? MainAxisSize.max : MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title, 
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Flexible(
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
