// lib/game/widgets/vn_dialogue/vn_dialogue_overlay.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/avatar/vn_character_view.dart';
import 'package:mylifesim/game/widgets/vn_dialogue/vn_dialogue_models.dart';

import 'package:mylifesim/avatar/avatar_age_rules.dart';

class VNDialogueOverlay extends StatefulWidget {
  final Character player;
  final Map<String, dynamic> npc;
  final List<VNDialogueNode> nodes;
  final VoidCallback? onFinished;
  final String? playerAvatarUrl;
  final String? npcAvatarUrl;

  const VNDialogueOverlay({
    super.key,
    required this.player,
    required this.npc,
    required this.nodes,
    this.onFinished,
    this.playerAvatarUrl,
    this.npcAvatarUrl,
  });

  static Future<void> show({
    required BuildContext context,
    required Character player,
    required Map<String, dynamic> npc,
    required List<VNDialogueNode> nodes,
    VoidCallback? onFinished,
    String? playerAvatarUrl,
    String? npcAvatarUrl,
  }) {
    return showGeneralDialog(
      context: context,
      useRootNavigator: true,
      barrierDismissible: false,
      barrierColor: Colors.black87,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return VNDialogueOverlay(
          player: player,
          npc: npc,
          nodes: nodes,
          onFinished: onFinished,
          playerAvatarUrl: playerAvatarUrl,
          npcAvatarUrl: npcAvatarUrl ?? npc['avatarUrl']?.toString(),
        );
      },
    );
  }

  @override
  State<VNDialogueOverlay> createState() => _VNDialogueOverlayState();
}

class _VNDialogueOverlayState extends State<VNDialogueOverlay> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  bool _isAuto = false;
  Timer? _autoTimer;
  final List<VNLogItem> _historyLog = [];

  // Typewriter effect variables
  String _displayedText = '';
  Timer? _typewriterTimer;
  bool _isTyping = false;

  // Pulse animation controller for skip text
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _loadNode(_currentIndex);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _autoTimer?.cancel();
    _typewriterTimer?.cancel();
    super.dispose();
  }

  void _loadNode(int index) {
    if (index >= widget.nodes.length) {
      _finishDialogue();
      return;
    }

    final currentNode = widget.nodes[index];

    // Catat ke Log History
    _historyLog.add(VNLogItem(
      speakerName: currentNode.speakerName,
      text: currentNode.dialogueText,
    ));

    setState(() {
      _currentIndex = index;
      _displayedText = '';
      _isTyping = true;
    });

    _startTypewriter(currentNode.dialogueText);
  }

  void _startTypewriter(String fullText) {
    _typewriterTimer?.cancel();
    int charIndex = 0;

    _typewriterTimer = Timer.periodic(const Duration(milliseconds: 25), (timer) {
      if (charIndex < fullText.length) {
        if (mounted) {
          setState(() {
            _displayedText += fullText[charIndex];
          });
        }
        charIndex++;
      } else {
        timer.cancel();
        if (mounted) {
          setState(() {
            _isTyping = false;
          });
          if (_isAuto) {
            _scheduleAutoNext();
          }
        }
      }
    });
  }

  void _completeTypewriterImmediately() {
    _typewriterTimer?.cancel();
    final currentNode = widget.nodes[_currentIndex];
    setState(() {
      _displayedText = currentNode.dialogueText;
      _isTyping = false;
    });
  }

  void _nextDialogue() {
    if (_isTyping) {
      _completeTypewriterImmediately();
      return;
    }

    final currentNode = widget.nodes[_currentIndex];

    // Jika sedang ada pilihan jawaban, tidak bisa next otomatis dengan tap
    if (currentNode.choices != null && currentNode.choices!.isNotEmpty) {
      return;
    }

    if (currentNode.nextIndex != null) {
      _loadNode(currentNode.nextIndex!);
    } else if (_currentIndex + 1 < widget.nodes.length) {
      _loadNode(_currentIndex + 1);
    } else {
      _finishDialogue();
    }
  }

  void _scheduleAutoNext() {
    _autoTimer?.cancel();
    _autoTimer = Timer(const Duration(milliseconds: 2200), () {
      if (mounted && _isAuto && !_isTyping) {
        _nextDialogue();
      }
    });
  }

  void _finishDialogue() {
    _autoTimer?.cancel();
    _typewriterTimer?.cancel();
    // Panggil onFinished SETELAH pop agar tidak ada masalah state/context
    final onFinished = widget.onFinished;
    if (mounted) {
      Navigator.of(context, rootNavigator: true).pop();
    }
    if (onFinished != null) {
      onFinished();
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentNode = widget.nodes[_currentIndex];
    final bool hasChoices = currentNode.choices != null && currentNode.choices!.isNotEmpty;

    return Material(
      color: Colors.black,
      child: Stack(
        children: [
          // 1. Dynamic Background Layer
          _buildBackground(currentNode.background),

          // 2. Fullscreen Tap Handler for Dialogue Progression (only active when no choices)
          if (!hasChoices)
            Positioned.fill(
              child: GestureDetector(
                onTap: _nextDialogue,
                behavior: HitTestBehavior.opaque,
                child: const SizedBox.expand(),
              ),
            ),

          // 3. Character Standees (User & NPC Side by Side)
          Positioned.fill(
            child: IgnorePointer(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 140.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Player Standee (Left)
                      VNCharacterView(
                        character: widget.player,
                        isActiveSpeaker: currentNode.isPlayerSpeaking,
                        customName: widget.player.name,
                        emotion: currentNode.isPlayerSpeaking ? currentNode.emotion : VNEmotionType.neutral,
                        outfit: currentNode.outfit,
                        customAvatarUrl: widget.playerAvatarUrl ?? AvatarAgeRules.getAgeBasedAvatarUrl(widget.player, happiness: widget.player.happiness),
                        width: 170,
                        height: 310,
                      ),

                      // NPC Standee (Right)
                      VNCharacterView(
                        character: _createDummyNPCCharacter(widget.npc),
                        isActiveSpeaker: !currentNode.isPlayerSpeaking,
                        customName: widget.npc['name'] ?? 'NPC',
                        emotion: !currentNode.isPlayerSpeaking ? currentNode.emotion : VNEmotionType.neutral,
                        outfit: currentNode.outfit,
                        customAvatarUrl: widget.npcAvatarUrl ?? widget.npc['avatarUrl']?.toString(),
                        width: 170,
                        height: 310,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // 5. Choice Decision Card Overlay (Jika ada Pilihan Jawaban)
          if (hasChoices)
            Positioned(
              top: 100,
              left: 20,
              right: 20,
              child: _buildChoiceCard(currentNode.choices!),
            ),

          // 6. Dialogue Box Bottom Component (Clickable to advance/finish dialogue)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: IgnorePointer(
              ignoring: hasChoices,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: GestureDetector(
                    onTap: _nextDialogue,
                    behavior: HitTestBehavior.opaque,
                    child: _buildDialogueBox(currentNode),
                  ),
                ),
              ),
            ),
          ),

          // 4. Top Control Bar (Location, Pulsing Skip Hint, History Log, Auto, Skip, Close)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: Text(
                        _getBackgroundTitle(currentNode.background),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Tulisan berkedip / berdenyut lambat "Ketuk layar untuk skip percakapan"
                    Expanded(
                      child: FadeTransition(
                        opacity: _pulseAnimation,
                        child: Text(
                          'Ketuk layar untuk skip percakapan...',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.amber.shade300,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.italic,
                            shadows: const [
                              Shadow(color: Colors.black, blurRadius: 4),
                            ],
                          ),
                        ),
                      ),
                    ),
                    _buildControlButton(
                      icon: Icons.history,
                      label: 'Log',
                      onTap: _showHistorySheet,
                    ),
                    const SizedBox(width: 8),
                    _buildControlButton(
                      icon: Icons.play_arrow,
                      label: _isAuto ? 'Auto ON' : 'Auto',
                      isActive: _isAuto,
                      onTap: () {
                        setState(() {
                          _isAuto = !_isAuto;
                        });
                        if (_isAuto && !_isTyping) {
                          _scheduleAutoNext();
                        }
                      },
                    ),
                    const SizedBox(width: 8),
                    _buildControlButton(
                      icon: Icons.fast_forward,
                      label: 'Skip',
                      onTap: _finishDialogue,
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white70),
                      onPressed: _finishDialogue,
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.black54,
                        padding: const EdgeInsets.all(8),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground(VNBackgroundType type) {
    List<Color> colors;
    IconData bgIcon;

    switch (type) {
      case VNBackgroundType.classroom:
        colors = [Colors.brown.shade900, Colors.amber.shade900];
        bgIcon = Icons.school;
        break;
      case VNBackgroundType.nightCity:
      case VNBackgroundType.snowStreet:
        colors = [const Color(0xFF0F172A), Colors.blueGrey.shade900];
        bgIcon = Icons.ac_unit;
        break;
      case VNBackgroundType.park:
        colors = [Colors.teal.shade900, Colors.green.shade900];
        bgIcon = Icons.park;
        break;
      case VNBackgroundType.office:
        colors = [Colors.blueGrey.shade900, Colors.grey.shade900];
        bgIcon = Icons.apartment;
        break;
      case VNBackgroundType.bedroom:
        colors = [Colors.deepPurple.shade900, const Color(0xFF4A0E17)];
        bgIcon = Icons.bed;
        break;
      case VNBackgroundType.restaurant:
      case VNBackgroundType.cafe:
        colors = [const Color(0xFF2C1810), Colors.brown.shade900];
        bgIcon = Icons.coffee;
        break;
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: colors,
        ),
      ),
      child: Center(
        child: Icon(
          bgIcon,
          size: 260,
          color: Colors.white.withValues(alpha: 0.05),
        ),
      ),
    );
  }

  String _getBackgroundTitle(VNBackgroundType type) {
    switch (type) {
      case VNBackgroundType.classroom:
        return '📍 Ruang Kelas';
      case VNBackgroundType.snowStreet:
        return '📍 Musim Salju';
      case VNBackgroundType.nightCity:
        return '📍 Jalanan Kota (Malam)';
      case VNBackgroundType.park:
        return '📍 Taman Kota';
      case VNBackgroundType.office:
        return '📍 Ruang Kantor';
      case VNBackgroundType.bedroom:
        return '📍 Kamar Tidur';
      case VNBackgroundType.restaurant:
        return '📍 Restoran Mewah';
      case VNBackgroundType.cafe:
        return '📍 Kafe Romantis';
    }
  }

  SpeakerType _getSpeakerType(VNDialogueNode node) {
    final nameLower = node.speakerName.trim().toLowerCase();
    if (nameLower == 'narasi' || nameLower == 'narrator' || nameLower == 'sistem' || nameLower == 'system') {
      return SpeakerType.narrator;
    }

    String speakerGender = '';
    if (node.isPlayerSpeaking) {
      speakerGender = widget.player.gender;
    } else {
      speakerGender = widget.npc['gender']?.toString() ?? '';
    }

    speakerGender = speakerGender.toLowerCase();
    if (speakerGender.contains('laki') || speakerGender == 'male' || speakerGender == 'pria') {
      return SpeakerType.male;
    } else if (speakerGender.contains('perempuan') || speakerGender.contains('wanita') || speakerGender == 'female') {
      return SpeakerType.female;
    }

    return node.isPlayerSpeaking ? SpeakerType.male : SpeakerType.female;
  }

  SpeakerStyle _getSpeakerStyle(SpeakerType type) {
    switch (type) {
      case SpeakerType.narrator:
        return SpeakerStyle(
          badgeBgColor: const Color(0xFFB45309), // Warm Amber/Gold
          badgeBorderColor: const Color(0xFFFBBF24), // Bright Gold Accent
          textColor: Colors.white,
          boxBorderColor: const Color(0xFFFBBF24).withValues(alpha: 0.7),
          icon: Icons.auto_stories,
        );
      case SpeakerType.male:
        return SpeakerStyle(
          badgeBgColor: const Color(0xFF1D4ED8), // Royal Blue
          badgeBorderColor: const Color(0xFF38BDF8), // Cyan Accent
          textColor: Colors.white,
          boxBorderColor: const Color(0xFF38BDF8).withValues(alpha: 0.7),
          icon: Icons.male,
        );
      case SpeakerType.female:
        return SpeakerStyle(
          badgeBgColor: const Color(0xFFBE185D), // Deep Rose/Pink
          badgeBorderColor: const Color(0xFFF472B6), // Rose Accent
          textColor: Colors.white,
          boxBorderColor: const Color(0xFFF472B6).withValues(alpha: 0.7),
          icon: Icons.female,
        );
    }
  }

  Widget _buildDialogueBox(VNDialogueNode node) {
    final speakerType = _getSpeakerType(node);
    final style = _getSpeakerStyle(speakerType);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: style.boxBorderColor,
          width: 1.8,
        ),
        boxShadow: [
          BoxShadow(
            color: style.badgeBorderColor.withValues(alpha: 0.25),
            blurRadius: 12,
            spreadRadius: 1,
          ),
          const BoxShadow(
            color: Colors.black54,
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Speaker Name Tag Banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: style.badgeBgColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: style.badgeBorderColor,
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: style.badgeBorderColor.withValues(alpha: 0.4),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  style.icon,
                  size: 14,
                  color: style.textColor,
                ),
                const SizedBox(width: 6),
                Text(
                  node.speakerName,
                  style: TextStyle(
                    color: style.textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    letterSpacing: 0.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          // Typewriter Dialogue Text
          Text(
            _displayedText,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              height: 1.4,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 8),
          // Tap hint icon on dialogue box
          Align(
            alignment: Alignment.bottomRight,
            child: Icon(
              (_currentIndex >= widget.nodes.length - 1)
                  ? Icons.check_circle
                  : Icons.arrow_drop_down_circle,
              color: style.badgeBorderColor,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChoiceCard(List<VNChoiceOption> choices) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade900.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.amber, width: 2),
        boxShadow: const [
          BoxShadow(
            color: Colors.black87,
            blurRadius: 15,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Pilih Pilihan Jawabanmu:',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.amber,
              fontSize: 13,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          ...choices.map((c) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: GestureDetector(
                  onTap: () {
                    if (c.onSelect != null) {
                      c.onSelect!(widget.player, widget.npc);
                    }
                    if (c.nextNodeIndex != null) {
                      _loadNode(c.nextNodeIndex!);
                    } else {
                      _finishDialogue();
                    }
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.indigo.shade800,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.amber.withValues(alpha: 0.8), width: 1.5),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black45,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      c.text,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isActive = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? Colors.amber.shade800 : Colors.black54,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isActive ? Colors.amber : Colors.white24),
        ),
        child: Row(
          children: [
            Icon(icon, size: 14, color: Colors.white),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  void _showHistorySheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey.shade900,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Riwayat Percakapan (Log History)',
                style: TextStyle(
                  color: Colors.amber,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const Divider(color: Colors.white24, height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: _historyLog.length,
                  itemBuilder: (context, idx) {
                    final item = _historyLog[idx];
                    final dummyNode = VNDialogueNode(
                      speakerName: item.speakerName,
                      dialogueText: item.text,
                      isPlayerSpeaking: item.speakerName.trim().toLowerCase() == widget.player.name.trim().toLowerCase(),
                    );
                    final speakerType = _getSpeakerType(dummyNode);
                    final style = _getSpeakerStyle(speakerType);

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: style.badgeBgColor,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: style.badgeBorderColor, width: 1),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(style.icon, size: 12, color: style.textColor),
                                const SizedBox(width: 4),
                                Text(
                                  item.speakerName,
                                  style: TextStyle(
                                    color: style.textColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: Text(
                              item.text,
                              style: const TextStyle(color: Colors.white70, fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Character _createDummyNPCCharacter(Map<String, dynamic> npcMap) {
    final String rawName = npcMap['name'] ?? 'NPC';
    final String cleanName = npcMap['plainName'] ?? AvatarAgeRules.getCleanNPCName(rawName);
    final int age = int.tryParse(npcMap['age']?.toString().replaceAll(RegExp(r'[^0-9]'), '') ?? '25') ?? 25;
    return Character(
      name: cleanName,
      gender: npcMap['gender'] ?? 'Perempuan',
      location: 'Indonesia',
      age: age > 0 ? age : 25,
      avatarSkinColor: npcMap['skinColor']?.toString(),
      health: 80,
      happiness: int.tryParse(npcMap['relationship']?.toString() ?? '50') ?? 50,
      intelligence: 80,
      money: 1000,
      appearance: 80,
      isAlive: true,
      discipline: 50,
      fertility: 50,
      karma: 50,
      sexuality: 'Heteroseksual',
      willpower: 50,
      specialTalent: '',
    );
  }
}

enum SpeakerType { narrator, male, female }

class SpeakerStyle {
  final Color badgeBgColor;
  final Color badgeBorderColor;
  final Color textColor;
  final Color boxBorderColor;
  final IconData icon;

  const SpeakerStyle({
    required this.badgeBgColor,
    required this.badgeBorderColor,
    required this.textColor,
    required this.boxBorderColor,
    required this.icon,
  });
}