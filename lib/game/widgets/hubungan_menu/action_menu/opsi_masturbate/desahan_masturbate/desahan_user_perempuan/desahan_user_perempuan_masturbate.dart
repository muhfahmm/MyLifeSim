// lib/game/widgets/hubungan_menu/action_menu/opsi_masturbate/desahan_masturbate/desahan_user_perempuan/desahan_user_perempuan_masturbate.dart

import 'dart:math';
import 'package:mylifesim/pilih_karakter/character.dart';

class DesahanUserPerempuanMasturbate {
  static final Random _random = Random();

  // ==========================================================
  // LIBRARY 50 MASTURBATION MOANS USER PEREMPUAN SHY (PEMALU)
  // ==========================================================
  static const List<String> _shyMoans = [
    "Mmh... ah... pelan-pelan kuusap membayangkanmu...",
    "Hah... jangan lihat aku... aku malu membayangkan ini...",
    "A-aku... ahh... tidak bisa berpikir selain kamu...",
    "Hah... hah... jariku gemetar menyentuh raga...",
    "Mmh... ah... sentuhan ini... terasa sangat nikmat...",
    "Hah... ahh... membayangkan pelukanmu di malam redup...",
    "Aah... ah... peluk aku dalam lamunanmu...",
    "Hah... hah... kamu membuat jantungku berdebar rindu...",
    "Ahh... a-aku mulai... hah... tak bisa menahannya...",
    "Mmh... mmmh... ahh...",
    "Hah... hah... aku malu tapi merindukanmu...",
    "Ahh... k-kamu mendengar rintihan lamunanku? Malu...",
    "Hah... ahh... aku ingin bersembunyi dalam dekapanmu...",
    "Mmh... ah... a-aku sangat sensitif malam ini...",
    "Hah... hah... sentuhan ini... rasanya... ahh...",
    "Ahh... ahh... m-mata kita membayang... jangan...",
    "Hah... j-jangan berhenti membayangkanmu... ahh...",
    "Mmh... aah... m-merinding rindu...",
    "Hah... hah... a-aku malu tapi ingin membayangkan lebih...",
    "Ahh... ah... s-sentuhan bayangan jemarimu...",
    "Hah... h-hah... aku tak berani desah kencang...",
    "Mmh... ah... ahh... pelan-pelan kuusap...",
    "Hah... aku... ahh... aku sangat lemah merindukanmu...",
    "Ahh... hah... tubuhku... hah... gemetar hangat...",
    "Mmh... mmm... ahh...",
    "Hah... hah... aku... aku tidak tahan...",
    "Ahh... ahhh... aku leleh membayangkanmu...",
    "Hah... j-jangan biarkan lamunan ini usai...",
    "Mmh... ahh... kamu... kamu membuatku ketagihan...",
    "Hah... hah... a-aku ingin... ahh...",
    "Ahh... hah... a-aku sudah dekat klimaks...",
    "Mmh... ah... menyentuh diri sendiri dalam redup...",
    "Hah... hah... membayangkan kecupan bibirmu lembut...",
    "Ahh... ahh... bisikanmu buat aku tersipu...",
    "Mmh... hah... usapan di punggung dalam bayangan...",
    "Hah... ah... tubuhku makin hangat merindu...",
    "Ahh... hah... aku memejamkan mata rapat...",
    "Mmh... ahh... pelukanmu teringat erat...",
    "Hah... hah... napasku... tersengal pelan...",
    "Ahh... ah... sensasi ini... sungguh indah...",
    "Mmh... hah... m-merapatlah dalam ingatan...",
    "Hah... ahh... aku sangat mencintaimu...",
    "Ahh... hah... sentuhan khayalan ini manis...",
    "Mmh... ah... aku lelah tapi bahagia...",
    "Hah... hah... dekap aku dalam impian...",
    "Ahh... ahh... suara napasmu dekat terasa...",
    "Mmh... hah... tak ingin lepas dari ingatan...",
    "Hah... ah... ini sungguh romantis...",
    "Ahh... hah... hatiku luluh sepenuhnya...",
    "Mmh... ahh... aku milikmu dalam lamunan..."
  ];

  // ==========================================================
  // LIBRARY 50 MASTURBATION MOANS USER PEREMPUAN BOLD (BERGHIERAH / PERCAYA DIRI)
  // ==========================================================
  static const List<String> _boldMoans = [
    "Ah! Lebih cepat kuusap membayangkanmu sayang!",
    "Hah... hah... bayanganmu luar biasa panas malam ini!",
    "Ugh! Terus sentuh di situ... membayangkanmu nikmat!",
    "Mmh! Gairahku membakar... aku menginginkanmu!",
    "Ah! Memikirkanmu membuatku semakin gila!",
    "Hah... aku milikmu sepenuhnya... bayangan bibirmu!",
    "Ugh! Gerakan jemariku makin nikmat!",
    "Mmh! Mengingat pelukan eratmu... teruskan!",
    "Ah! Sensasi ini sungguh meledak hebat!",
    "Hah... hah... cepat membayangkan sentuhanmu!",
    "Ugh! Kamu pria paling memikat hatiku!",
    "Mmh! Rasakan betapa hangatnya tubuhku!",
    "Ah! Jangan beri aku jeda sedikit pun!",
    "Hah... hah... aku tidak bisa menahannya lagi!",
    "Ugh! Terus pacu gairah khayalan ini!",
    "Mmh! Mengingat ciuman penuh nafsu darimu!",
    "Ah! Membayangkanmu buat tubuh gemetar!",
    "Hah... gairah impian kita menyatu sempurna!",
    "Ugh! Pelukan penuh bertenaga darimu gila!",
    "Mmh! Aku ingin kehangatanmu bertahan lama!",
    "Ah! Lebih dalam membayangkan kehadiranmu!",
    "Hah... hah... napasku makin memburu cepat!",
    "Ugh! Sentuhan jemarimu teringat lihai!",
    "Mmh! Tatap mataku dalam bayangan mesra!",
    "Ah! Teruskan gesekan membara dalam lamunan!",
    "Hah... gairah ini tak ada tandingannya!",
    "Ugh! Kamu sungguh memikat hatiku!",
    "Mmh! Rasakan detak jantungku yang berpacu!",
    "Ah! Aku tenggelam dalam nikmat impian!",
    "Hah... hah... membayangkanmu lagi dan lagi!",
    "Ugh! Sensasi ini membakar jiwaku!",
    "Mmh! Mengingat kecupan leher dan pelukan!",
    "Ah! Gerakan mesramu teringat juara!",
    "Hah... aku ketagihan membayangkan sentuhanmu!",
    "Ugh! Jangan berhenti sampai aku klimaks!",
    "Mmh! Energi cinta khayalan sangat intens!",
    "Ah! Memikirkanmu buat malam ini panas!",
    "Hah... hah... sentuhan ini luar biasa!",
    "Ugh! Aku terpikat oleh keahlianmu!",
    "Mmh! Gairah ini meluap tak terbendung!",
    "Ah! Pelukan bayanganmu sekuat badai!",
    "Hah... kamu berhasil membuatku melayang!",
    "Ugh! Malam ini milik kita dalam impian!",
    "Mmh! Terus sentuh area sensitif ini!",
    "Ah! Nikmat khayalan ini terasa nyata!",
    "Hah... hah... ayo capai puncak impian!",
    "Ugh! Bayanganmu tidak pernah kecewa!",
    "Mmh! Rangkul raga ini dalam ingatan!",
    "Ah! Sentuhanmu menyalakan api gairah!",
    "Hah... membayangkanmu adalah nikmat sejati!"
  ];

  // ==========================================================
  // LIBRARY 50 MASTURBATION MOANS USER PEREMPUAN KIND (PENUH KASIH SAYANG / LEMBUT)
  // ==========================================================
  static const List<String> _kindMoans = [
    "Hah... kehangatanmu teringat membuat tenang...",
    "Mmh... aku sangat mencintaimu sayang...",
    "Ahh... sentuhan lembutmu teringat indah...",
    "Hah... membayangkan pelukanmu ternyaman...",
    "Mmh... memikirkan elusan rambutmu...",
    "Ahh... ciuman manis ini terasa sangat tulus...",
    "Hah... terima kasih sudah hadir dalam hidupku...",
    "Mmh... bahagia bisa membayangkanmu malam ini...",
    "Ahh... kelembutanmu luluh di dalam sukmaku...",
    "Hah... genggam jariku teringat erat...",
    "Mmh... tatapan hangatmu menyejukkan jiwa...",
    "Ahh... rasakan detak dada yang menyatu...",
    "Hah... kasih sayangmu membalut hatiku...",
    "Mmh... bisikan kata cinta teringat di telinga...",
    "Ahh... kecupan di dahi teringat manis...",
    "Hah... aku merasa dicintai sepenuh hati...",
    "Mmh... bersamamu segalanya terasa indah...",
    "Ahh... kedamaian kenangan ini tak ternilai...",
    "Hah... mengingat belaian pipi penuh ketulusan...",
    "Mmh... rangkulanmu membuat merasa aman...",
    "Ahh... ingin berada di pelukanmu selalu...",
    "Hah... napas hangatmu teringat dekat...",
    "Mmh... keindahan kenangan ini milik kita...",
    "Ahh... setiap sentuhanmu penuh hangat...",
    "Hah... senyuman manis itu teringat jelas...",
    "Mmh... usapan lembutmu menentramkan...",
    "Ahh... aku luluh dalam cinta tulusmu...",
    "Hah... mari nikmati kebersamaan impian...",
    "Mmh... kecupan manis di pipi teringat hangat...",
    "Ahh... terima kasih telah merawat cinta kita...",
    "Hah... bayanganmu bimbing kedamaian rasa...",
    "Mmh... tatapan matamu memancarkan kebaikan...",
    "Ahh... belaian di punggung penuh kasih...",
    "Hah... kehangatan raga teringat bersatu...",
    "Mmh... aku mengagumi kelembutan hatimu...",
    "Ahh... memikirkanmu hariku terasa utuh...",
    "Hah... keindahan ini akan selalu kuingat...",
    "Mmh... membayangkan pelukanmu sampai pagi...",
    "Ahh... ciuman mesra ini begitu berharga...",
    "Hah... detak jantungmu menenangkan hati...",
    "Mmh... kasih sayangmu tak pernah berkurang...",
    "Ahh... kecupan lembut di bibir teringat manis...",
    "Hah... rasa sayang ini terus tumbuh...",
    "Mmh... belai jemari teringat penuh mesra...",
    "Ahh... aku sangat bersyukur memilikimu...",
    "Hah... rangkulan hangatmu mengusir lelah...",
    "Mmh... kebersamaan khayalan ini sempurna...",
    "Ahh... rasakan kehangatan cinta murni...",
    "Hah... bisikan sayangmu menyejukkan rasa...",
    "Mmh... aku milikmu selamanya sayang..."
  ];

  static String getRandomMoan([dynamic player]) {
    String trait = '';
    if (player is Character) {
      trait = player.traits.join(' ').toLowerCase();
    } else if (player is Map<String, dynamic>) {
      trait = (player['personality'] ?? player['trait'] ?? '').toString().toLowerCase();
    }
    if (trait.contains('pemalu') || trait.contains('shy') || trait.contains('pendiam')) {
      return _shyMoans[_random.nextInt(_shyMoans.length)];
    }
    if (trait.contains('ekstrovert') || trait.contains('bold') || trait.contains('gairah') || trait.contains('percaya diri')) {
      return _boldMoans[_random.nextInt(_boldMoans.length)];
    }
    if (trait.contains('penyayang') || trait.contains('kind') || trait.contains('baik')) {
      return _kindMoans[_random.nextInt(_kindMoans.length)];
    }
    final int category = _random.nextInt(3);
    if (category == 0) return _shyMoans[_random.nextInt(_shyMoans.length)];
    if (category == 1) return _boldMoans[_random.nextInt(_boldMoans.length)];
    return _kindMoans[_random.nextInt(_kindMoans.length)];
  }
}
