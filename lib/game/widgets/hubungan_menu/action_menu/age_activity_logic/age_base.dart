// lib/game/widgets/hubungan_menu/action_menu/age_activity_logic/age_base.dart
import 'package:flutter/material.dart';

class ActionItem {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  ActionItem({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}