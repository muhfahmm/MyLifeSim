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
  final String? customLocation;

  const VNDialogueOverlay({
    super.key,
    required this.player,
    required this.npc,
    required this.nodes,
    this.onFinished,
    this.playerAvatarUrl,
    this.npcAvatarUrl,
    this.customLocation,
  });

  static Future<void> show({
    required BuildContext context,
    required Character player,
    required Map<String, dynamic> npc,
    required List<VNDialogueNode> nodes,
    VoidCallback? onFinished,
    String? playerAvatarUrl,
    String? npcAvatarUrl,
    String? customLocation,
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
          customLocation: customLocation,
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
    // -1 is a sentinel value meaning "finish the dialogue"
    if (index == -1 || index >= widget.nodes.length) {
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

    // Hanya blokir jika ada PILIHAN BIASA (choices), bukan persistent dropdown
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
    final bool hasPersistentActions = 
        (currentNode.persistentCiumChoices != null && currentNode.persistentCiumChoices!.isNotEmpty) ||
        (currentNode.persistentPenetrasiChoices != null && currentNode.persistentPenetrasiChoices!.isNotEmpty) ||
        (currentNode.persistentPosisiChoices != null && currentNode.persistentPosisiChoices!.isNotEmpty) ||
        (currentNode.persistentOralChoices != null && currentNode.persistentOralChoices!.isNotEmpty) ||
        (currentNode.persistentEjakulasiChoices != null && currentNode.persistentEjakulasiChoices!.isNotEmpty);

    final SpeakerType speakerType = _getSpeakerType(currentNode);
    final bool isNarratorNode = speakerType == SpeakerType.narrator;

    return Material(
      color: Colors.black,
      child: Stack(
        children: [
          // 1. Dynamic Background Layer
          _buildBackground(currentNode.background),

          // 2. Fullscreen Tap Handler (aktif HANYA jika tidak ada choices biasa yang memblokir)
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
                        isActiveSpeaker: isNarratorNode ? false : currentNode.isPlayerSpeaking,
                        customName: widget.player.name,
                        emotion: (currentNode.isPlayerSpeaking && !isNarratorNode) ? currentNode.emotion : VNEmotionType.neutral,
                        outfit: currentNode.outfit,
                        customAvatarUrl: widget.playerAvatarUrl ?? AvatarAgeRules.getAgeBasedAvatarUrl(widget.player, happiness: widget.player.happiness),
                        width: 170,
                        height: 310,
                      ),

                      // NPC Standee (Right)
                      VNCharacterView(
                        character: _createDummyNPCCharacter(widget.npc),
                        isActiveSpeaker: isNarratorNode ? false : !currentNode.isPlayerSpeaking,
                        customName: widget.npc['name'] ?? 'NPC',
                        emotion: (!currentNode.isPlayerSpeaking && !isNarratorNode) ? currentNode.emotion : VNEmotionType.neutral,
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

          // 5. Panel Dropdown Aksi Persisten (Ciuman & Penetrasi) - TIDAK memblokir Selanjutnya
          if (hasPersistentActions)
            Positioned(
              top: 100,
              left: 20,
              right: 20,
              child: _buildPersistentActionPanel(currentNode),
            ),

          // 5b. Choice Decision Card biasa (jika ada choices yang memblokir)
          if (hasChoices)
            Positioned(
              top: 100,
              left: 20,
              right: 20,
              child: _buildChoiceCard(currentNode),
            ),

          // 6. Dialogue Box Bottom Component (Clickable to advance/finish dialogue)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
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
                        _getFormattedLocation(currentNode.background),
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
                      icon: Icons.check_circle_outline,
                      label: 'Selesai',
                      isActive: true,
                      onTap: _finishDialogue,
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

  String _getFormattedLocation(VNBackgroundType background) {
    if (widget.customLocation != null && widget.customLocation!.isNotEmpty) {
      String loc = widget.customLocation!.trim();
      if (loc.startsWith('📍')) {
        return loc;
      }
      if (loc.contains('Ruangan:')) {
        final roomPart = loc.split('Ruangan:').last.replaceAll(')', '').trim();
        if (loc.contains('Pemilik:')) {
          final ownerPart = loc.split('Pemilik:').last.split('|').first.trim();
          return '📍 $roomPart (Rumah $ownerPart)';
        }
        return '📍 $roomPart';
      }
      return '📍 $loc';
    }
    return _getBackgroundTitle(background);
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
          // Speaker Name Tag Banner & Tombol Selanjutnya
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
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
              // Tombol Selanjutnya di samping Badge Narasi
              InkWell(
                onTap: _nextDialogue,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade800,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.amber, width: 1.2),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black45,
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Selanjutnya',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_forward_ios, size: 12, color: Colors.white),
                    ],
                  ),
                ),
              ),
            ],
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

  /// Panel Dropdown PERSISTEN: Ciuman & Penetrasi
  /// Panel ini selalu tampil tapi TIDAK memblokir tombol Selanjutnya.
  Widget _buildPersistentActionPanel(VNDialogueNode node) {
    final ciumChoices = node.persistentCiumChoices ?? [];
    final penetrasiChoices = node.persistentPenetrasiChoices ?? [];
    final posisiChoices = node.persistentPosisiChoices ?? [];
    final oralChoices = node.persistentOralChoices ?? [];
    final ejakulasiChoices = node.persistentEjakulasiChoices ?? [];
    String? selectedCiumText;
    String? selectedPenetrasiText;
    String? selectedPosisiText;
    String? selectedOralText;
    String? selectedEjakulasiText;

    return StatefulBuilder(
      builder: (context, setStatePanel) {
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E2E).withValues(alpha: 0.93),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.purpleAccent.withValues(alpha: 0.6), width: 1.5),
            boxShadow: const [
              BoxShadow(color: Colors.black87, blurRadius: 14, spreadRadius: 1),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.touch_app, color: Colors.purpleAccent, size: 16),
                  SizedBox(width: 6),
                  Text(
                    'Aksi Intim, Posisi & Ejakulasi:',
                    style: TextStyle(
                      color: Colors.purpleAccent,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // --- Dropdown Ciuman ---
              if (ciumChoices.isNotEmpty) ...[
                const Text(
                  '💋 Ciuman:',
                  style: TextStyle(color: Colors.pinkAccent, fontSize: 11, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade900,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.pinkAccent.withValues(alpha: 0.7), width: 1),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedCiumText,
                      hint: const Text(
                        '-- Pilih bagian untuk dicium --',
                        style: TextStyle(color: Colors.white60, fontSize: 11),
                      ),
                      dropdownColor: const Color(0xFF181825),
                      isExpanded: true,
                      icon: const Icon(Icons.arrow_drop_down, color: Colors.pinkAccent),
                      items: ciumChoices.map((c) {
                        return DropdownMenuItem<String>(
                          value: c.text,
                          child: Text(
                            c.text,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val == null) return;
                        setStatePanel(() { selectedCiumText = val; });
                        final chosen = ciumChoices.firstWhere((e) => e.text == val);
                        if (chosen.onSelect != null) {
                          chosen.onSelect!(widget.player, widget.npc);
                        }
                        if (chosen.nextNodeIndex != null) {
                          _loadNode(chosen.nextNodeIndex!);
                        }
                      },
                    ),
                  ),
                ),
              ],

              // --- Dropdown Oral Seks ---
              if (oralChoices.isNotEmpty) ...[
                const SizedBox(height: 10),
                const Text(
                  '👅 Oral Seks:',
                  style: TextStyle(color: Colors.purpleAccent, fontSize: 11, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.purple.shade900.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.purpleAccent.withValues(alpha: 0.7), width: 1),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedOralText,
                      hint: const Text(
                        '-- Pilih Aksi Oral Seks 👅 --',
                        style: TextStyle(color: Colors.white60, fontSize: 11),
                      ),
                      dropdownColor: const Color(0xFF181825),
                      isExpanded: true,
                      icon: const Icon(Icons.arrow_drop_down, color: Colors.purpleAccent),
                      items: oralChoices.map((c) {
                        return DropdownMenuItem<String>(
                          value: c.text,
                          child: Text(
                            c.text,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val == null) return;
                        setStatePanel(() { selectedOralText = val; });
                        final chosen = oralChoices.firstWhere((e) => e.text == val);
                        if (chosen.onSelect != null) {
                          chosen.onSelect!(widget.player, widget.npc);
                        }
                        if (chosen.nextNodeIndex != null) {
                          _loadNode(chosen.nextNodeIndex!);
                        }
                      },
                    ),
                  ),
                ),
              ],

              // --- Dropdown Penetrasi ---
              if (penetrasiChoices.isNotEmpty) ...[
                const SizedBox(height: 10),
                const Text(
                  '🔥 Penetrasi:',
                  style: TextStyle(color: Colors.orangeAccent, fontSize: 11, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.deepOrange.shade900.withValues(alpha: 0.75),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.orangeAccent.withValues(alpha: 0.7), width: 1),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedPenetrasiText,
                      hint: const Text(
                        '-- Pilih jalur penetrasi --',
                        style: TextStyle(color: Colors.white60, fontSize: 11),
                      ),
                      dropdownColor: const Color(0xFF181825),
                      isExpanded: true,
                      icon: const Icon(Icons.arrow_drop_down, color: Colors.orangeAccent),
                      items: penetrasiChoices.map((c) {
                        return DropdownMenuItem<String>(
                          value: c.text,
                          child: Text(
                            c.text,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val == null) return;
                        setStatePanel(() { selectedPenetrasiText = val; });
                        final chosen = penetrasiChoices.firstWhere((e) => e.text == val);
                        if (chosen.onSelect != null) {
                          chosen.onSelect!(widget.player, widget.npc);
                        }
                        if (chosen.nextNodeIndex != null) {
                          _loadNode(chosen.nextNodeIndex!);
                        }
                      },
                    ),
                  ),
                ),
              ],

              // --- Dropdown Posisi Seks (Khusus User Laki-laki) ---
              if (posisiChoices.isNotEmpty) ...[
                const SizedBox(height: 10),
                const Text(
                  '🛌 Posisi Seks:',
                  style: TextStyle(color: Colors.tealAccent, fontSize: 11, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.teal.shade900.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.tealAccent.withValues(alpha: 0.7), width: 1),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedPosisiText,
                      hint: const Text(
                        '-- Pilih Posisi Seks 🛌 --',
                        style: TextStyle(color: Colors.white60, fontSize: 11),
                      ),
                      dropdownColor: const Color(0xFF181825),
                      isExpanded: true,
                      icon: const Icon(Icons.arrow_drop_down, color: Colors.tealAccent),
                      items: posisiChoices.map((c) {
                        return DropdownMenuItem<String>(
                          value: c.text,
                          child: Text(
                            c.text,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val == null) return;
                        setStatePanel(() { selectedPosisiText = val; });
                        final chosen = posisiChoices.firstWhere((e) => e.text == val);
                        if (chosen.onSelect != null) {
                          chosen.onSelect!(widget.player, widget.npc);
                        }
                        if (chosen.nextNodeIndex != null) {
                          _loadNode(chosen.nextNodeIndex!);
                        }
                      },
                    ),
                  ),
                ),
              ],

              // --- Dropdown Ejakulasi / Klimaks (Khusus User Laki-laki) ---
              if (ejakulasiChoices.isNotEmpty) ...[
                const SizedBox(height: 10),
                const Text(
                  '💦 Lokasi Ejakulasi / Klimaks:',
                  style: TextStyle(color: Colors.lightBlueAccent, fontSize: 11, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.lightBlue.shade900.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.lightBlueAccent.withValues(alpha: 0.7), width: 1),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedEjakulasiText,
                      hint: const Text(
                        '-- Pilih Lokasi Pengeluaran Ejakulasi 💦 --',
                        style: TextStyle(color: Colors.white60, fontSize: 11),
                      ),
                      dropdownColor: const Color(0xFF181825),
                      isExpanded: true,
                      icon: const Icon(Icons.arrow_drop_down, color: Colors.lightBlueAccent),
                      items: ejakulasiChoices.map((c) {
                        return DropdownMenuItem<String>(
                          value: c.text,
                          child: Text(
                            c.text,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val == null) return;
                        setStatePanel(() { selectedEjakulasiText = val; });
                        final chosen = ejakulasiChoices.firstWhere((e) => e.text == val);
                        if (chosen.onSelect != null) {
                          chosen.onSelect!(widget.player, widget.npc);
                        }
                        if (chosen.nextNodeIndex != null) {
                          _loadNode(chosen.nextNodeIndex!);
                        }
                      },
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildChoiceCard(VNDialogueNode node) {
    final choices = node.choices ?? [];

    // Menentukan judul card pilihan secara dinamis
    final bool isIntimateAction = choices.any((c) {
      final t = c.text.toLowerCase();
      return t.contains('ciuman') ||
          t.contains('oral') ||
          t.contains('penetrasi') ||
          t.contains('posisi') ||
          t.contains('ejakulasi') ||
          t.contains('stimulasi');
    });

    final String cardTitle = isIntimateAction
        ? 'Pilih Aksi / Tindakan Intim:'
        : 'Pilih Tanggapan / Keputusan:';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2E).withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.amber, width: 2),
        boxShadow: const [
          BoxShadow(
            color: Colors.black87,
            blurRadius: 16,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.touch_app, color: Colors.amber, size: 20),
              const SizedBox(width: 8),
              Text(
                cardTitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.amber,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...choices.map((c) {
            String displayText = c.text;
            if (displayText.contains('4. Posisi Seks') || displayText.contains('4. Pilih Posisi Seks')) {
              final activePos = widget.player.currentPosisiSeks;
              if (activePos != null && activePos.isNotEmpty) {
                displayText = '4. Pilih Posisi Seks [$activePos] 🔄 (Ganti Posisi)';
              }
            }

            final bool isGantiPosisi = displayText.contains('(Ganti Posisi)');
            final String? activePos = widget.player.currentPosisiSeks?.toLowerCase();
            bool isDisabledByPosisi = false;
            String disabledReason = '';

            if (activePos != null && activePos.isNotEmpty) {
              final bool isCiuman = c.text.contains('1. Ciuman');
              final bool isOral = c.text.contains('2. Oral Seks');
              final bool isAskStimulasi = c.text.contains('5.');
              final bool isDoStimulasi = c.text.contains('6.');
              final bool isPayudara = c.text.contains('7.') && c.text.contains('payudara');

              // 1. Doggy Style (Dari Belakang)
              if (activePos.contains('doggy') || activePos.contains('belakang')) {
                if (isCiuman) {
                  isDisabledByPosisi = true;
                  disabledReason = ' 🚫 (Tidak dapat diakses: Posisi membelakangi)';
                } else if (isOral) {
                  isDisabledByPosisi = true;
                  disabledReason = ' 🚫 (Tidak dapat diakses: Wajah pasangan di belakang)';
                } else if (isDoStimulasi) {
                  isDisabledByPosisi = true;
                  disabledReason = ' 🚫 (Tidak dapat diakses: Tidak terjangkau dari posisi Doggy)';
                }
              }
              // 2. Face Sitting (Duduk di Wajah)
              else if (activePos.contains('face sitting') || activePos.contains('duduk di wajah') || activePos.contains('wajah')) {
                if (isCiuman) {
                  isDisabledByPosisi = true;
                  disabledReason = ' 🚫 (Tidak dapat diakses: Wajah sedang diduduki)';
                } else if (isPayudara) {
                  isDisabledByPosisi = true;
                  disabledReason = ' 🚫 (Tidak dapat diakses: Dada tidak terjangkau)';
                }
              }
              // 3. Posisi 69 (Oral Saling Berhadapan / Bersamaan)
              else if (activePos.contains('69')) {
                if (isCiuman) {
                  isDisabledByPosisi = true;
                  disabledReason = ' 🚫 (Tidak dapat diakses: Posisi kepala berbalik arah)';
                } else if (isPayudara) {
                  isDisabledByPosisi = true;
                  disabledReason = ' 🚫 (Tidak dapat diakses: Kepala berada di area kemaluan)';
                }
              }
              // 4. Scissoring (Gunting - Lesbian)
              else if (activePos.contains('scissoring') || activePos.contains('gunting')) {
                if (isCiuman) {
                  isDisabledByPosisi = true;
                  disabledReason = ' 🚫 (Tidak dapat diakses: Kaki saling mengunci)';
                } else if (isOral) {
                  isDisabledByPosisi = true;
                  disabledReason = ' 🚫 (Tidak dapat diakses: Area intim sedang bergesekan)';
                }
              }
              // 5. Tribadism / Saling Menindih
              else if (activePos.contains('tribadism') || activePos.contains('menindih')) {
                if (isOral) {
                  isDisabledByPosisi = true;
                  disabledReason = ' 🚫 (Tidak dapat diakses: Panggul saling menindih rapat)';
                }
              }
              // 6. Reverse Cowgirl / Membelakangi
              else if (activePos.contains('reverse') || activePos.contains('membelakangi')) {
                if (isCiuman) {
                  isDisabledByPosisi = true;
                  disabledReason = ' 🚫 (Tidak dapat diakses: Membelakangi wajah pasangan)';
                } else if (isPayudara) {
                  isDisabledByPosisi = true;
                  disabledReason = ' 🚫 (Tidak dapat diakses: Membelakangi dada pasangan)';
                } else if (isDoStimulasi) {
                  isDisabledByPosisi = true;
                  disabledReason = ' 🚫 (Tidak dapat diakses: Membelakangi posisi pasangan)';
                }
              }
              // 7. Cowgirl (Wanita di Atas - Menghadap Depan)
              else if (activePos.contains('cowgirl') || activePos.contains('wanita di atas') || activePos.contains('duduk di atas')) {
                if (isOral) {
                  isDisabledByPosisi = true;
                  disabledReason = ' 🚫 (Tidak dapat diakses: Sedang menunggangi)';
                } else if (isDoStimulasi) {
                  isDisabledByPosisi = true;
                  disabledReason = ' 🚫 (Tidak dapat diakses saat Cowgirl)';
                } else if (isPayudara) {
                  final textLower = c.text.toLowerCase();
                  if (textLower.contains('jilat') || textLower.contains('hisap') || textLower.contains('gigit')) {
                    isDisabledByPosisi = true;
                    disabledReason = ' 🚫 (Wajah terlalu jauh dari puting saat Cowgirl)';
                  }
                }
              }
              // 8. Standing / Against Wall (Berdiri / Menempel Dinding)
              else if (activePos.contains('standing') || activePos.contains('dinding')) {
                if (isDoStimulasi) {
                  isDisabledByPosisi = true;
                  disabledReason = ' 🚫 (Tidak dapat diakses: Tangan menopang tubuh)';
                }
              }
              // 9. Spooning (Sendok / Menyamping)
              else if (activePos.contains('spooning') || activePos.contains('sendok')) {
                if (isOral) {
                  isDisabledByPosisi = true;
                  disabledReason = ' 🚫 (Tidak dapat diakses: Berbaring menyamping)';
                } else if (isDoStimulasi) {
                  isDisabledByPosisi = true;
                  disabledReason = ' 🚫 (Tidak dapat diakses saat Spooning)';
                } else if (isPayudara) {
                  final textLower = c.text.toLowerCase();
                  if (textLower.contains('jilat') || textLower.contains('hisap') || textLower.contains('gigit')) {
                    isDisabledByPosisi = true;
                    disabledReason = ' 🚫 (Posisi menyamping: Mulut tidak dapat menjangkau puting)';
                  }
                }
              }
            }

            if (isDisabledByPosisi) {
              displayText += disabledReason;
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDisabledByPosisi
                      ? Colors.grey.shade900.withValues(alpha: 0.7)
                      : isGantiPosisi
                          ? const Color(0xFF4C1D95)
                          : const Color(0xFF312E81),
                  foregroundColor: isDisabledByPosisi ? Colors.redAccent.shade100 : Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: BorderSide(
                      color: isDisabledByPosisi
                          ? Colors.red.shade900.withValues(alpha: 0.6)
                          : isGantiPosisi
                              ? Colors.pinkAccent
                              : Colors.amber,
                      width: isGantiPosisi ? 1.8 : 1.2,
                    ),
                  ),
                  alignment: Alignment.centerLeft,
                  elevation: isDisabledByPosisi ? 0 : 4,
                ),
                onPressed: isDisabledByPosisi
                    ? null
                    : () {
                        if (c.onSelect != null) {
                          c.onSelect!(widget.player, widget.npc);
                        }

                        // Jika menekan tombol penetrasi (nomor 3) namun posisi seks belum dipilih:
                        // Redirect terlebih dahulu ke Node 4 (Menu Pilih Posisi Seks)
                        int? targetIndex = c.nextNodeIndex;
                        final bool isPenetrasiOption = c.text.contains('3.') || c.text.contains('Penetrasi');
                        if (isPenetrasiOption) {
                          final bool hasSelectedPos = widget.player.currentPosisiSeks != null && widget.player.currentPosisiSeks!.isNotEmpty;
                          if (!hasSelectedPos) {
                            targetIndex = 4; // Index Node 4 adalah Menu Posisi Seks
                          }
                        }

                        if (targetIndex != null) {
                          _loadNode(targetIndex);
                        } else {
                          // nextNodeIndex == null means this is a terminal choice → finish
                          _finishDialogue();
                        }
                      },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _getChoiceIconWidget(c.text, isDisabledByPosisi),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _stripEmojiPrefix(displayText),
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                          color: isDisabledByPosisi
                              ? Colors.redAccent.shade100
                              : isGantiPosisi
                                  ? Colors.amberAccent
                                  : Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }


  Widget _getChoiceIconWidget(String rawText, bool isDisabled) {
    final Color iconColor = isDisabled ? Colors.redAccent.shade100 : Colors.amber;
    if (rawText.contains('1.') || rawText.toLowerCase().contains('ciuman')) {
      return Icon(Icons.favorite, size: 18, color: iconColor);
    } else if (rawText.contains('2.') || rawText.toLowerCase().contains('oral')) {
      return Icon(Icons.record_voice_over, size: 18, color: iconColor);
    } else if (rawText.contains('3.') || rawText.toLowerCase().contains('penetrasi')) {
      return Icon(Icons.flash_on, size: 18, color: iconColor);
    } else if (rawText.contains('4.') || rawText.toLowerCase().contains('posisi')) {
      return Icon(Icons.accessibility_new, size: 18, color: iconColor);
    } else if (rawText.contains('5.') || rawText.toLowerCase().contains('stimulasi')) {
      return Icon(Icons.front_hand, size: 18, color: iconColor);
    } else if (rawText.contains('6.') || rawText.toLowerCase().contains('onani') || rawText.toLowerCase().contains('fingering')) {
      return Icon(Icons.touch_app, size: 18, color: iconColor);
    } else if (rawText.contains('7.') && (rawText.toLowerCase().contains('payudara') || rawText.toLowerCase().contains('dada'))) {
      return Icon(Icons.favorite_border, size: 18, color: iconColor);
    } else if (rawText.contains('8.') || rawText.toLowerCase().contains('ejakulasi') || rawText.toLowerCase().contains('klimaks')) {
      return Icon(Icons.water_drop, size: 18, color: iconColor);
    }
    return Icon(Icons.play_arrow, size: 18, color: iconColor);
  }

  String _stripEmojiPrefix(String text) {
    // Strip common emojis at the start of text options
    return text.replaceAll(RegExp(r'^[\u{1F300}-\u{1F9FF}\u{2600}-\u{26FF}\u{2700}-\u{27BF}\u{1F600}-\u{1F64F}\u{1F680}-\u{1F6FF}\u{1F1E0}-\u{1F1FF}\s]+', unicode: true), '').trim();
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
