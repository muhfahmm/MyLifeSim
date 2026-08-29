import '../character.dart';

extension DisiplinExtension on Character {
  void changeDiscipline(int delta) {
    discipline = (discipline + delta).clamp(0, 100);
  }
}
