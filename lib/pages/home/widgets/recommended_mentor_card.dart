import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/network_avatar.dart';
import 'mentor_booking_sheet.dart';

class RecommendedMentorCard extends StatelessWidget {
  final Mentor mentor;
  final VoidCallback onSelectMentor;
  final VoidCallback onExplore;

  const RecommendedMentorCard({
    super.key,
    required this.mentor,
    required this.onSelectMentor,
    required this.onExplore,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Expanded(
              child: Text(
                'Especialistas para você',
                style: AppTextStyles.heading2,
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onExplore,
              behavior: HitTestBehavior.opaque,
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Text('Explorar', style: AppTextStyles.textButton),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Material(
          color: AppColors.surfaceWarmGray,
          borderRadius: BorderRadius.circular(24),
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: onSelectMentor,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  NetworkAvatar(
                    imageUrl: mentor.image,
                    name: mentor.name,
                    size: 76,
                    borderRadius: 18,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          mentor.name,
                          style: AppTextStyles.mentorName,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          mentor.role,
                          style: AppTextStyles.mentorRole,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              size: 16,
                              color: AppColors.accentOchre,
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                '${mentor.rating} • disponível amanhã',
                                style: AppTextStyles.mentorStatus,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.arrow_forward_rounded,
                      size: 20,
                      color: AppColors.primaryTeal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
