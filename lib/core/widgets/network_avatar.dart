import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class NetworkAvatar extends StatelessWidget {
  final String imageUrl;
  final String name;
  final double size;
  final double borderRadius;
  final bool hasBorder;

  const NetworkAvatar({
    super.key,
    required this.imageUrl,
    required this.name,
    this.size = 48,
    this.borderRadius = 999,
    this.hasBorder = false,
  });

  String get _initials {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return 'S';
    if (parts.length == 1) return parts[0].substring(0, 1).toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    Widget avatarChild;

    if (imageUrl.isNotEmpty) {
      avatarChild = Image.network(
        imageUrl,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildFallback();
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            color: AppColors.surfaceSage,
            child: const Center(
              child: SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.primaryTeal,
                ),
              ),
            ),
          );
        },
      );
    } else {
      avatarChild = _buildFallback();
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        border: hasBorder
            ? Border.all(color: Colors.white, width: 2)
            : null,
        boxShadow: hasBorder
            ? [
                BoxShadow(
                  color: AppColors.primaryTeal.withValues(alpha: 0.1),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                )
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: avatarChild,
      ),
    );
  }

  Widget _buildFallback() {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryTealLight, AppColors.primaryTeal],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        _initials,
        style: TextStyle(
          color: AppColors.accentGold,
          fontWeight: FontWeight.bold,
          fontSize: size * 0.38,
        ),
      ),
    );
  }
}
