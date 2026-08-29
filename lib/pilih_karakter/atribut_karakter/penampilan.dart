import '../character.dart';

extension PenampilanExtension on Character {
  void changeAppearance(int delta) {
    appearance = (appearance + delta).clamp(0, 100);
  }
}
