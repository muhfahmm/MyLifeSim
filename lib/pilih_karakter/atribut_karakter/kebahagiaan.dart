import '../character.dart';

extension KebahagiaanExtension on Character {
  void changeHappiness(int delta) {
    happiness = (happiness + delta).clamp(0, 100);
  }
}
