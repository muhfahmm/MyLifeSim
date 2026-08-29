import '../character.dart';

extension KarmaExtension on Character {
  void changeKarma(int delta) {
    karma = (karma + delta).clamp(0, 100);
  }
}
