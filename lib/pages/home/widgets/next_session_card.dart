import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/network_avatar.dart';

class UpcomingSession {
  final String title;
  final String mentorName;
  final String mentorRole;
  final String mentorImage;
  final String time;
  final String duration;
  final String dateBadge;

  const UpcomingSession({
    required this.title,
    required this.mentorName,
    required this.mentorRole,
    required this.mentorImage,
    required this.time,
    required this.duration,
    required this.dateBadge,
  });
}

class NextSessionCard extends StatelessWidget {
  final UpcomingSession session;
  final VoidCallback onEnterRoom;

  const NextSessionCard({
    super.key,
    required this.session,
    required this.onEnterRoom,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryTeal,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryTeal.withValues(alpha: 0.22),
            blurRadius: 36,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          children: [

            Positioned(
              top: -48,
              right: -48,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.06),
                    width: 24,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: const Text(
                          'PRÓXIMA SESSÃO',
                          style: AppTextStyles.heroCardTag,
                        ),
                      ),
                      Text(
                        session.dateBadge,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textWhite70,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),


                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      NetworkAvatar(
                        imageUrl: session.mentorImage,
                        name: session.mentorName,
                        size: 68,
                        borderRadius: 18,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              session.title,
                              style: AppTextStyles.heroCardTitle,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'com ${session.mentorName}',
                              style: AppTextStyles.heroCardSubtitle,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),


                  Row(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 16,
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            session.time,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 20),
                      Row(
                        children: [
                          Icon(
                            Icons.videocam_outlined,
                            size: 18,
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            session.duration,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),


                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: onEnterRoom,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accentGoldButton,
                        foregroundColor: AppColors.primaryTeal,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.videocam_rounded, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Entrar na sala',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primaryTeal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
