// lib/avatar/vn_character_view.dart
import 'package:flutter/material.dart';
import 'package:mylifesim/pilih_karakter/character.dart';
import 'package:mylifesim/avatar/avatar_age_rules.dart';
import 'package:mylifesim/avatar/avatar_generator.dart';

enum VNOutfitType { school, casual, formal, luxury }
enum VNEmotionType { neutral, happy, sad, angry, blush, surprised }

class VNCharacterView extends StatelessWidget {
  final Character character;
  final bool isActiveSpeaker;
  final double width;
  final double height;
  final String? customName;
  final VNEmotionType emotion;
  final VNOutfitType outfit;
  final String? customAvatarUrl;

  const VNCharacterView({
    super.key,
    required this.character,
    this.isActiveSpeaker = true,
    this.width = 240,
    this.height = 360,
    this.customName,
    this.emotion = VNEmotionType.neutral,
    this.outfit = VNOutfitType.casual,
    this.customAvatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    // Tentukan happiness sintetis berdasarkan emosi VN agar ekspresi muka DiceBear ikut berubah
    int synthHappiness = 50;
    if (emotion == VNEmotionType.happy || emotion == VNEmotionType.blush) {
      synthHappiness = 90;
    } else if (emotion == VNEmotionType.sad || emotion == VNEmotionType.angry) {
      synthHappiness = 20;
    }

    String avatarUrl;
    if (customAvatarUrl != null && customAvatarUrl!.isNotEmpty) {
      try {
        final uri = Uri.parse(customAvatarUrl!);
        final params = Map<String, String>.from(uri.queryParameters);
        params['eyes'] = AvatarGenerator.getEyeType(synthHappiness);
        params['eyebrows'] = AvatarGenerator.getEyebrowType(synthHappiness);
        params['mouth'] = AvatarGenerator.getMouthType(synthHappiness);
        avatarUrl = uri.replace(queryParameters: params).toString();
      } catch (_) {
        avatarUrl = customAvatarUrl!;
      }
    } else {
      avatarUrl = AvatarAgeRules.getAgeBasedAvatarUrl(
        character,
        happiness: synthHappiness,
      );
    }

    final isMale = character.gender.toLowerCase() == 'laki-laki' ||
        character.gender.toLowerCase() == 'male';

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutBack,
      width: width,
      height: height,
      transform: Matrix4.identity()
        ..scale(isActiveSpeaker ? 1.05 : 0.94),
      transformAlignment: Alignment.bottomCenter,
      child: ColorFiltered(
        colorFilter: ColorFilter.mode(
          isActiveSpeaker ? Colors.transparent : Colors.black.withValues(alpha: 0.35),
          BlendMode.darken,
        ),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: isActiveSpeaker ? 1.0 : 0.88,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Avatar Utama (DiceBear murni tanpa background box / badge)
              SizedBox(
                width: width,
                height: height,
                child: Image(
                  image: AvatarImageCache.getImageProvider(avatarUrl),
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      isMale ? Icons.face : Icons.face_3,
                      size: width * 0.5,
                      color: isMale ? Colors.blue : Colors.pink,
                    );
                  },
                ),
              ),

              // Emotion Reaction Icon Bubble (Jika Emosi Spesial)
              if (emotion != VNEmotionType.neutral)
                Positioned(
                  top: 10,
                  right: 15,
                  child: _buildEmotionBubble(),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmotionBubble() {
    String emoji = '😊';
    if (emotion == VNEmotionType.blush) emoji = '😳';
    if (emotion == VNEmotionType.angry) emoji = '💢';
    if (emotion == VNEmotionType.sad) emoji = '💧';
    if (emotion == VNEmotionType.surprised) emoji = '❗';

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 6,
          ),
        ],
      ),
      child: Text(
        emoji,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
