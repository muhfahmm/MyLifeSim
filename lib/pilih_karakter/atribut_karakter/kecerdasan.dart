import '../character.dart';

extension KecerdasanExtension on Character {
  void changeIntelligence(int delta) {
    intelligence = (intelligence + delta).clamp(0, 100);
  }
}
