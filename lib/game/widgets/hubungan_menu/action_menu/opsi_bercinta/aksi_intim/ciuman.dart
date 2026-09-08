// lib/game/widgets/hubungan_menu/action_menu/opsi_bercinta/aksi_intim/ciuman.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/game/widgets/vn_dialogue/vn_dialogue_models.dart';
import 'package:mylifesim/game/widgets/vn_dialogue/vn_dialogue_overlay.dart';
import 'package:mylifesim/avatar/vn_character_view.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/opsi_bercinta/kepuasan_bercinta.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/opsi_bercinta/hubungan_intim_logic.dart';
import 'package:mylifesim/game/widgets/hubungan_menu/action_menu/opsi_bercinta/panggilan_logic/panggilan_manager.dart';

class CiumanHelper {
  /// Opsi bagian tubuh untuk dicium
  static const List<Map<String, dynamic>> ciumOptions = [
    {
      'id': 'bibir',
      'label': 'Cium Bibir 💋',
      'icon': Icons.favorite,
      'color': Color(0xFFE91E63),
      'description': 'Sentuhan bibir yang hangat dan penuh gairah.',
    },
    {
      'id': 'leher',
      'label': 'Cium Leher 🔥',
      'icon': Icons.whatshot,
      'color': Color(0xFF9C27B0),
      'description': 'Ciuman lembut dan menggoda di area leher sensitif.',
    },
    {
      'id': 'pipi',
      'label': 'Cium Pipi 😊',
      'icon': Icons.sentiment_satisfied_alt,
      'color': Color(0xFFFF9800),
      'description': 'Ungkapan kasih sayang yang manis dan hangat.',
    },
    {
      'id': 'jidat',
      'label': 'Cium Jidat 👑',
      'icon': Icons.face,
      'color': Color(0xFF2196F3),
      'description': 'Ciuman lembut penuh perlindungan dan ketulusan.',
    },
    {
      'id': 'tangan',
      'label': 'Cium Tangan 🤝',
      'icon': Icons.back_hand,
      'color': Color(0xFF4CAF50),
      'description': 'Kecupan sopan dan mesra pada punggung tangan.',
    },
    {
      'id': 'telinga',
      'label': 'Cium Telinga 👂',
      'icon': Icons.hearing,
      'color': Color(0xFFE040FB),
      'description': 'Bisikan lembut dan kecupan di daun telinga.',
    },
  ];

  /// Menampilkan modal dialog pilihan bagian tubuh yang ingin dicium.
  static Future<void> showCiumModal({
    required BuildContext context,
    required Character character,
    required String targetName,
    required String targetRole,
    required VoidCallback onActionComplete,
  }) async {
    final String partnerGender = HubunganIntimLogic.getPartnerGender(targetName);
    final int currentSatisfaction = HubunganIntimLogic.getRelationshipValue(character, targetName);

    // Cek persetujuan/kepuasan awal
    final bool isWilling = KepuasanBercintaHelper.checkWillingness(
      context: context,
      character: character,
      targetName: targetName,
      targetGender: partnerGender,
      satisfaction: currentSatisfaction,
      onRejected: () {},
      onAccepted: () {},
    );

    if (!isWilling) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFF1E1E2E),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Indicator Bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.favorite, color: Color(0xFFE91E63), size: 24),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Cium $targetName 💋',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              const Text(
                'Pilih bagian mana yang ingin kamu cium:',
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
              const SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2.3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: ciumOptions.length,
                itemBuilder: (_, index) {
                  final opt = ciumOptions[index];
                  final Color color = opt['color'] as Color;
                  return InkWell(
                    onTap: () {
                      Navigator.pop(ctx);
                      _startCiumanVNSequence(
                        context: context,
                        character: character,
                        targetName: targetName,
                        targetGender: partnerGender,
                        partId: opt['id'] as String,
                        partLabel: opt['label'] as String,
                        onActionComplete: onActionComplete,
                      );
                    },
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      decoration: BoxDecoration(
                        color: color.withAlpha(25),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: color.withAlpha(90), width: 1.2),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(opt['icon'] as IconData, color: color, size: 18),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  opt['label'] as String,
                                  style: TextStyle(
                                    color: color,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            opt['description'] as String,
                            style: const TextStyle(color: Colors.white54, fontSize: 10),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  /// Menghasilkan VN Dialogue Nodes sesuai bagian tubuh yang dicium.
  static List<VNDialogueNode> generateCiumDialogueNodes({
    required Character character,
    required String targetName,
    required String targetGender,
    required String partId,
    required String partLabel,
    String targetRole = 'Pasangan',
  }) {
    final bool isPlayerMale = character.gender.trim().toLowerCase() == 'laki-laki';
    final String maleName = isPlayerMale ? character.name : targetName;
    final String femaleName = isPlayerMale ? targetName : character.name;

    final String callFromFemale = PanggilanManager.getPanggilan(
      targetName: isPlayerMale ? targetName : character.name,
      targetRole: targetRole,
      targetGender: isPlayerMale ? targetGender : character.gender,
      isSpeakerPlayer: !isPlayerMale,
      userName: character.name,
      userGender: character.gender,
      isIntimate: true,
    );

    final String callFromMale = PanggilanManager.getPanggilan(
      targetName: isPlayerMale ? targetName : character.name,
      targetRole: targetRole,
      targetGender: isPlayerMale ? character.gender : targetGender,
      isSpeakerPlayer: isPlayerMale,
      userName: character.name,
      userGender: character.gender,
      isIntimate: true,
    );

    List<VNDialogueNode> nodes = [];

    switch (partId) {
      case 'bibir':
        nodes = [
          VNDialogueNode(
            speakerName: 'Narasi',
            dialogueText: '($maleName menarik perlahan pinggang $femaleName, menatap matanya erat-erat sebelum mendekatkan wajah dan mendaratkan ciuman manis di bibirnya...) 💋',
            emotion: VNEmotionType.blush,
            isPlayerSpeaking: false,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
          VNDialogueNode(
            speakerName: maleName,
            dialogueText: 'Bibirmu begitu lembut, $callFromMale... aku tidak pernah bosan merasakannya. ❤️',
            emotion: VNEmotionType.happy,
            isPlayerSpeaking: isPlayerMale,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
          VNDialogueNode(
            speakerName: femaleName,
            dialogueText: 'Mmhh... jantungku selalu berdebar kencang setiap kali kamu mencium bibirku seperti ini, $callFromFemale... 🥰',
            emotion: VNEmotionType.blush,
            isPlayerSpeaking: !isPlayerMale,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
          VNDialogueNode(
            speakerName: 'Narasi',
            dialogueText: '(Ciuman bibir yang dalam dan hangat itu berlangsung beberapa saat, menyatukan napas dan gairah hangat di antara mereka berdua...) ✨',
            emotion: VNEmotionType.happy,
            isPlayerSpeaking: false,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
        ];
        break;

      case 'leher':
        nodes = [
          VNDialogueNode(
            speakerName: 'Narasi',
            dialogueText: '($maleName memiringkan sedikit kepala $femaleName, lalu mendaratkan kecupan-kecupan hangat dan desahan lembut di sepanjang garis lehernya...) 🔥',
            emotion: VNEmotionType.blush,
            isPlayerSpeaking: false,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
          VNDialogueNode(
            speakerName: maleName,
            dialogueText: 'Aroma tubuhmu di area leher ini selalu membuatku ketagihan, $callFromMale... 🌹',
            emotion: VNEmotionType.happy,
            isPlayerSpeaking: isPlayerMale,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
          VNDialogueNode(
            speakerName: femaleName,
            dialogueText: 'Ahhh... ngggh, hentikan geli... tapi jangan berhenti $callFromFemale, rasa sensasinya membuat tubuhku merinding... 😳',
            emotion: VNEmotionType.blush,
            isPlayerSpeaking: !isPlayerMale,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
          VNDialogueNode(
            speakerName: 'Narasi',
            dialogueText: '(Sentuhan bibir di leher memberikan gelombang sensasi menggoda yang membuat suasana menjadi semakin intim...) 💖',
            emotion: VNEmotionType.blush,
            isPlayerSpeaking: false,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
        ];
        break;

      case 'pipi':
        nodes = [
          VNDialogueNode(
            speakerName: 'Narasi',
            dialogueText: '($maleName membelai lembut pipi $femaleName, kemudian memberikan kecupan hangat penuh kasih sayang di kedua pipinya...) 😊',
            emotion: VNEmotionType.happy,
            isPlayerSpeaking: false,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
          VNDialogueNode(
            speakerName: maleName,
            dialogueText: 'Kamu selalu terlihat manis dan menggemaskan setiap kali tersenyum seperti ini, $callFromMale. 💕',
            emotion: VNEmotionType.happy,
            isPlayerSpeaking: isPlayerMale,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
          VNDialogueNode(
            speakerName: femaleName,
            dialogueText: 'Ih kamu ini... selalu saja bisa membuat pipiku merona merah. Terima kasih ya $callFromFemale... ☺️',
            emotion: VNEmotionType.blush,
            isPlayerSpeaking: !isPlayerMale,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
          VNDialogueNode(
            speakerName: 'Narasi',
            dialogueText: '(Kehangatan ciuman pipi mempererat rasa saling mencintai dan rasa nyaman di antara mereka...) 🌸',
            emotion: VNEmotionType.happy,
            isPlayerSpeaking: false,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
        ];
        break;

      case 'jidat':
        nodes = [
          VNDialogueNode(
            speakerName: 'Narasi',
            dialogueText: '($maleName memegang kedua pundak $femaleName, lalu dengan penuh ketulusan mengecup kening/jidatnya hangat...) 👑',
            emotion: VNEmotionType.happy,
            isPlayerSpeaking: false,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
          VNDialogueNode(
            speakerName: maleName,
            dialogueText: 'Aku akan selalu ada untuk melindungi dan menyayangimu dengan sepenuh hatiku, $callFromMale. 🤍',
            emotion: VNEmotionType.happy,
            isPlayerSpeaking: isPlayerMale,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
          VNDialogueNode(
            speakerName: femaleName,
            dialogueText: 'Ciuman kening darimu selalu membuatku merasa sangat aman dan dihargai, $callFromFemale... 🥰',
            emotion: VNEmotionType.happy,
            isPlayerSpeaking: !isPlayerMale,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
          VNDialogueNode(
            speakerName: 'Narasi',
            dialogueText: '(Ciuman kening yang tulus ini menghangatkan jiwa dan menguatkan ikatan emosional pasangan...) ✨',
            emotion: VNEmotionType.happy,
            isPlayerSpeaking: false,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
        ];
        break;

      case 'tangan':
        nodes = [
          VNDialogueNode(
            speakerName: 'Narasi',
            dialogueText: '($maleName mengambil jemari $femaleName, meletakkannya di dadanya, lalu mengecup lembut punggung tangannya dengan mesra...) 🤝',
            emotion: VNEmotionType.blush,
            isPlayerSpeaking: false,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
          VNDialogueNode(
            speakerName: maleName,
            dialogueText: 'Kehadiranmu adalah hal paling berharga dalam hidupku, $callFromMale. 💍',
            emotion: VNEmotionType.happy,
            isPlayerSpeaking: isPlayerMale,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
          VNDialogueNode(
            speakerName: femaleName,
            dialogueText: 'Sikap manismu yang seperti ini membuatku semakin jatuh cinta padamu setiap hari, $callFromFemale... 💖',
            emotion: VNEmotionType.blush,
            isPlayerSpeaking: !isPlayerMale,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
          VNDialogueNode(
            speakerName: 'Narasi',
            dialogueText: '(Sentuhan dan kecupan di tangan menghadirkan suasana romantis nan elegan...) 🌹',
            emotion: VNEmotionType.happy,
            isPlayerSpeaking: false,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
        ];
        break;

      case 'telinga':
      default:
        nodes = [
          VNDialogueNode(
            speakerName: 'Narasi',
            dialogueText: '($maleName berbisik mesra di dekat telinga $femaleName, kemudian mengecup lembut daun telinganya hingga desahannya terasa hangat...) 👂',
            emotion: VNEmotionType.blush,
            isPlayerSpeaking: false,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
          VNDialogueNode(
            speakerName: maleName,
            dialogueText: 'Dengar baik-baik, $callFromMale... aku merindukanmu setiap detik... 💋',
            emotion: VNEmotionType.happy,
            isPlayerSpeaking: isPlayerMale,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
          VNDialogueNode(
            speakerName: femaleName,
            dialogueText: 'Hiyaaah... bisikan dan kecupan di telinga itu membuat seluruh badanku merinding geli, $callFromFemale... 🙈',
            emotion: VNEmotionType.blush,
            isPlayerSpeaking: !isPlayerMale,
            outfit: VNOutfitType.casual,
            background: VNBackgroundType.bedroom,
          ),
          VNDialogueNode(
            speakerName: 'Narasi',
            dialogueText: '(Bisikan hangat di telinga membuat bulu kuduk berdiri dan menyalakan gairah yang begitu membara...) 🔥',
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

  /// Menjalankan dialog VN Overlay ciuman dan efek hubungan.
  static void _startCiumanVNSequence({
    required BuildContext context,
    required Character character,
    required String targetName,
    required String targetGender,
    required String partId,
    required String partLabel,
    required VoidCallback onActionComplete,
  }) {
    final List<VNDialogueNode> dialogueNodes = generateCiumDialogueNodes(
      character: character,
      targetName: targetName,
      targetGender: targetGender,
      partId: partId,
      partLabel: partLabel,
    );

    final Map<String, dynamic> npcMap = {
      'name': targetName,
      'gender': targetGender,
    };

    VNDialogueOverlay.show(
      context: context,
      player: character,
      npc: npcMap,
      nodes: dialogueNodes,
      onFinished: () {
        // Efek menambah hubungan & kebahagiaan
        final Random random = Random();
        final int relBonus = random.nextInt(4) + 5; // +5 s/d +8 hubungan
        final int happyBonus = random.nextInt(3) + 3; // +3 s/d +5 kebahagiaan

        character.happiness = (character.happiness + happyBonus).clamp(0, 100);

        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.favorite, color: Color(0xFFE91E63)),
                SizedBox(width: 8),
                Text('Momen Romantis 💋', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            content: Text(
              'Ciuman di bagian $partLabel berjalan sangat romantis!\n\n'
              '• Hubungan dengan $targetName +$relBonus%\n'
              '• Kebahagiaan +$happyBonus%',
              style: const TextStyle(fontSize: 14),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  onActionComplete();
                },
                child: const Text('OK', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );
      },
    );
  }
}
