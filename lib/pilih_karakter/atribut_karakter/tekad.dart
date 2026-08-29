import '../character.dart';

extension TekadExtension on Character {
  void changeWillpower(int delta) {
    willpower = (willpower + delta).clamp(0, 100);
  }
}
