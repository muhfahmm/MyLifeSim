// lib/game/widgets/hubungan_menu/action_menu/opsi_bercinta/aksi_intim/fingering.dart

import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/avatar/vn_character_view.dart';
import 'package:mylifesim/game/widgets/vn_dialogue/vn_dialogue_models.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/opsi_bercinta/panggilan_logic/panggilan_manager.dart';

class FingeringHelper {
  /// Mendapatkan daftar opsi teknik stimulasi / fingering berdasarkan gender pasangan target
  static List<Map<String, dynamic>> getFingeringOptions({required String targetGender}) {
    final bool isTargetFemale = targetGender.trim().toLowerCase() == 'perempuan';

    if (isTargetFemale) {
      return [
        {
          'id': 'gentle',
          'label': 'Lembut & Perlahan 🌸',
          'description': 'Stimulasi perlahan dengan tekanan lembut yang membangun gairah.',
        },
        {
          'id': 'passionate',
          'label': 'Penuh Gairah 🔥',
          'description': 'Gerakan cepat dan bersemangat menuju puncak kenikmatan.',
        },
        {
          'id': 'clitoris',
          'label': 'Fokus Klitoris 💜',
          'description': 'Stimulasi terfokus pada titik paling sensitif.',
        },
        {
          'id': 'gspot',
          'label': 'Stimulasi G-Spot 💫',
          'description': 'Eksplorasi titik G yang memberikan sensasi luar biasa.',
        },
      ];
    } else {
      return [
        {
          'id': 'gentle',
          'label': 'Lembut & Perlahan 🌸',
          'description': 'Stimulasi perlahan dengan tekanan lembut yang membangun gairah.',
        },
        {
          'id': 'passionate',
          'label': 'Penuh Gairah 🔥',
          'description': 'Gerakan cepat dan bersemangat menuju puncak kenikmatan.',
        },
        {
          'id': 'penis',
          'label': 'Fokus Penis / Membelai 🖐️',
          'description': 'Membelai dan memijat area penis pasangan dengan lembut dan hangat.',
        },
        {
          'id': 'testis',
          'label': 'Fokus Testis 🍒',
          'description': 'Memberikan usapan halus pada area testis untuk merangsang sensitivitas.',
        },
      ];
    }
  }

  /// Legacy getter for fallback
  static List<Map<String, dynamic>> get fingeringOptions => getFingeringOptions(targetGender: 'perempuan');

  /// Menghasilkan VN Dialogue Nodes sesuai teknik fingering / stimulasi yang dipilih.
  static List<VNDialogueNode> generateFingeringDialogueNodes({
    required Character character,
    required String targetName,
    required String targetGender,
    required String fingeringId,
    required String fingeringLabel,
    String targetRole = 'Pasangan',
  }) {
    // Jika function dipanggil untuk "Lakukan stimulasi kepada [Target]",
    // maka Aktif (yang merangsang) = User (Player), Pasif (yang dirangsang) = Pasangan (Target).
    // isPlayerActive: true jika player yang melakukan aksi stimulasi ke pasangan.
    final String aktifName = character.name;
    final String pasifName = targetName;

    // callFromPasif: NPC (pasif/pasangan) berbicara kepada Player (aktif/user)
    // isSpeakerPlayer = false
    final String callFromPasif = PanggilanManager.getPanggilan(
      targetName: character.name,
      targetRole: targetRole,
      targetGender: character.gender,
      isSpeakerPlayer: false,
      userName: character.name,
      userGender: character.gender,
      isIntimate: true,
    );

    // callFromAktif: Player (aktif/user) berbicara kepada NPC (pasif/pasangan)
    // isSpeakerPlayer = true
    final String callFromAktif = PanggilanManager.getPanggilan(
      targetName: targetName,
      targetRole: targetRole,
      targetGender: targetGender,
      isSpeakerPlayer: true,
      userName: character.name,
      userGender: character.gender,
      isIntimate: true,
    );

    List<VNDialogueNode> nodes = [];

    switch (fingeringId) {
      case 'gentle':
        nodes = [
          VNDialogueNode(
            speakerName: 'Narasi',
            dialogueText:
                '($aktifName mendekatkan tangannya perlahan, jari-jari lembut mulai membelai area intim $pasifName dengan hati-hati dan penuh perhatian...) 🌸',
            emotion: VNEmotionType.blush,
            isPlayerSpeaking: true,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
          VNDialogueNode(
            speakerName: aktifName,
            dialogueText:
                'Rileks saja $callFromAktif... aku akan membuatmu merasakan sensasi yang indah dan lembut... 💕',
            emotion: VNEmotionType.happy,
            isPlayerSpeaking: true,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
          VNDialogueNode(
            speakerName: pasifName,
            dialogueText:
                'Mmhh... $callFromPasif... sentuhanmu begitu lembut dan hangat... perasaanku mulai melayang... 💗',
            emotion: VNEmotionType.blush,
            isPlayerSpeaking: false,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
          VNDialogueNode(
            speakerName: 'Narasi',
            dialogueText:
                '(Stimulasi lembut nan perlahan berhasil membangkitkan gelombang gairah yang hangat pada $pasifName...) ✨',
            emotion: VNEmotionType.blush,
            isPlayerSpeaking: false,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
        ];
        break;

      case 'passionate':
        nodes = [
          VNDialogueNode(
            speakerName: 'Narasi',
            dialogueText:
                '($aktifName menggerakkan tangannya dengan penuh semangat, ritme sentuhan yang semakin cepat membuat $pasifName menahan napas...) 🔥',
            emotion: VNEmotionType.blush,
            isPlayerSpeaking: true,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
          VNDialogueNode(
            speakerName: pasifName,
            dialogueText:
                'Ahh... nggh... $callFromPasif! Jangan berhenti... terus... semakin cepat... 😍',
            emotion: VNEmotionType.blush,
            isPlayerSpeaking: false,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
          VNDialogueNode(
            speakerName: aktifName,
            dialogueText:
                'Rasakan setiap sentuhan jari-jariku $callFromAktif... nikmati kehangatan gairah kita... 🌊',
            emotion: VNEmotionType.happy,
            isPlayerSpeaking: true,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
          VNDialogueNode(
            speakerName: 'Narasi',
            dialogueText:
                '(Gairah $pasifName mencapai titik puncaknya seiring sentuhan lincah $aktifName yang tak berhenti bergerak...) 💥',
            emotion: VNEmotionType.blush,
            isPlayerSpeaking: false,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
        ];
        break;

      case 'penis':
        nodes = [
          VNDialogueNode(
            speakerName: 'Narasi',
            dialogueText:
                '(Jari-jemari lembut $aktifName merambat turun, membelai dan mengelus penis $pasifName dengan irama hangat yang mengikuti denyut nadinya...) 🖐️',
            emotion: VNEmotionType.blush,
            isPlayerSpeaking: true,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
          VNDialogueNode(
            speakerName: pasifName,
            dialogueText:
                'Hah... hah... $callFromPasif... sentuhanmu di sana terasa sangat nikmat... teruskan belai aku... 🔥',
            emotion: VNEmotionType.blush,
            isPlayerSpeaking: false,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
          VNDialogueNode(
            speakerName: aktifName,
            dialogueText:
                'Melihatmu bergetar menikmati elusanku seperti ini membuatku semakin bergairah $callFromAktif... 💓',
            emotion: VNEmotionType.happy,
            isPlayerSpeaking: true,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
          VNDialogueNode(
            speakerName: 'Narasi',
            dialogueText:
                '(Belaian hangat pada area sensitif pria membuat tubuh $pasifName menegang penuh nikmat...) ✨',
            emotion: VNEmotionType.blush,
            isPlayerSpeaking: false,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
        ];
        break;

      case 'testis':
        nodes = [
          VNDialogueNode(
            speakerName: 'Narasi',
            dialogueText:
                '($aktifName memberikan pijatan dan usapan lembut pada area testis $pasifName, memberikan rangsangan sensitif yang menenangkan sekaligus menggoda...) 🍒',
            emotion: VNEmotionType.blush,
            isPlayerSpeaking: true,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
          VNDialogueNode(
            speakerName: pasifName,
            dialogueText:
                'Nghh... $callFromPasif... usapan halusmu di sana membuat seluruh tubuhku merasa rileks dan merinding... 💫',
            emotion: VNEmotionType.blush,
            isPlayerSpeaking: false,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
          VNDialogueNode(
            speakerName: aktifName,
            dialogueText:
                'Nikmati sensasinya $callFromAktif... aku suka memanjakan setiap inci sensitifmu... 🍒',
            emotion: VNEmotionType.happy,
            isPlayerSpeaking: true,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
          VNDialogueNode(
            speakerName: 'Narasi',
            dialogueText:
                '(Sentuhan terfokus pada testis mengirimkan getaran hangat yang intens ke seluruh tubuh $pasifName...) ✨',
            emotion: VNEmotionType.blush,
            isPlayerSpeaking: false,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
        ];
        break;

      case 'clitoris':
        nodes = [
          VNDialogueNode(
            speakerName: 'Narasi',
            dialogueText:
                '($aktifName dengan terampil menemukan titik klitoris $pasifName, memijatnya dengan lingkaran kecil yang presisi dan menggoda...) 💜',
            emotion: VNEmotionType.blush,
            isPlayerSpeaking: true,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
          VNDialogueNode(
            speakerName: pasifName,
            dialogueText:
                'Aaahh...! Di sana $callFromPasif...! Tepat di titik itu... jangan pindah... 💜',
            emotion: VNEmotionType.blush,
            isPlayerSpeaking: false,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
          VNDialogueNode(
            speakerName: aktifName,
            dialogueText:
                'Aku tahu cara terbaik membuatmu menikmati ini $callFromAktif... perhatikan tekanan jari-jariku... 💫',
            emotion: VNEmotionType.happy,
            isPlayerSpeaking: true,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
          VNDialogueNode(
            speakerName: 'Narasi',
            dialogueText:
                '(Stimulasi klitoris yang terampil membawa $pasifName menuju gelombang kenikmatan yang tak tertahankan...) ✨',
            emotion: VNEmotionType.blush,
            isPlayerSpeaking: false,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
        ];
        break;

      default: // gspot
        nodes = [
          VNDialogueNode(
            speakerName: 'Narasi',
            dialogueText:
                '($aktifName memasukkan jari dengan hati-hati, melengkungkannya perlahan mencari titik G $pasifName yang tersembunyi di dalam...) 💫',
            emotion: VNEmotionType.blush,
            isPlayerSpeaking: true,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
          VNDialogueNode(
            speakerName: pasifName,
            dialogueText:
                'OH... $callFromPasif...! Itu dia...! Terasa berbeda dari sebelumnya... sensasinya luar biasa kuat...! 💥',
            emotion: VNEmotionType.blush,
            isPlayerSpeaking: false,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
          VNDialogueNode(
            speakerName: aktifName,
            dialogueText:
                'Sudah kutemukan titikmu $callFromAktif... biarkan aku memanjakan titik spesialmu ini sampai puas... 🔥',
            emotion: VNEmotionType.happy,
            isPlayerSpeaking: true,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
          VNDialogueNode(
            speakerName: 'Narasi',
            dialogueText:
                '(Stimulasi G-Spot yang intens mengirim gelombang kenikmatan luar biasa ke seluruh tubuh $pasifName...) 💫',
            emotion: VNEmotionType.blush,
            isPlayerSpeaking: false,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
        ];
        break;
    }

    return nodes;
  }
}
