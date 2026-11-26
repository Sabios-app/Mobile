import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class CounselorMetrics extends StatelessWidget {
  final int totalMentorings;
  final double averageRating;
  final int entrepreneursSupported;
  final double monthlyEarnings;

  const CounselorMetrics({
    super.key,
    this.totalMentorings = 128,
    this.averageRating = 4.9,
    this.entrepreneursSupported = 94,
    this.monthlyEarnings = 3600.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryTeal.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _MetricItem(
                  icon: Icons.check_circle_outline_rounded,
                  iconBg: const Color(0xFFE8F5E9),
                  iconColor: Colors.green.shade800,
                  title: 'MENTORIAS',
                  value: '$totalMentorings',
                  subtitle: 'Sessões de 1h',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _MetricItem(
                  icon: Icons.star_rounded,
                  iconBg: const Color(0xFFFFF8E1),
                  iconColor: AppColors.accentGold,
                  title: 'AVALIAÇÃO',
                  value: '${averageRating.toStringAsFixed(1).replaceAll('.', ',')} ★',
                  subtitle: 'Nota média',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _MetricItem(
                  icon: Icons.people_outline_rounded,
                  iconBg: const Color(0xFFE3F2FD),
                  iconColor: Colors.blue.shade800,
                  title: 'APOIADOS',
                  value: '$entrepreneursSupported',
                  subtitle: 'Pequenos negócios',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _MetricItem(
                  icon: Icons.attach_money_rounded,
                  iconBg: const Color(0xFFFFF3E0),
                  iconColor: Colors.orange.shade800,
                  title: 'GANHOS DO MÊS',
                  value: 'R\$ ${monthlyEarnings.toInt()}',
                  subtitle: 'No período',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricItem extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String value;
  final String subtitle;

  const _MetricItem({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.value,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceWarmGray,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontFamily: AppTextStyles.serifFamily,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
