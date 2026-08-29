import '../character.dart';

extension KesuburanExtension on Character {
  void changeFertility(int delta) {
    fertility = (fertility + delta).clamp(0, 100);
  }
}
