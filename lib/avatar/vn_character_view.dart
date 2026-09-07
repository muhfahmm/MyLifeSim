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

    // Proteksi: Orang tua atau orang dewasa (umur >= 19) TIDAK BOLEH menggunakan Seragam Sekolah!
    VNOutfitType effectiveOutfit = outfit;
    final String cleanN = (customName ?? character.name).toLowerCase();
    final bool isAdultOrParent = character.age >= 19 ||
        cleanN.contains('ayah') ||
        cleanN.contains('ibu') ||
        cleanN.contains('paman') ||
        cleanN.contains('bibi') ||
        cleanN.contains('kakek') ||
        cleanN.contains('nenek') ||
        cleanN.contains('mertua');

    if (effectiveOutfit == VNOutfitType.school && isAdultOrParent) {
      effectiveOutfit = VNOutfitType.casual;
    }

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
            alignment: Alignment.bottomCenter,
            children: [
              // 1. Aura / Glow Efek Karakter Aktif
              if (isActiveSpeaker)
                Positioned(
                  bottom: 20,
                  child: Container(
                    width: width * 0.82,
                    height: height * 0.62,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: _getEmotionColor().withValues(alpha: 0.35),
                          blurRadius: 40,
                          spreadRadius: 15,
                        ),
                      ],
                    ),
                  ),
                ),

              // 2. Body Layer Bawah (Desain Busana & Pose Bawah Dinamis)
              Positioned(
                bottom: 0,
                child: _buildLowerBodyOutfit(isMale, effectiveOutfit),
              ),

              // 3. Avatar Utama (DiceBear Kepala & Dada)
              Positioned(
                top: 0,
                child: SizedBox(
                  width: width * 0.95,
                  height: height * 0.65,
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
              ),

              // 4. Gradient Vignette Halus di bagian bawah agar menyatu dengan layar VN
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: 60,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.65),
                      ],
                    ),
                  ),
                ),
              ),

              // 5. Emotion Reaction Icon Bubble (Jika Emosi Spesial)
              if (emotion != VNEmotionType.neutral)
                Positioned(
                  top: 10,
                  right: 15,
                  child: _buildEmotionBubble(),
                ),

              // 6. Name Badge Dinamis
              if (customName != null)
                Positioned(
                  bottom: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getEmotionColor(),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white, width: 1.5),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black38,
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: Text(
                      customName!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLowerBodyOutfit(bool isMale, [VNOutfitType? outfitOverride]) {
    final targetOutfit = outfitOverride ?? outfit;
    List<Color> colors;
    String outfitTitle;
    String outfitSub;
    IconData icon;

    switch (targetOutfit) {
      case VNOutfitType.school:
        colors = isMale
            ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
            : [const Color(0xFF1E1B4B), const Color(0xFF312E81)];
        outfitTitle = isMale ? 'Seragam Sekolah' : 'Seragam Siswi';
        outfitSub = isMale ? 'Kemeja & Celana Formal' : 'Kemeja & Rok Rempel';
        icon = Icons.school_rounded;
        break;
      case VNOutfitType.formal:
        colors = [const Color(0xFF18181B), const Color(0xFF27272A)];
        outfitTitle = isMale ? 'Setelan Jas Formal' : 'Setelan Blazer';
        outfitSub = isMale ? 'Jas Hitam & Dasi' : 'Blazer & Rok Pensil';
        icon = Icons.business_center_rounded;
        break;
      case VNOutfitType.luxury:
        colors = [const Color(0xFF4C1D95), const Color(0xFF701A75)];
        outfitTitle = isMale ? 'Tuxedo Pesta' : 'Gaun Malam Mewah';
        outfitSub = isMale ? 'Tuxedo & Dasi Kupu' : 'Gaun Pesta Elegan';
        icon = Icons.diamond_rounded;
        break;
      case VNOutfitType.casual:
        colors = isMale
            ? [const Color(0xFF0F4C81), const Color(0xFF1E293B)]
            : [const Color(0xFF831843), const Color(0xFF4C1D95)];
        outfitTitle = isMale ? 'Pakaian Santai' : 'Pakaian Kasual';
        outfitSub = isMale ? 'Kaos & Celana Jeans' : 'Kaos & Rok Santai';
        icon = Icons.checkroom_rounded;
        break;
    }

    return Container(
      width: width * 0.76,
      height: height * 0.48,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: colors,
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.15),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Graphic motif stripes / texture overlay
          Positioned.fill(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
              child: Opacity(
                opacity: 0.08,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    6,
                    (index) => Container(
                      width: 8,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      color: Colors.white70,
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    outfitTitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                      shadows: [
                        Shadow(color: Colors.black45, blurRadius: 4),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    outfitSub,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.65),
                      fontSize: 9.5,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getEmotionColor() {
    switch (emotion) {
      case VNEmotionType.happy:
        return Colors.orange.shade700;
      case VNEmotionType.blush:
        return Colors.pink.shade600;
      case VNEmotionType.angry:
        return Colors.red.shade700;
      case VNEmotionType.sad:
        return Colors.blue.shade700;
      case VNEmotionType.surprised:
        return Colors.purple.shade600;
      case VNEmotionType.neutral:
      default:
        return Colors.indigo.shade700;
    }
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
